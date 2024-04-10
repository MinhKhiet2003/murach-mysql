 --                                             Chapter 3



-- 8
select vendor_name, vendor_contact_last_name,vendor_contact_first_name
from vendors
order by vendor_contact_last_name, vendor_contact_first_name;

-- 9
select concat(vendor_contact_first_name, " ",vendor_contact_last_name ) as full_name
from vendors;

-- 10
select  invoice_due_date as Due_Date,
		invoice_total,
        invoice_total * 0.1 as invoice_10,
        invoice_total * 0.1 + invoice_total as invoice_total_plus
from invoices
where invoice_total * 0.1 + invoice_total >= 500 and invoice_total * 0.1 + invoice_total <= 1000;

-- 11
 select invoice_number, invoice_total,
	payment_total + credit_total as payment_credit_total,
    invoice_total - ( payment_total + credit_total ) as balance_due
from invoices
where invoice_total - ( payment_total + credit_total ) > 50
order by balance_due desc limit 5;

-- 12
select invoice_number,invoice_date,
		invoice_total - payment_total - credit_total as balandue,
        payment_date
from invoices
where payment_date is null;

-- 13
select date_format(invoice_date,'%m/%d/%Y/%W') as 'MM/DD/YYYY' 
from invoices;

-- 14
select 50000 as starting_principal,
		50000 * 0.065 as  interest,
       50000 + 50000 * 0.065 as principal_plus_interest;
       
       
 --                                            Chapter 4
 
 -- 2
 select v.vendor_name, i.invoice_number,i.invoice_date, 
		i.invoice_total - i.payment_total - credit_total as balance_due
from vendors v join invoices i on v.vendor_id = i.vendor_id
order by v.vendor_name;


-- 3
select v.vendor_name, v.default_account_number, g.account_description
from vendors v join general_ledger_accounts g on v.default_account_number = g.account_number
order by account_description, vendor_name;

       
-- 4
select 	v.vendor_name,
		i.invoice_date,i.invoice_number,
        li.invoice_sequence as li_senquence,li.line_item_amount as li_amount
from vendors v join invoices i on v.vendor_id = i.vendor_id
		join invoice_line_items li on i.invoice_id = li.invoice_id
order by v.vendor_name,i.invoice_date,i.invoice_number,li.invoice_sequence;

-- 5
select v1.vendor_id,v1.vendor_name, concat(v1.vendor_contact_first_name, " ",v1.vendor_contact_last_name) as contact_name
from vendors v1 join vendors v2 
	on v1.vendor_id <> v2.vendor_id 
where v1.vendor_contact_last_name = v2.vendor_contact_last_name
order by v1.vendor_contact_last_name;


-- 6 
select g.account_number,g.account_description,li.invoice_id
from general_ledger_accounts g left join invoice_line_items li
	on g.account_number = li.account_number
where li.invoice_id is null
order by g.account_number;


-- 7
select vendor_name,vendor_state
from vendors
where vendor_state = "CA"
union
select vendor_name, "outside CA " as vendor_state 
from vendors
where vendor_state != "CA"
order by vendor_name;

-- select vendor_name, if(vendor_state = "CA", vendor_state, "Outside CA") as vendor_state
-- from vendors;







 --                                            Chapter 5
 
-- 1
insert into terms value (6,"Net due 120 days ",120);

-- 2 
update terms
set terms_description = "Net due 125 days ",
	terms_due_days = 125
where terms_id = 6;

-- 3
delete from terms 
where terms_id = 6; 

-- 4 
INSERT INTO invoices 
VALUES (null, 32, 'AX-014-027', '2018-08-01', '434.58', '0.00', '0.00', 2, '2018-08-31', null);

-- 5 
INSERT INTO invoice_line_items 
VALUES (115, 1, 160, 180.23, 'Hard Drive'),
       (115, 2, 527, 254.35, 'Exchange Server update');
       
-- 6 
update invoices
SET credit_total = invoice_total * 0.1,
    payment_total = invoice_total - credit_total
where invoice_id = 116;

-- 7
update vendors
set default_account_number = 403
where vendor_id = 44;

-- 8
update invoices 
set terms_id = 2
where vendor_id in 
		(select vendor_id 
			from vendors
				where default_terms_id = 2);
-- update invoices i join vendors v on i.vendor_id = v.vendor_id
-- set terms_id = 2
-- where default_terms_id = 2 ;

-- select * from invoices i join vendors v on i.vendor_id = v.vendor_id where default_terms_id = 2 ;

-- 9
delete from invoice_line_item
where invoice_id = 116;

delete from invoices
where invoice_id = 116;
    
    
    
    
 --                                            Chapter 6
 
 -- 1
 select vendor_id, sum(invoice_total) as invoice_total
 from invoices
 group by vendor_id;
 
 -- 2
 select v.vendor_name, sum(i.payment_total) as payment_total
 from vendors v join invoices i on v.vendor_id = i.vendor_id
 group by v.vendor_id
 order by payment_total desc;
 
 -- 3
 select v.vendor_name, count(*) as invoice_count, sum(i.invoice_total) as invoice_total
  from vendors v join invoices i on v.vendor_id = i.vendor_id
 group by v.vendor_id
 order by invoice_total desc;
 
 -- 4
 select g.account_description, count(*) as invoice_count, sum(li.line_item_amount) as line_item_amount
from general_ledger_accounts g left join invoice_line_items li
	on g.account_number = li.account_number
group by g.account_description
having invoice_count > 1
order by line_item_amount desc;


-- 5
 select g.account_description, count(*) as invoice_count, sum(li.line_item_amount) as line_item_amount
from general_ledger_accounts g left join invoice_line_items li
	on g.account_number = li.account_number
    join invoices i on i.invoice_id = li.invoice_id
where i.invoice_date >= '2018-04-01' AND i.invoice_date <= '2018-06-30'
GROUP by g.account_description 
HAVING count_invoice > 1
order by total_invoice desc;

-- 6
select account_number, sum(line_item_amount) as line_item_amount
 from invoice_line_items
 group by account_number with rollup;
 
 
 -- 7
SELECT v.vendor_name, COUNT(DISTINCT li.account_number) AS account_count
FROM vendors AS v JOIN invoices AS i 
	ON v.vendor_id = i.vendor_id
		JOIN invoice_line_items AS li 
			ON li.invoice_id = i.invoice_id
GROUP BY v.vendor_name
HAVING account_count > 1;

-- 8

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    