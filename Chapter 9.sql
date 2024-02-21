-- 1
SELECT ROUND(invoice_total,1) as invoice_total_1, ROUND(invoice_total,0) as invoice_total_2,
		TRUNCATE(invoice_total,0) as invoice_total_3
FROM invoices


-- 2
SELECT start_date, 
    DATE_FORMAT(start_date, '%b/%d/%y') AS format1, 
    DATE_FORMAT(start_date, '%c/%e/%y') AS format2, 
    DATE_FORMAT(start_date, '%l:%i %p') AS twelve_hour,
    DATE_FORMAT(start_date, '%c/%e/%y %l:%i %p') AS format3 
FROM date_sample


-- 3
SELECT vendor_name,
    UPPER(vendor_name) AS vendor_name_upper,
    vendor_phone,
    SUBSTRING(vendor_phone, 11) AS last_digits,
    REPLACE(REPLACE(REPLACE(vendor_phone, '(', ''), ') ', '.'), '-', '.') AS phone_with_dots,
    IF(LOCATE(' ', vendor_name) = 0,
        '',
		IF(LOCATE(' ', vendor_name, LOCATE(' ', vendor_name) + 1) = 0,
			SUBSTRING(vendor_name, LOCATE(' ', vendor_name) + 1),
			SUBSTRING(vendor_name,
				LOCATE(' ', vendor_name) + 1,
                LOCATE(' ', vendor_name, LOCATE(' ', vendor_name) + 1) - LOCATE(' ', vendor_name))))
    AS second_word
FROM vendors

-- 4
SELECT invoice_number,
       invoice_date,
       DATE_ADD(invoice_date, INTERVAL 30 DAY) AS date_plus_30_days,
       payment_date,
       DATEDIFF(payment_date, invoice_date) AS days_to_pay,
       MONTH(invoice_date) AS "month",
       YEAR(invoice_date) AS "year"
FROM invoices
WHERE invoice_date > '2018-04-30' AND invoice_date < '2018-06-01'

-- 5
SELECT emp_name, REGEXP_SUBSTR(emp_name, '[A-Z]* ') AS first_name,
       REGEXP_SUBSTR(emp_name, '[A-Z]* [A-Z]*|[A-Z]*[-|\'][A-Z]*|[A-Z]*',
           REGEXP_INSTR(emp_name, ' ') + 1) AS last_name      
FROM string_sample


-- 6
SELECT invoice_number, invoice_total - payment_total - credit_total AS balance_due,
	   RANK() OVER(ORDER BY invoice_total - payment_total - credit_total DESC) AS balance_rank
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0