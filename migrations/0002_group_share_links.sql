CREATE TABLE group_share_links (
  token TEXT PRIMARY KEY,
  group_id TEXT NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  created_by_user_id TEXT NOT NULL REFERENCES users(id),
  expires_at TEXT NOT NULL,
  revoked_at TEXT
);
CREATE INDEX group_share_links_group_idx ON group_share_links(group_id);
