-- 1
select * from vendors;

-- 2
SELECT v.vendor_name,i.invoice_number,i.invoice_date, i.invoice_total - (i.payment_total + i.credit_total) AS balance_due
FROM invoices as i join vendors as v 
on i.vendor_id = v.vendor_id
ORDER by v.vendor_name desc;

-- 3
Select v.vendor_name, v.default__account_number as default_account, g.account_description as description
from vendors as v join general_ledger_accounts as g 
	on v.default__account_number = g.account_number
order by g.account_description, v.vendor_name DESC;

-- 4
SELECT v.vendor_name,i.invoice_date,i.invoice_number, il.invoice_sequence as li_sequence, il.line_item_amount as li_amount
FROM invoices as i join vendors as v 
on i.vendor_id = v.vendor_id join invoice_line_items as il ON i.invoice_id = il.invoice_id
ORDER by v.vendor_name, i.invoice_date,i.invoice_number, il.invoice_sequence desc

-- 5
select v1.vendor_id, v1.vendor_name, concat(v1.vendor_contact_first_name, " ", v1.vendor_contact_last_name) as contact_name
FROM vendors as v1 join vendors as v2 
	on v1.vendor_id <> v2.vendor_id and v1.vendor_contact_last_name = v2.vendor_contact_last_name
order by v1.vendor_contact_last_name;

-- 6

select g.account_number, g.account_description,il.invoice_id
FROM general_ledger_accounts as g left join invoice_line_items as il
	on il.account_number = g.account_number
WHERE il.invoice_id is null
order by g.account_number desc;

-- 7
select vendor_name, vendor_state
from vendors
WHERE vendor_state = 'CA'
UNION
select vendor_name,'Outside CA'
FROM vendors
WHERE vendor_state <> 'CA'
order by vendor_name;
