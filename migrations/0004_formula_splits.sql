ALTER TABLE expenses ADD COLUMN formula_json TEXT;

CREATE TABLE expense_answers (
  expense_id TEXT NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  person_id TEXT NOT NULL REFERENCES people(id),
  question_id TEXT NOT NULL,
  option_id TEXT NOT NULL,
  PRIMARY KEY (expense_id, person_id, question_id)
);

CREATE INDEX expense_answers_expense_idx ON expense_answers(expense_id);
