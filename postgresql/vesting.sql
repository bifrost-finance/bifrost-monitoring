CREATE TABLE IF NOT EXISTS "public"."vesting_investors" ("account" text UNIQUE);

INSERT INTO
    "public"."vesting_investors" ("account")
VALUES
    ('investor-1'),
    ('investor-2')
