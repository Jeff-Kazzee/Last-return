const { chromium } = require('playwright-core');

const baseUrl = process.env.LAST_RETURN_WEB_URL || 'http://127.0.0.1:8090/';
const chromiumPath = process.env.CHROMIUM_PATH || '/usr/bin/chromium';
const artifactDir = process.env.LAST_RETURN_WEB_ARTIFACTS || '/workspace/artifacts/web';

(async () => {
  const browser = await chromium.launch({
    headless: false,
    executablePath: chromiumPath,
    args: ['--no-sandbox', '--disable-dev-shm-usage', '--disable-gpu-sandbox', '--enable-unsafe-swiftshader'],
  });
  const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });
  const failures = [];
  const logs = [];
  page.on('pageerror', (error) => failures.push(`pageerror:${error.message}`));
  page.on('console', (msg) => {
    logs.push(`${msg.type()}:${msg.text()}`);
    if (msg.type() === 'error' && !msg.text().includes('favicon')) failures.push(`console:${msg.text()}`);
  });
  await page.goto(`${baseUrl}iframe-test.html`, { waitUntil: 'load', timeout: 30000 });
  await page.waitForFunction(
    () => window.messages.some((message) => message?.type === 'ARCADE_READY'),
    null,
    { timeout: 20000 },
  );
  const frame = page.frames().find((candidate) => candidate.url().includes('/index.html'));
  if (!frame) failures.push('Godot iframe did not mount');
  if (frame) {
    await frame.click('body');
    await frame.press('body', 'Enter');
    await page.waitForTimeout(1500);
  }
  await page.screenshot({ path: `${artifactDir}/iframe-duel.png` });
  const state = await page.evaluate(() => ({
    messages: window.messages,
    isolated: crossOriginIsolated,
    frames: document.querySelectorAll('iframe').length,
  }));
  if (state.frames !== 1) failures.push(`expected one iframe, got ${state.frames}`);
  if (!logs.some((line) => line.includes('Godot Engine v4.4.1'))) failures.push('Godot did not boot');
  const report = { result: failures.length ? 'FAIL' : 'PASS', state, failures, logs };
  require('fs').writeFileSync(`${artifactDir}/iframe-report.json`, JSON.stringify(report, null, 2));
  console.log(JSON.stringify(report, null, 2));
  await browser.close();
  process.exit(failures.length ? 1 : 0);
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
