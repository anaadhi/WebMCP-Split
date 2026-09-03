# Split Circle

A lightweight shared-expense site: create groups, add a purchase, optionally attach a bill photo, then split equally among selected people or enter custom amounts (including zero). AI can also create answer-driven formula splits, such as sharing alcohol only among drinkers. Formula splits remain unfinished and do not affect balances until every person answers their dynamic questions.

## Deploy to Cloudflare Workers

```bash
npm install
npx wrangler login
npm run deploy
```

For a local preview, run `npm run dev` and open http://localhost:8787.

## Shared groups: D1 + Google sign-in

1. Create a D1 database: `npx wrangler d1 create split-circle`.
2. Add the returned database ID to a `d1_databases` binding named `DB` in `wrangler.jsonc`, then run `npx wrangler d1 migrations apply split-circle --remote`.
3. Create a **Web application** OAuth client in Google Cloud. Add `https://YOUR-WORKER.workers.dev/auth/callback` (and `http://localhost:8787/auth/callback` for local testing) as exact authorized redirect URIs.
4. Store its values as Worker secrets: `npx wrangler secret put GOOGLE_CLIENT_ID` and `npx wrangler secret put GOOGLE_CLIENT_SECRET`.

When upgrading an existing deployment, apply the latest migration before deploying so formula questions and answers can be stored:

```bash
npx wrangler d1 migrations apply split-circle --remote
```

The schema creates unclaimed people with a unique `#xxxxxxxx` member ID. Member search only returns people who already share a group with the signed-in user. New typed names stay unclaimed; an owner can create a 14-day claim link through `POST /api/groups/:groupId/invitations`.

For a shared, multi-user version, use Cloudflare D1 for groups/splits and R2 for bill images; both have free allowances. This first deploy deliberately needs neither, keeping it immediately deployable and free.
