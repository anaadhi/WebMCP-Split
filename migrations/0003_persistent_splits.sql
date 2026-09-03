CREATE TABLE expenses (
  id TEXT PRIMARY KEY,
  group_id TEXT NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  total_cents INTEGER NOT NULL CHECK (total_cents > 0),
  payer_person_id TEXT NOT NULL REFERENCES people(id),
  split_method TEXT NOT NULL CHECK (split_method IN ('equal', 'custom')),
  comment TEXT,
  created_by_user_id TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE expense_shares (
  expense_id TEXT NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  person_id TEXT NOT NULL REFERENCES people(id),
  amount_cents INTEGER NOT NULL CHECK (amount_cents >= 0),
  PRIMARY KEY (expense_id, person_id)
);

CREATE INDEX expenses_group_idx ON expenses(group_id, created_at);
CREATE INDEX expense_shares_expense_idx ON expense_shares(expense_id);
