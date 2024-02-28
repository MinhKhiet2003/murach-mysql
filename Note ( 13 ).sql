-- Chương trình thường trú và các câu lệnh điều khiển 

-- stored procedure (thủ tục lưu trú): gọi thực hiện 1 cách độc lập
-- stored function (hàm lưu trú): sd như 1 thành phần của 1 biểu thức trong câu lệnh sql
-- trigger (loại chương trình): tự động thực hiện khi có câu lệnh insert update delete trên 
-- 								bảng trigger được tạo vào
-- event ( sự kiện ): thực hiện theo 1 lịch trình thiết lập trước 

-- làm
DROP PROCEDURE IF EXISTS test;
DELIMITER // -- bắt đầu định nghĩa thủ tục thì

-- định nghĩa
CREATE PROCEDURE test() -- tạo 1 thủ tục test ko có tham số truyền vào
BEGIN -- thân thủ tục
	DECLARE sum_balance DECIMAL(9, 2); -- khai báo biến kiểu số thập phân
    
    -- gán vào biến vừa tạo
    SELECT sum(invoice_total - payment_total - credit_total)
    INTO sum_balance
    from invoices
    WHERE vendor_id = 95;
    
    -- cái này khi call nó sẽ hiện
    if sum_balance > 0 THEN
    	SELECT CONCAT('Balance due: $', sum_balance) AS message;
    ELSE
    	SELECT 'Balance paid in full' as message;
    END IF;
END//

DELIMITER ;

-- gọi thủ tục
Call test();

-- > Procedure: Bao gồm 1 hoặc nhiều câu lệnh sql, lưu trú trên sever và đc thực hiện khi cần
-- Các câu lệnh có thể sử dụng:
	-- IF ... THEN
    -- 		statement_1
    -- ELSEIF ... THEN
    -- 		statement_2
    -- ELSE
    -- 		statement_3
    -- END IF;
    
	-- CASE so_luong
   	-- 		WHEN 12	THEN
    -- 			statement_1
    --      WHEN 13 THEN
    -- 			statement_2
    -- 		...
    -- 		ELSE
    -- 			statement
    -- END CASE;
   	-- hoặc có thể dùng cho trường hợp khác như là
	-- CASE
   	-- 		WHEN so_luong > 12 THEN
    -- 			statement_1
    --      WHEN so_luong < 13 THEN
    -- 			statement_2
    -- 		...
    -- 		ELSE
    -- 			statement
    -- END CASE;
    
    -- WHILE boolean_expression DO
    -- 		statement_1;
    -- END WHILE;
    
    -- cái dưới giống FOR
    -- REPEAT
    -- 		SET s = CONCAT(s, 'i = ', i, ' |');
    -- 		SET i = i + 1;
    -- UNTIL i = 4 (điều kiện kết thúc lặp)
    -- END REPEAT;
    
    -- testLoop : Loop
    -- 		SET s = CONCAT(s, 'i = ', i, ' | ');
    -- 		SET i = i + 1;
    
    -- 		IF i = 4 THEN
    -- 			LEAVE testLoop; (thoát lặp)
    -- 		END IF;
    -- END LOOP testLoop;
    
    -- dùng LEAVE để kết thúc lặp (giống break)
    -- dùng ITERATE (giống continue)
    

-- khai báo biến:
DECLARE 	ten_bien	data_type	[DEFAULT gtri_mac_dinh]; 
-- gán giá trị cho biến 
SET 	ten_bien = {gia_tri hoặc bieu_thuc};
-- hoặc dùng select để gán giá trị cho biến
SELECT column_1, column_2 ...
INTO ten_bien_1, ten_bien_2... -- tương đương với gán cột 1 cho tên 1, cột 2 cho tên 2

-- Dùng con trỏ khi muốn xử lý từng dòng dữ liệu  
	-- DECLARE ten_con_tro CURSOR FOR cau_lenh_select_tra_ve_tap_cac_hang
	-- DECLARE CONTINUE HANDLER FOR NOT FOUND handler_statement; 	(dùng để quản lý lỗi)
    -- OPEN ten_con_tro; 				(sau khi tạo báo cho mysql biết mình sẽ sử dụng con trỏ này)
    -- FETCH ten_con_tro INTO variable1, var2, var3, ...; 			(gán vào các biến tương ứng)
    -- CLOSE ten_con_tro;											(đóng con trỏ)
    
DECLARE row_not_found TINYINT DEFAULT FALSE;
DECLARE update_count INT DEFAULT 0;

DECLARE invoices_cursor CURSOR FOR
	SELECT invoice_id, invoice_total FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;
    
DECLARE CONTINUE HANDLER FOR not FOUND
	SET row_not_found = TRUE;
    
OPEN invoices_cursor;

WHILE row_not_found = FALSE DO
	FETCH invoices_cursor INTO invoice_id_var, invoice_total_var;
END WHILE;

CLOSE invoices_cursor;

-- DECLARE {CONTINUE|EXIT} HANDLER FOR NOT FOUND
-- Có thể sử dụng một số mã lỗi sau:
-- Lỗi mã 1329 | 02000: nạp dòng dữ liệu nhưng dòng đó ko tồn tại
-- Lỗi mã 1062 | 23000: chèn thêm giá trị nhưng bị trùng lặp và cột đó là UNIQUE
-- Lỗi mã 1048 | 23000: chèn null vào cột ko nhận null
-- Lỗi mã 1216 | 23000: insert hoặc update trên bảng ghi con và vi phạm ràng buộc tham chiếu (khóa ngoài)
-- Lỗi mã 1217 | 23000: sửa xóa bảng ghi cha và vi phạm ràng buộc tham chiếu (khóa ngoài)
DECLARE CONTINUE HANDLER FOR 1329
	SET ...
   
DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
	SET ...

-- hoặc sử dụng tên lỗi:
-- NOT FOUND: câu lệnh FETCh hoặc SELECT khi thực hiện nhưng ko tìm thấy thông tin họ cần
-- SQLEXCEPTION: tổng quát hơn các lỗi trên, bắt các lỗi chung, tất cả các lỗi
-- SQLWARNING: giống trên, khác ở chỗ nó lấy đc cả mã lỗi và lấy đc cả thông tin

-- Quản lý lỗi CONTINUE 
BEGIN
	DECLARE duplicate_entry TINYINT DEFAULT FALSE
    
    DECLARE CONTINUE HANDLER for 1062
    	SET duplicate_entry = TRUE;
        
    INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
    
    IF duplicate_entry = TRUE THEN
    	SELECT 'Row was not inserted - dublicate' AS message;
    ELSE
    	SELECT '1 row' AS message;
    END IF;
END//

-- Quản lý lỗi EXIT
BEGIN
	DECLARE duplicate_entry TINYINT DEFAULT FALSE
    
    BEGIN
        DECLARE EXIT HANDLER for 1062 -- lỗi nó sẽ gán True và con trỏ điều khiển sẽ thoát khỏi đó
            SET duplicate_entry = TRUE;

        INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
        
        SELECT '1 row' AS message;
    END;
    
    IF duplicate_entry = TRUE THEN
    	SELECT 'Row was not inserted - dublicate' AS message;
    END IF;
END//

