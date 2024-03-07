-- ====== NOTE CHƯƠNG 11 ======

-- === Tạo cơ sở dữ liệu ===
-- CREATE DATABASE [IF NOT EXISTS] db_name: tồn tại chưa, chưa tồn tại thì tạo
-- DROP DATABASE [IF NOT EXISTS] db_name: xóa 
-- USE db_name: mở csdl tương ứng để làm việc

-- chú ý: nếu ko ghi table_name mà ghi ap.table_name thì tức là nó tham chiếu đến database ap thoi

-- === Tạo bảng ===
-- CREATE TABLE 
-- (
-- 		column_name		data_type ... ,
-- ... )
-- === Các thuộc tính ===
-- NOT NULL, UNIQUE, DEFAULT default_value, AUTO_INCREMENT
-- == PRIMARY KEY: ràng buộc ở mức cột là sẽ thiết lập thuộc tính ở cột, còn ở mức bảng thì:
-- CONSTRAINT đặt_tên_bất_kỳ PRIMARY_KEY (invoice_id, vendor_id): 2 cái cùng làm khóa
-- == FOREIGN KEY: cũng vậy
-- mức cột: vendor_id	REFERENCES vendors (vendor_id)
-- mức bảng: CONSTRAINT đặt_tên_bất_kỳ FOREIGN_KEY (vendor_id) REFERENCES vendors (vendor_id)
-- ON DELETE CASCADE: xóa theo mô hình thác nước, xóa con là xóa tất cả các dl có liên quan (xóa cha)

-- === Thay đổi cột ===
-- ALTER TABLE tb_name{
-- 		ADD|MODIFY		column_name 	data_type |
-- 		DROP COLUMN 	column_name  |
-- 		RENAME COLUMN 	ten_cũ 		TO	 tên_mới |
-- 		ADD PRIMARY KEY tên_cột |
-- 		ADD [CONSTRAINT tên_bất_kỳ] FOREIGN KEY tên_côt|
-- 		DROP PRIMARY KEY |
-- 		DROP FOREIGN KEY tên_bất_kỳ_vừa_đặt
-- }

-- RENAME TABLE tên_cũ TO tên_mới
-- TRUNCATE TABLE tb_name: xóa dữ liệu trong bảng 
-- DROP TABLE tb_name: xóa bảng

-- ====== NOTE CREATE INDEX C11: Tạo chỉ mục ======
-- thường thì muốn lấy ra 1 hàng thì phải tìm kiếm tuần tự, nhưng giờ mình sắp xếp thì nó tìm kiếm
-- nhanh hơn, để tạo bảng phụ (bảng chỉ mục) thì:
-- CREATE [UNIQUE] INDEX index_name 
-- ON tb_name (column_name [ASC|DESC] ..., column_name_2 ....)
-- CREATE INDEX date_ix ON invoices (invoice_date DESC)
-- nếu thêm UNIQUE thì sẽ chỉ lấy các giá trị duy nhất
-- DROP INDEX date_ix ON invoices: xóa chỉ mục

-- ====== NOTE CHƯƠNG 12: CREATE VIEW ======
-- Dùng để thay đổi bản thiết kế, 1 bảng có thể tách ra thành 2 bảng con
-- Hạn chế cho ng dùng truy cập vào tất cả các cột, bảo mật
-- Cập nhật view nó sẽ cập nhật trực tiếp vào bảng
-- Đơn giản hóa các câu lệnh truy vấn, ví dụ truy vấn lồng.

-- CREATE VIEW vendors_min AS
--		SELECT vendor_name, vendor_state
--		FROM vendors

-- SELECT * FROM vendors_min

-- UPDATE vendors_min
-- SET vendor_phone = '(800) 555-3941'
-- WHERE vendor_name = 'Register of Copyrights'

-- DROP VIEW vendors_min

-- CREATE OR REPLACE VIEW invoices_outstanding
-- (invoice_number, invoice_date, invoice_total, balance_due) : có thể đặt tên ở đây hoặc trong select
-- AS SELECT invoice_number, invoice_date, invoice_total, invoice_total - payment_total
-- FROM invoices

-- điều kiện cập nhật view:
-- trong select ko đc dùng distinct, các hàm min max sum ..., group by having, union
-- UPDATE balance_due_view
-- SET credit_total = 300		OK
-- SET balance_due = 0   		Errol vì cột này xây dựng từ biểu thức, bảng chính ko có cột này
-- WHERE invoice_number = '9982771'

-- ==== WITH CHECK OPTION dùng để làm gì ?
-- CREATE OR REPLACE VIEW vendor_payment AS
  -- SELECT vendor_name, invoice_number, invoice_date, payment_date, invoice_total, credit_total
  -- FROM vendors JOIN invoices
  -- ON vendors.vendor_id = invoices.vendor_id
  -- WHERE invoice_total - payment_total - credit_total >= 0
-- WITH CHECK OPTION

-- SELECT * FROM vendor_payment
-- WHERE invoice_number = 'P-0608'

-- UPDATE vendor_payment
-- SET payment_total = 400.00,		OK
	-- payment_total = 30000.00, 	ERROL 
    		-- vì WITH CHECK OPTION nó báo lỗi vì biểu thức khi tạo VIEW sẽ sai ở WHERE, ở đó sẽ <0
	-- payment_date = '2018-08-01'	OK
-- WHERE invoice_number = 'P-0608'

-- thêm hóa đơn mới vào bảng thông qua view 
-- INSERT INTO ibm_invoices (invoice_number, invoice_date, invoice_total)
-- VALUES ('RA23988', '2018-07-31', 417.34) 
--> Câu truy vấn insert trên sai vì nó ko chứa đầy đủ các cột của bảng cha, cần thêm 1 số cột của cha

-- xóa trong view, nhưng thực chất nó sẽ xóa trong bảng invoice đã tạo ra view đó
-- DELETE FROM ibm_invoices
-- WHERE invoice_number = 'Q545443'
--> Lỗi bởi vì mã trên vi phạm, vì FOREIGN KEY còn cả ở bảng line_item_pk

--> Vậy muốn thực hiện thành công thì
-- DELETE FROM invoice_line_items : xóa trong line_item trước
-- WHERE invoice_id = (SELECT invoice_id FROM invoices
-- WHERE invoice_number = 'Q545443');
-- DELETE FROM ibm_invoices : xong mới xóa invoice
-- WHERE invoice_number = 'Q545443';
