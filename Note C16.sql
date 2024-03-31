-- Tự động thực hiện khi có thao tác insert, up, de, trên các bảng mà trigger gắn liền vào
-- for each row: với mỗi hàng trigger sẽ thực hiện 1 lần, như vậy nó có thể thao tác với nhiều hàng


delimiter //

create trigger trigger_name
before -- thực hiện trước khi có câu lệnh cập nhật dữ liệu trên csdl, after là thực hiện sau
update -- có thể thay bằng insert, delete
On vendors -- tên bảng thực hiện
for each row -- nếu câu lẹnh cần thực hiện 3 dòng thì câu lệnh create trigger sẽ đc thực hiện 3 lần
begin -- phần thân chương trình
	set NEW.vendor_state = UPPER(NEW.vendor_state); -- chuyển thành chữ hoa, nhưng ko phải chuyển tất cả
    -- mà chỉ chuyển các tên mới mà
    -- OLD hoặc NEW: thiết đặt là bản ghi mới hay cũ
    -- lưu ý: insert thì chỉ dùng NEW, update thì dùng đc cả 2, delete thì chỉ dùng OLD
end //

update vendors
set vendor_state = 'wi'
where vendor_id = 1;
-- kich hoạt cho triggger thực hiện, thay đổi sâu 'wi' thành in hoa, rồi mới cập nhật dữ liệu

-- kiểm tra kết quả, sẽ hiện nên vendor_state = 'WI'

-- VÍ DỤ 2:
delimiter //

create trigger test
	before update on invoices -- được thực hiện trước câu lệnh update trên bảng invoices
    for each row -- thực hiện trên mỗi dòng
begin -- bắt đầu nhiệm vụ của trigger
	declare sum decimal(9, 2); -- khai báo biến
    
    -- tính tổng của cái cột mà mình mới update vào, tức nó ktra gtri trc khi update
    select sum(line_item_count)
    into sum
    from invoice_line_items
    where invoice_id = NEW.invoice_id;
    
    -- nếu tổng sai, ko tương ứng với cột total thì nó báo lỗi
    if sum != NEW.invoice_total then
		signal sqlstate 'HY000'
			set message_text = 'loi';
	end if;
end//

update invoices
set invoice_total = 600
where invoice_id = 100;
-- nó báo lỗi do nó bị lệch giá trị

-- Ví dụ về các sử dụng trigger after

delimiter //

-- nếu chèn, nó sẽ có 1 cột và ghi inserted
create trigger test_insert
	after insert on invoices
    for each row
begin
	insert into invoices value
    (NEW.vendor_id, NEW.invoice_number, NEW.invoice_total, 'INSERTED', NOW());
end//

-- nếu xóa, nó chèn lại và ghi deleted, ý là nó thông báo cái này xóa r nhưng lại ko xóa
create trigger test_delete
	after delete on invoices
    for each row
begin
	insert into invoices value
    (OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 'DELETED', NOW());
end//

insert into invoices values
(115, 34, 14092.59, 'ZXA-080', NULL);
-- tức insert xong nó tự động thực hiện trigger và chèn thêm cột mới
-- chèn vào bảng hiện tại hoặc bảng khác tùy mình

DELETE FROM invoices WHERE invoice_id = 115
-- tức xóa xong nó chèn thêm cái đc ghi trong trigger vào
 
 
-- Cách hiển thị toàn bộ các trigger có trong csdl
SHOW triggers

-- Cách hiển thị tất cả triggers của csdl nào đó
show triggers in ap -- là trong csdl ap

-- tìm trigger trên hệ thống có tên bắt đầu bằng 3 ký tự 'ven'
show triggers in ap like 'ven%'

drop trigger ten_trigger;
drop trigger if exists ten_trigger;