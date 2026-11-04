const crypto = require('crypto');
const { chromium } = require('playwright-core');

const baseUrl = process.env.LAST_RETURN_WEB_URL || 'http://127.0.0.1:8090/';
const chromiumPath = process.env.CHROMIUM_PATH || '/usr/bin/chromium';
const artifactDir = process.env.LAST_RETURN_WEB_ARTIFACTS || '/workspace/artifacts/web';

function digest(buffer) {
  return crypto.createHash('sha256').update(buffer).digest('hex');
}

(async () => {
  const browser = await chromium.launch({
    headless: false,
    executablePath: chromiumPath,
    args: ['--no-sandbox', '--disable-dev-shm-usage', '--disable-gpu-sandbox', '--enable-unsafe-swiftshader'],
  });
  const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });
  const logs = [];
  const failures = [];
  page.on('console', (msg) => {
    logs.push(`${msg.type()}:${msg.text()}`);
    if (msg.type() === 'error') failures.push(`console error: ${msg.text()}`);
  });
  page.on('pageerror', (error) => failures.push(`page error: ${error.message}`));
  page.on('requestfailed', (request) => failures.push(`request failed: ${request.url()} ${request.failure()?.errorText}`));

  await page.goto(baseUrl, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(10000);
  const state = await page.evaluate(() => ({
    title: document.title,
    webgl2: !!document.createElement('canvas').getContext('webgl2'),
    isolated: crossOriginIsolated,
    canvas: [...document.querySelectorAll('canvas')].map((canvas) => [canvas.width, canvas.height]),
  }));
  if (state.title !== 'Last Return') failures.push(`unexpected title: ${state.title}`);
  if (!state.webgl2) failures.push('WebGL2 is unavailable');
  if (!state.isolated) failures.push('Cross-origin isolation is unavailable');
  if (!state.canvas.some(([width, height]) => width >= 600 && height >= 300)) failures.push('Godot canvas did not size to the viewport');
  if (!logs.some((line) => line.includes('Godot Engine v4.4.1'))) failures.push('Godot did not report a successful boot');

  const titleShot = await page.screenshot({ path: `${artifactDir}/title.png` });
  await page.keyboard.press('Enter');
  await page.waitForTimeout(2500);
  await page.keyboard.down('d');
  await page.waitForTimeout(500);
  await page.keyboard.up('d');
  const duelShot = await page.screenshot({ path: `${artifactDir}/duel.png` });
  await page.keyboard.press('Escape');
  await page.waitForTimeout(500);
  const pauseShot = await page.screenshot({ path: `${artifactDir}/pause.png` });

  const hashes = { title: digest(titleShot), duel: digest(duelShot), pause: digest(pauseShot) };
  if (new Set(Object.values(hashes)).size !== 3) failures.push('Rendered title/duel/pause states are not visually distinct');

  const report = { result: failures.length ? 'FAIL' : 'PASS', state, hashes, failures, logs };
  require('fs').writeFileSync(`${artifactDir}/report.json`, JSON.stringify(report, null, 2));
  console.log(JSON.stringify(report, null, 2));
  await browser.close();
  process.exit(failures.length ? 1 : 0);
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
