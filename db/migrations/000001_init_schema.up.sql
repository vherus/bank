CREATE TABLE "customer" (
  id                  uuid DEFAULT gen_random_uuid(),
  first_name          TEXT NOT NULL,
  last_name           TEXT NOT NULL,
  created_timestamp   TIMESTAMP DEFAULT NOW()::timestamp,
  PRIMARY KEY (id)
);

CREATE TYPE AccountType AS ENUM ('Personal', 'Business');
CREATE TYPE AccountSubType AS ENUM ('CurrentAccount', 'Savings', 'CreditCard');
CREATE TYPE AccountStatus AS ENUM ('Enabled', 'Disabled', 'Deleted', 'ProForma', 'Pending');
CREATE TYPE SwitchStatus AS ENUM ('UK.CASS.NotSwitched', 'UK.CASS.SwitchCompleted');
CREATE TYPE SchemeName AS ENUM ('UK.OBIE.SortCodeAccountNumber', 'UK.OBIE.IBAN', 'UK.OBIE.PAN');

CREATE TABLE "account" (
  id                        uuid DEFAULT gen_random_uuid(),
  customer_id               uuid NOT NULL,
  account_type              AccountType NOT NULL,
  account_subtype           AccountSubType NOT NULL,
  account_status            AccountStatus NOT NULL,
  status_update_timestamp   TIMESTAMP,
  currency                  VARCHAR(3),
  description               VARCHAR(35),
  sort_code                 integer NOT NULL,
  opening_timestamp         TIMESTAMP,
  created_timestamp         TIMESTAMP DEFAULT NOW()::timestamp,
  PRIMARY KEY               (id),
  FOREIGN KEY               (customer_id) REFERENCES "customers" (id),
  CONSTRAINT                valid_sort_code CHECK (sort_code BETWEEN 100000 AND 999999)
);

CREATE TABLE "account_scheme" (
  id                  uuid DEFAULT gen_random_uuid(),
  account_id          uuid NOT NULL,
  identification      VARCHAR(256) NOT NULL,
  scheme_name         SchemeName NOT NULL,
  name                VARCHAR(350),
  created_timestamp   TIMESTAMP DEFAULT NOW()::timestamp,
  PRIMARY KEY         (id),
  FOREIGN KEY         (account_id) REFERENCES "account" (id)
);
