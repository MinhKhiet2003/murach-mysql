-- 1
SELECT invoice_total,
       FORMAT(invoice_total, 1) AS total_format,
       CONVERT(invoice_total, SIGNED) AS total_convert, 
       CAST(invoice_total AS SIGNED) AS total_cast
FROM invoices

-- 2

SELECT invoice_date, 
       CAST(invoice_date AS DATETIME) AS invoice_datetime, 
       CAST(invoice_date AS CHAR(7)) AS invoice_char
FROM invoices



