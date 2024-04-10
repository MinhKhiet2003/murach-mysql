-- 1
select t.terms_id,t.terms_description, count(*) as invoice_count
from terms t left join invoices i on t.terms_id = i.terms_id
group by i.terms_id
order by invoice_count desc
limit 1;

-- 2
DROP VIEW IF EXISTS view_account_715105120;
create view view_account_715105120 
(
	account_number,
    account_description,
    vendor_count
)
as
select g.account_number, g.account_description, count(DISTINCT v.vendor_id)
from general_ledger_accounts g join vendors v on g.account_number = v.default_account_number
group by g.account_number;

select account_number, account_description, vendor_count
from view_account_715105120
where vendor_count = (select min(vendor_count) from View_Account_715105120)
order by vendor_count asc;


-- 3
use ap;
drop procedure if exists proc_715105120;
delimiter //
create procedure  proc_715105120 
(
	in vendor_id_param int,
    out total_invoice_param decimal(9,2),
    out	total_payment_param decimal(9,2),
    out total_credit_param 	decimal(9,2)
)
begin
	declare vendor_id_v  		int default vendor_id_param;
    declare total_invoice_param_v 	decimal(9,2);
    declare	total_payment_param_v 	decimal(9,2);
    declare total_credit_param_v	decimal(9,2);
    declare sql_err int default false;
    begin
		declare exit handler for not found
			set sql_err = true;
            
		select ti,tp,tc
		into total_invoice_param_v,total_payment_param_v,total_credit_param_v
		from (select vendor_id, sum(invoice_total) as ti, sum(payment_total) as tp, sum(credit_total) as tc
				from invoices 
				where vendor_id = vendor_id_v
				group by vendor_id) as table_new;
			
		set total_invoice_param = total_invoice_param_v;
		set total_payment_param = total_payment_param_v;
		set total_credit_param = total_credit_param_v;
    end;
    if sql_err = false then
		select "success" as message;
	else
		select "err" as message;
	end if;
end//

delimiter ;


call proc_715105120(110, @ti, @tp, @tc);
select Concat("it: ", @ti, ", pt: ", @tp, ", ct: ", @tc) as message_text_new;