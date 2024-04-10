-- 1
select g.account_description, sum(li.line_item_amount) as line_item_amount 
from general_ledger_accounts g join invoice_line_items li
	on g.account_number = li.account_number
group by g.account_description
having line_item_amount > (select avg(line_item_amount) from invoice_line_items);


-- 2

drop view if exists view_715105120;

create view view_715105120 as
	select g.account_number, g.account_description, count(v.vendor_id) as vendor_count
	from vendors v join general_ledger_accounts g 
	on v.default_account_number = g.account_number
	group by g.account_number;

select * from view_715105120
where vendor_count >= 5;

-- 3
drop function if exists func_715105120;
delimiter //
create function func_715105120 
(
	vendor_id_param 		int
)
returns int
deterministic
read sql data
begin
	declare result int default 0;
	select count(invoice_id) into result
    from invoices
    group by invoice_id
    
    return result;
end ;

delimiter ;

select func_715105120(123) as message;


-- 4






-- 4
drop function if exists ktra_proc_715105120;

delimiter //

create function ktra_proc_715105120 (
	terms_id_param			int
)
returns int
deterministic
reads sql data
begin
	declare trave int default 0;
    
    select 1 into trave
    from terms
    where terms_id = terms_id_param;
    
    return trave;
    
end//

delimiter ;

drop procedure if exists proc_715105120;

delimiter //

create procedure proc_715105120 (
	delete_term_param 		int,
    update_term_param		int
)
begin
	declare sql_error tinyint default false;
	
    declare continue handler for not found
		set sql_error = true;
    
    start transaction;
    
    update vendors
    set default_terms_id = update_term_param
    where default_terms_id = delete_term_param;
    
    update invoices
    set terms_id = update_term_param
    where terms_id = delete_term_param;
    
    delete from terms
    where terms_id = delete_term_param;
    
    if sql_error = false then
		select "Delete Successfully!" as message;
		commit;
	else
		select "Delete Unsuccessfully!" as message;
		rollback;
	end if;
    
end//

delimiter ;

call proc_715105120 (2, 5);
select * from terms;
select default_terms_id from vendors;
select terms_id from invoices;
