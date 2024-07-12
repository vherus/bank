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
  --id                  integer GENERATED ALWAYS AS IDENTITY
                        --(MINVALUE 10000000 MAXVALUE 99999999 START WITH 10000000 CACHE 20)
                        --PRIMARY KEY,
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

-- CREATE TABLE "transactions" (
--   id                      uuid DEFAULT gen_random_uuid(),
--   receiving_account_id    integer,
--   sending_account_id      integer,
--   ext_account_number      integer,
--   ext_account_sortcode    integer,
--   amount                  integer NOT NULL,
--   currency_code           VARCHAR(3) NOT NULL,
--   note                    VARCHAR(35),
--   created_timestamp       TIMESTAMP DEFAULT NOW()::timestamp,
--   PRIMARY KEY             (id),
--   FOREIGN KEY             (receiving_account_id) REFERENCES "accounts" (id),
--   FOREIGN KEY             (sending_account_id) REFERENCES "accounts" (id),
--   CONSTRAINT              valid_sort_code CHECK
--                             (ext_account_sortcode BETWEEN 100000 AND 999999),
--   CONSTRAINT              sender_and_receiver_cannot_both_be_null CHECK
--                             (NOT (receiving_account_id IS NULL AND sending_account_id IS NULL)),
--   CONSTRAINT              ext_acc_number_cannot_be_null_if_one_account_id_is_null CHECK 
--                             (CASE WHEN receiving_account_id IS NULL OR sending_account_id IS NULL THEN ext_account_number IS NOT NULL END),
--   CONSTRAINT              ext_acc_number_cannot_exist_when_has_sending_and_receiving CHECK
--                             (CASE WHEN receiving_account_id IS NOT NULL AND sending_account_id IS NOT NULL THEN ext_account_number IS NULL END)
-- );