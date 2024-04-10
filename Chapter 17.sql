-- 9
USE ap;

INSERT INTO invoices VALUES
(115, 97, '456789', '2018-08-01', 8344.50, 0, 0, 1, '2018-08-31', NULL);

-- clean up
-- DELETE FROM invoices WHERE invoice_id >= 115;

-- 10
SET GLOBAL  general_log = ON;

SELECT @@general_log;

-- 11
USE ap;

SELECT * FROM invoices;

-- 13
SET GLOBAL  general_log = OFF;

SELECT @@general_log;