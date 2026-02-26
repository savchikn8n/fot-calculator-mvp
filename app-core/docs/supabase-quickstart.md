# Supabase Quickstart (Phase 1)

1. Create a project in Supabase.
2. Open SQL Editor and run `supabase/schema.sql`.
3. In project settings copy:
- `Project URL`
- `anon public key`
4. Create `app-core/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
```

5. Run app:

```bash
cd app-core
npm run dev
```

6. Open app with workspace id:
- editor/view link: `http://localhost:3000/?w=default`
- forced view mode: `http://localhost:3000/?w=default&mode=view`

7. Add members manually in Supabase table `workspace_members`:
- `role = editor` can edit
- `role = viewer` read only

Next phase after this quickstart:
- add login UI in `public/legacy/index.html`
- load/save workspace state to `workspace_states`
- hard lock editing in `viewer` mode
