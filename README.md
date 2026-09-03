# Split Circle

A lightweight shared-expense site: create groups, add a purchase, then split equally among selected people or enter custom amounts (including zero). AI can also create answer-driven formula splits, such as sharing alcohol only among drinkers. Formula splits remain unfinished and do not affect balances until every person answers their dynamic questions.

## Deploy to Cloudflare Workers

```bash
npm install
npx wrangler login
npm run deploy
```

For a local preview, run `npm run dev` and open http://localhost:8787.

## WebMCP

When opened in a WebMCP-enabled browser, Split Circle registers four tools with `document.modelContext.registerTool`:

- `list_groups` discovers the signed-in user's groups.
- `get_group_members` returns stable member IDs for a selected group.
- `create_split_by_id` creates equal or custom persistent splits.
- `create_formula_split_by_id` creates answer-driven conditional splits.

The tools use the same authenticated API and D1 data as the visual interface, so actions performed by an agent remain visible and editable by people.

## Shared groups: D1 + Google sign-in

1. Create a D1 database: `npx wrangler d1 create split-circle`.
2. Add the returned database ID to a `d1_databases` binding named `DB` in `wrangler.jsonc`, then run `npx wrangler d1 migrations apply split-circle --remote`.
3. Create a **Web application** OAuth client in Google Cloud. Add `https://YOUR-WORKER.workers.dev/auth/callback` (and `http://localhost:8787/auth/callback` for local testing) as exact authorized redirect URIs.
4. Store its values as Worker secrets: `npx wrangler secret put GOOGLE_CLIENT_ID` and `npx wrangler secret put GOOGLE_CLIENT_SECRET`.

## Judge access

The login screen includes a dedicated judge sign-in that does not require a Google account. The username is configured as the non-secret `JUDGE_USERNAME` variable in `wrangler.jsonc`. Configure the password as a Worker secret before deployment:

```bash
npx wrangler secret put JUDGE_PASSWORD
```

For local development, copy `.dev.vars.example` to `.dev.vars` and replace the placeholder with a long random password. Never commit `.dev.vars` or put the real judge password in `wrangler.jsonc`. Add the username and password to the hackathon submission form.

When upgrading an existing deployment, apply the latest migration before deploying so formula questions and answers can be stored:

```bash
npx wrangler d1 migrations apply split-circle --remote
```

The schema creates unclaimed people with a unique `#xxxxxxxx` member ID. Member search only returns people who already share a group with the signed-in user. New typed names stay unclaimed; an owner can create a 14-day claim link through `POST /api/groups/:groupId/share-link`.

Cloudflare D1 stores users, sessions, groups, and splits. Bill-image storage is not implemented in this version.

## License

This project is available under the [MIT License](LICENSE).
