select * from vendors;
-- Tuan 3
-- 8
select vendor_name, vendor_contact_last_name, vendor_contact_first_name
from vendors
order BY vendor_contact_last_name,vendor_contact_first_name;


-- 9
SELECT CONCAT(vendor_contact_last_name, ', ', vendor_contact_first_name) AS full_name
FROM vendors
WHERE vendor_contact_last_name LIKE 'A%' OR vendor_contact_last_name LIKE 'B%' OR vendor_contact_last_name LIKE 'C%' OR vendor_contact_last_name LIKE 'E%'
ORDER BY vendor_contact_last_name ASC, vendor_contact_first_name ASC;


-- 10 
select * from invoices;

SELECT 
    invoice_due_date AS Due_Date,
    invoice_total,
    invoice_total * 0.1 AS Total,
    invoice_total * 1.1 AS Plus
FROM invoices
WHERE invoice_total >= 500 AND invoice_total <= 1000
ORDER BY invoice_due_date DESC;


-- 11

SELECT
    invoice_number,
    invoice_total,
    payment_total + credit_total AS payment_credit_total,
    invoice_total - (payment_total + credit_total) AS balance_due
FROM
    invoices
HAVING
    balance_due > 50
ORDER BY
    balance_due DESC
LIMIT 5;


-- 12

select 
	invoice_number, 
    invoice_date,
    invoice_total - (payment_total + credit_total) as balance_due,
    payment_date
FROM invoices
WHERE payment_date is null

-- 13

SELECT DATE_FORMAT(CURRENT_DATE(), 'mm-dd-yyyy') AS 'current_date';

-- 14

SELECT
    50000 AS starting_principal,
    50000 * 0.065 AS interest,
    50000 + (50000 * 0.065) AS principal_plus_interest;


