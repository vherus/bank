CREATE TABLE "customers" (
  id                  uuid DEFAULT gen_random_uuid(),
  first_name          TEXT NOT NULL,
  last_name           TEXT NOT NULL,
  created_timestamp   TIMESTAMP DEFAULT NOW()::timestamp,
  PRIMARY KEY (id)
);

CREATE TYPE AccountType AS ENUM ('Current', 'Savings');

CREATE TABLE "accounts" (
  id                  integer GENERATED ALWAYS AS IDENTITY
                        (MINVALUE 10000000 MAXVALUE 99999999 START WITH 10000000 CACHE 20)
                        PRIMARY KEY,
  customer_id         uuid NOT NULL,
  account_type        AccountType NOT NULL,
  label               VARCHAR(20),
  sort_code           integer NOT NULL,
  created_timestamp   TIMESTAMP DEFAULT NOW()::timestamp,
  FOREIGN KEY         (customer_id) REFERENCES "customers" (id),
  CONSTRAINT          valid_sort_code CHECK (sort_code BETWEEN 100000 AND 999999)
);

CREATE TABLE "transactions" (
  id                      uuid DEFAULT gen_random_uuid(),
  receiving_account_id    integer,
  sending_account_id      integer,
  ext_account_number      integer,
  ext_account_sortcode    integer,
  amount                  integer NOT NULL,
  note                    VARCHAR(35),
  created_timestamp       TIMESTAMP DEFAULT NOW()::timestamp,
  PRIMARY KEY             (id),
  FOREIGN KEY             (receiving_account_id) REFERENCES "accounts" (id),
  FOREIGN KEY             (sending_account_id) REFERENCES "accounts" (id),
  CONSTRAINT              valid_sort_code CHECK
        (ext_account_sortcode BETWEEN 100000 AND 999999),
  CONSTRAINT              sender_and_receiver_cannot_both_be_null CHECK
  							            (NOT (receiving_account_id IS NULL AND sending_account_id IS NULL)),
  CONSTRAINT			        ext_acc_number_cannot_be_null_if_one_account_id_is_null CHECK 
  							            (CASE WHEN receiving_account_id IS NULL OR sending_account_id IS NULL THEN ext_account_number IS NOT NULL END),
  CONSTRAINT			        ext_acc_number_cannot_exist_when_has_sending_and_receiving CHECK
  							            (CASE WHEN receiving_account_id IS NOT NULL AND sending_account_id IS NOT NULL THEN ext_account_number IS NULL END)
);