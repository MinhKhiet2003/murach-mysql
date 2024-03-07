-- Ví dụ A chuyển tiền cho B, A+ tiền, B- tiền, thì phải thực hiện đồng thời câu lệnh
-- 2 Câu lệnh truy vấn cùng lúc nhưng 1 lệch thực hiện 1 lệnh lỗi thì sẽ dẫn đến sai dữ liệu
-- Suy ra: Dùng cơ chế quản lý giao tác, tức nếu 1 cái lỗi thì tất cả thay đổi sẽ được thu hồi

-- Dùng khi nào ???
-- dùng khi thực hiện nhiều câu lệnh insert, update, delete
-- dùng để di chuyển từ bảng này sang bảng khác insert update
-- sự thất bại của insert và delete ảnh hưởng đến dữ liệu bản ghi

-- thường thì MySQL sẽ tự động commit, nhưng khi mình có thể quản lý đc commit đó
-- thường ko dùng các câu lệnh tạo hay định nghĩa dữ liệu trong transaction
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	declare sql_error TINYINT DEFAULT FALSE;
    
    declare continue handler for sqlexception
    set sql_error = true;
    
    -- bắt đầu giao tác
    start transaction;
    
    insert into invoices
    value (115, 34, 'EXA-080', '2018-01-18', 14092.59, 0, 0, 3, '2018-04-18', null);
    
    insert into invoice_line_items
    value (115, 1, 160, 4447.23, 'HW upgrade');
    
    insert into invoice_line_items
    value (115, 2, 167, 9645.36, 'OS upgrade');
    
    if sql_error = false then -- tức giao tác ko lỗi
		commit; -- xác thực với ht, ht cần lưu thay đổi có trong giao tác trên
        select 'The transaction was committed.';
	else
		rollback; -- ht sẽ phục hồi lại tất cả các thay đổi gây ra trong insert
        select 'The transaction was rolled back.';
	end if;
END//

DELIMITER ;

-- ============================
-- Cách MySQL sd điểm đánh dấu để chia transaction thành nhiều phần để giúp câu lệnh 
-- thực hiện hiệu quả hơn.

-- Giúp hủy bỏ ở 1 điểm bất kỳ trong giao tác
-- Giúp quản lý nhiều câu lệnh cập nhật dữ liệu

start transaction; -- bắt đầu giao tác
  
savepoint before_invoice; -- điểm đánh dấu đầu tiên
insert into invoices
value (115, 34, 'EXA-080', '2018-01-18', 14092.59, 0, 0, 3, '2018-04-18', null);
    
savepoint before_line_item1; -- điểm đánh dấu thứ 2
insert into invoice_line_items
value (115, 1, 160, 4447.23, 'HW upgrade');
   
savepoint before_line_item2; -- điểm đánh dấu thứ 3
insert into invoice_line_items
value (115, 2, 167, 9645.36, 'OS upgrade');

rollback to savepoint before_line_item2; -- câu lệnh insert 3 được hủy bỏ
rollback to savepoint before_line_item1; -- câu lệnh nằm giữa điểm đánh dấu 2 và 1
										-- là câu insert thứ 2, hủy bỏ câu đó
rollback to savepoint before_invoice; -- chính là câu insert 1 sẽ hủy bỏ

commit; -- tức csdl ap sẽ ko thực hiện gì cả, vì 3 cái đều rollback


-- ============================
-- Xử lý tương tranh trong MySQL
-- Giả sử 2 transaction A và B đều thực hiện sửa dữ liệu trên 1 hàng dữ liệu
-- A, B cùng thực hiện mà ko xử lý tương tranh của 2 cái này thì sẽ bị lỗi 
-- MySQL xử lý: khi A thực hiện thì MySQL sẽ locking, thực hiện xong mới cho B thực hiện

-- tức ht sẽ hỗ trợ 2 hay nhiều giao tác làm việc cùng nhau trong cùng 1 thời điểm
-- tự động ngăn cản tương tranh dữ liệu bằng cách dùng lock
-- chỉ xảy ra khi thực hiện các câu lệnh insert update delete


-- ============================
-- 4 vấn đề tương tranh xảy ra trong MySQL mà ngăn cản được
-- Lost updates: Cùng thực hiện nên cái update nào sau sẽ ghi đè vào cái update trước
-- Dirty reads: đọc dữ liệu mà chưa được thay đổi, tức B đọc nhưng A chưa commit sự thay đổi
-- 				nếu A mà thực hiện rollback để thu hồi thay đổi thì B sẽ đọc dữ liệu ko nằm
-- 				trong csdl
-- Nonrepetable reads: 2 câu lệnh lấy 2 giá trị khác nhau do có 1 ng thứ 3 vừa cập nhật
-- Phantom reads: Thực hiện thao tác cập nhật, xóa trong cùng 1 thời điểm, 2 giao tác đụng
-- 			nhau, ví dụ A delete nhưng B lại insert, do vậy khi A xóa xong nhg dl vẫn còn

