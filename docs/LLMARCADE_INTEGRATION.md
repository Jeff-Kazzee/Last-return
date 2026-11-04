# LLM Arcade integration boundary

**Discovery date:** 2026-11-04  
**Target:** `https://llmarcade.fun`  
**Current game revision:** `3eac72d15d11f9852de88c384f26d868510ec993`

## Observed public facts

- `llmarcade.fun` and `www.llmarcade.fun` return HTTP 200 and redirect to `www`.
- The site is hosted on Vercel (`server: Vercel`, `x-vercel-*`).
- Public HTML identifies **LLM Arcade · Zero human-written code** and an opening-soon landing app.
- The production JavaScript references routes including `/games`, `/game/`, `/assets/games/`, `/playtest`, and `/most-played`.
- The client is Supabase-backed. The public client configuration uses the Supabase project host `afcqhievsmnepxopetkt.supabase.co`.
- The actual organization is **`LLM-Arcade`** (`https://github.com/LLM-Arcade`), created 2026-11-04. It currently exposes zero public repositories.
- No source repository, Vercel project, DNS account, Supabase dashboard, or LLM Arcade platform API contract is exposed to this coding environment.

## Access currently available to this worker

| Capability | Current status |
| --- | --- |
| GitHub repository | Only `Jeff-Kazzee/Last-return`; branch push and PR creation work |
| GitHub organization `LLM-Arcade` | Visible publicly, but not installed/accessible to this App; 0 public repositories |
| Repository transfer / organization administration | Not accessible. `cline-cloud` lacks repository administration and organization permissions. |
| GitHub settings, secrets, branch protections | Not accessible |
| GitHub workflow-file creation | Denied by GitHub App permission |
| Cloudflare account | Not authenticated; no API token or connector visible |
| Vercel project/account | Not authenticated; no CLI token visible |
| `llmarcade.fun` DNS | Read-only public DNS; Porkbun nameservers |
| Public web inspection | Available |
| Godot, Node, Chromium, Xvfb | Available locally in the worker |

## Required integration choices

### Required GitHub installation step

The owner must install the Cline Cloud GitHub App on `LLM-Arcade` and grant access to the intended repository:

1. Open https://github.com/apps/cline-cloud/installations/new.
2. Select **LLM-Arcade**.
3. Grant access to the existing LLM Arcade site repository and/or the new Last Return repository.
4. Reply with the exact repository slug.

A repository transfer itself is owner-only: GitHub Settings → General → Danger Zone → Transfer, with `LLM-Arcade` as the destination. This worker cannot perform that transfer with the current App installation.

### Preferred: game inside the existing LLM Arcade site

1. Add this worker to the existing LLM Arcade source repository, or create `llmarcade/last-return` and install the Cline GitHub App on the organization.
2. Deploy the Godot export to the catalog at a path such as `/games/last-return/`.
3. Add catalog metadata through the platform's actual schema/API—not by guessing or writing directly with the public anonymous key.
4. Configure COOP/COEP on the isolated game document/assets:
   ```text
   Cross-Origin-Opener-Policy: same-origin
   Cross-Origin-Embedder-Policy: require-corp
   ```
5. Integrate the title screen and `/game/last-return` route into the existing LLM Arcade UX, high-score system, and access policy only with owner-approved APIs.

Required grants: LLM Arcade GitHub repository write access **or** `llmarcade` organization + repository creation/installation; Vercel project access (or the existing deployment workflow); and any platform API/schema documentation needed for game registration.

### Separate subdomain

Use `last-return.llmarcade.fun` for the static game and link it from the LLM Arcade catalog.

Required grants: Vercel project access for a static project plus the ability to add a CNAME at Porkbun/dns host. The current DNS is not managed by Cloudflare.

### Cloudflare Pages

Cloudflare Pages remains technically ready but is not the current production host. It would require a scoped Pages token and a DNS change at the `llmarcade.fun` DNS provider.

## Non-negotiable security boundary

- Do not use the public Supabase publishable key for administrative writes.
- Do not paste API tokens into source, PR comments, screenshots, or chat.
- Do not create or modify GitHub organizations, DNS, or production projects without owner authorization.
- Do not claim an LLM Arcade deployment until a production URL is served by an authenticated account and behavior is verified from the public internet.

## Fastest unblock

Expose an existing LLM Arcade repository/project to this worker, or provide a project-scoped Vercel token and the GitHub repository access. The current game artifact is already browser-verified and ready to place at `/games/last-return/`; the missing piece is the platform destination, not the game build.
