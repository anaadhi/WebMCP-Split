CREATE TRIGGER lock_completed_formula_answers
BEFORE UPDATE ON expense_answers
WHEN (
  SELECT COUNT(*) FROM expense_answers WHERE expense_id = OLD.expense_id
) >= (
  SELECT json_array_length(formula_json, '$.memberIds') * json_array_length(formula_json, '$.questions')
  FROM expenses
  WHERE id = OLD.expense_id
)
BEGIN
  SELECT RAISE(ABORT, 'Formula answers are locked.');
END;
