-- 1
SELECT vendor_id, SUM(invoice_total) AS total_invoice
FROM invoices
GROUP BY vendor_id;

-- 2
SELECT v.vendor_name, i.payment_total
from vendors as v join invoices as i on v.vendor_id = i.vendor_id
order by i.payment_total desc;

-- 3
select v.vendor_name, count(i.invoice_id) as invoice_count, sum(i.invoice_total) as total_invoice
from vendors as v join invoices as i 
	on v.vendor_id = i.vendor_id
group by v.vendor_id, v.vendor_name
ORDER by invoice_count desc;

-- 4
select g.account_description, count(li.invoice_id) as count_invoice, sum(li.line_item_amount) as total_invoice
from general_ledger_accounts as g join invoice_line_items as li
	on g.account_number = li.account_number
GROUP by g.account_description 
HAVING count_invoice > 1
order by total_invoice desc;

-- 5
select g.account_description, count(li.invoice_id) as count_invoice, sum(li.line_item_amount) as total_invoice
from general_ledger_accounts as g join invoice_line_items as li
	on g.account_number = li.account_number
    JOIN invoices AS i ON li.invoice_id = i.invoice_id
where i.invoice_date >= '2018-04-01' AND i.invoice_date <= '2018-06-30'
GROUP by g.account_description 
HAVING count_invoice > 1
order by total_invoice desc;

-- 6
select account_number, sum(line_item_amount) as total_item
from invoice_line_items
GROUP BY account_number WITH ROLLUP;

-- 7
SELECT v.vendor_name, COUNT(DISTINCT li.account_number) AS account_count
FROM vendors AS v
JOIN invoices AS i ON v.vendor_id = i.vendor_id
JOIN invoice_line_items AS li ON li.invoice_id = i.invoice_id
GROUP BY v.vendor_name
HAVING account_count > 1;

-- 8
SELECT  terms_id,vendor_id,
  MAX(payment_date) AS last_payment_date,
  SUM(invoice_total - payment_total - credit_total) AS total_amount_due
FROM invoices
GROUP BY terms_id, vendor_id WITH ROLLUP;

-- SELECT IF(GROUPING(terms_id) = 1, 'Grand Totals', terms_id) AS terms_id,
--     IF(GROUPING(vendor_id) = 1, 'Terms ID Totals', vendor_id) AS vendor_id,
--     MAX(payment_date) AS max_payment_date,
 --    SUM(invoice_total - credit_total - payment_total) AS balance_due
-- FROM invoices
-- GROUP BY terms_id, vendor_id WITH ROLLUP;

-- 9
SELECT 
  vendor_id,
  invoice_total - payment_total - credit_total AS balance_due,
  SUM(invoice_total - payment_total - credit_total) OVER () AS total_balance_due_all_vendors,
  SUM(invoice_total - payment_total - credit_total) OVER (PARTITION BY vendor_id ORDER BY balance_due) AS total_balance_due_by_vendor
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

-- 10
SELECT 
  vendor_id,
  invoice_total - payment_total - credit_total AS balance_due,
  AVG(invoice_total - payment_total - credit_total) OVER w AS average_balance_due_by_vendor,
  SUM(invoice_total - payment_total - credit_total) OVER () AS total_balance_due_all_vendors,
  SUM(invoice_total - payment_total - credit_total) OVER w AS total_balance_due_by_vendor
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0
WINDOW w AS (PARTITION BY vendor_id ORDER BY balance_due);

-- 11
SELECT 
  DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
  SUM(invoice_total) AS total_invoice,
  AVG(SUM(invoice_total)) OVER (ORDER BY invoice_date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS moving_average
FROM invoices
GROUP BY invoice_month
ORDER BY invoice_month;
