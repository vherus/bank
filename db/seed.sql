TRUNCATE transactions, accounts, customers;

INSERT INTO customers
  (first_name, last_name)
VALUES
  ('Nathan', 'King'),
  ('Matthew', 'Bellamy'),
  ('Christopher', 'Wolstenholme'),
  ('Dominic', 'Howard');

INSERT INTO accounts (customer_id, account_type, label, sort_code)
  SELECT customers.id, 'Current', 'Main', 620262 FROM customers WHERE first_name = 'Nathan';

INSERT INTO accounts (customer_id, account_type, label, sort_code)
  SELECT customers.id, 'Savings', 'Retirement', 620262 FROM customers WHERE first_name = 'Nathan';

INSERT INTO accounts (customer_id, account_type, label, sort_code)
  SELECT customers.id, 'Current', 'Income', 620262 FROM customers WHERE first_name = 'Matthew';

INSERT INTO accounts (customer_id, account_type, label, sort_code)
  SELECT customers.id, 'Savings', 'Bass Strings', 620262 FROM customers WHERE first_name = 'Christopher';

INSERT INTO accounts (customer_id, account_type, label, sort_code)
  SELECT customers.id, 'Current', 'Sticks', 620262 FROM customers WHERE first_name = 'Dominic';