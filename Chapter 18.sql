-- 2
CREATE USER ray@localhost IDENTIFIED BY 'temporary'
PASSWORD EXPIRE INTERVAL 90 DAY;

GRANT SELECT, INSERT, UPDATE
ON ap.vendors
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE
ON ap.invoices
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- 8
GRANT UPDATE
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- 9
CREATE USER dorothy IDENTIFIED BY 'sesame';

CREATE ROLE ap_user;

GRANT SELECT, INSERT, UPDATE
ON ap.*
TO ap_user;

GRANT ap_user
TO dorothy;

-- 10
SHOW GRANTS

-- 12
SELECT CURRENT_ROLE()

-- 14
SET DEFAULT ROLE ap_user to dorothy