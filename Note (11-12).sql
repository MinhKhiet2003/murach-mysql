-- ===== Note C8: Các kiểu dữ liệu =====

-- CHAR(10):  'CA          '    tức là nó điền thêm ký tự trắng nếu thừa
-- VARCHAR(50): 'CA'    kiểu này nó sẽ đỡ tốn hơn là CHAR

-- INT : lưu đc cả số âm số dương (99, -99)
-- INT UNSIGNED: chỉ lưu được số dương, lưu số âm nó sẽ ko nhận (99, NONE)
-- INT(4) ZEROFILL: số 99 nó sẽ hiển thị thành 0099, tức đưa thêm số 0 vào chỗ trống

-- DECIMAL(18, 9): 123456.89000000 , 18 là số 
-- DOUBLE

-- DATE
-- trả về 2018-08-15, năm - tháng - ngày 
-- nhưng insert ghi 18-8-15 hoặc ghi đầy đủ hoặc ghi 2018.08.15 hoặc '20180815' hoặc 20180815
-- khi ghi như vậy thì nó đề quy về định dạng 2018-08-15 
-- còn nếu ghi 18/8/15 hoặc 8/15/18 hoặc 2018-02-31 nó sẽ lỗi
-- TIME
-- phút cũng tương tự, 19:30 hoặc 19:32:11 hoặc 193211, nhập quá số giây, giờ hoặc phút nó sẽ lỗi
-- DATETIME , TIMESTAMP
-- 2018-08-15 19:32:11, còn nếu ko ghi giờ phút giây nó tự hiểu là 00:00:00

-- ENUM : chỉ cho phép 1 cột chứ 1 giá trị
-- dùng khi muốn giới hạn 1 số giá trị trông cột, ví dụ ENUM('yes', 'no', 'maybe')
-- tức nếu ghi các từ khác thì nó sẽ lỗi
-- SET : giống enum nhưng cho phép nhiều giá trị 
-- ví dụ SET('yes', 'no', 'maybe') thì ghi 'yes, no' nó sẽ lưu cả 2 'yes, no' 

-- LONGBLOB, MEDIUMBLOG, BLOB, TINYBLOB cho phép lưu ảnh, âm thanh
-- LONGTEXT, MEDIUMTEXT, ... cho lưu văn bản

-- Chuyển đổi kiểu dữ liệu
-- SELECT CONCAT('$', total)
-- 		  98/total
-- 		  total+1
 
-- Chuyển kiểu tường minh trong 1 số TH
-- CAST(ten_cot AS cast_type)
-- CONVERT(ten_cot, cast_type)
-- 2 cái này giống nhau
-- cast_type: 
-- CHAR[(N)]: chuyển sang ký tự,
-- DATE, DATETIME, TIME, 
-- SIGNED [INTEGER]: chuyển sang số nguyên, 
-- UNSIGNED [INTEGER], DECIMAL[(M[, D])]
-- ví dụ ép kiểu:  emp_id SIGNED

-- FORMAT(number, decimal)
-- FORMAT(1234567.8901, 2):  1,234,567.89
-- FORMAT(1234.56, 0): 1235
-- FORMAT(1234.56, 4): 1,234.5600
-- CHAR(value1[,value2]...)
-- CHAR(13,10) dùng để xuống dòng, CONCAT( ..., CHAR(13,10), ...)

-- ===== Note C9: Các hàm =====

-- CONCAT()
-- LTRIM(string), RTRIM(string), TRIM()
-- TRIM([[BOTH | LEADING | TRAILING] [remove] FROM] str)
-- TRIM(BOTH '*' FROM '****MySQL****') in ra 'MySQL'
-- LENGTH(string)
-- LOCATE(find, search[, start]) :tìm kiếm 1 giá trị trong xâu
-- ví dụ LOCATE(' ', chuỗi): trả về vị trí dấu cách đầu tiên trong chuỗi
-- ví dụ LOCATE(' ', chuỗi, LOCATE(' ', chuỗi) + 1): trả về vị trí dấu cách thứ 2 trong chuỗi
-- LEFT(string, length): lấy xâu từ bên trái và số lượng ký tự muốn lấy
-- RIGHT(string, length)
-- SUBSTRING(string, start,length): lấy ra 1 sâu con, bắt đầu từ ký tự số mấy?, số ký tự muốn lấy
-- SUBSTRING_INDEX(string, ' ', 1): lấy chuỗi con đầu tiên, -1 là lấy chuỗi con cuối cùng 
-- ví dụ 'hello hi world' thì 1 là 'hello', -1 là 'hi world' 

-- REPLACE(search, find, replace): thay thế (chuỗi, giá trị cần thay thế, giá trị thay thế)
-- INSERT(str, start, length, insert): chèn (chuỗi, chèn từ ?, 0, chuỗi cần chèn)
-- REVERSE(string): lấy đảo ngược 
-- LOWER(string), UPPER(string)
-- LPAD(string, length, pad), RPAD: chèn ký tự vào phía bên trái, phải 
-- SPACE(count): đếm số dấu cách trong xâu 
-- REPEAT(string, count): lặp lại

-- ROUND(12.49, 0): nó làm tròn thành 12, nếu 12.50 thì làm tròn thành 13
-- TRUNCATE(12.49, 1): nó cắt đuôi và không làm tròn, 12.4
-- CEILING(number): 12.5 thì thành 13, -12.5 thì thành -12, nó làm tròn số lớn hơn 
-- FLOOR(number): ngược lại với Ceiling 
-- ABS(number): trị tuyệt đối 
-- SIGN(number): <0 thì là -1, >0 thì là 1, =0 thi la 0
-- SQRT(number): căn 
-- POWER(number,power): mũ 
-- RAND([integer]): random between

-- NOW(): lấy ngày giờ hiện tại
-- CURDATE(): ngày tháng năm hiện tại
-- CURTIME(): giờ phút giây

-- DAYOFMONTH(date): ngày của tháng, ngày bnh?
-- MONTH(date), YEAR(date), HOUR(time)
-- MINUTE(time), SECOND(time)
-- DAYOFWEEK(date)
-- QUARTER(date) thuộc quý nào trong năm 
-- DAYOFYEAR(date)
-- WEEK(date[,first]): ngày ở tuần thứ bnh
-- LAST_DAY(date): ngày cuối cùng của ngày này trong tháng
-- DAYNAME(date): tên ngày
-- MONTHNAME(date): tên tháng

-- EXTRACT(unit FROM date) để tách ngày tháng năm, lấy ra
-- và unit ở đây là 
-- SECOND MINUTE HOUR DAY MONTH YEAR
-- MINUTE_SECOND:  phút và giây 18:50:00 = 5000
-- HOUR_MINUTE
-- DAY_HOUR
-- YEAR_MONTH
-- HOUR_SECOND: giờ, phút và giây
-- DAY_MINUTE ngày, giờ và phút 
-- DAY_SECOND ngày giờ phút giây 

-- DATE_FORMAT(date,format)
-- TIME_FORMAT(time,format)
-- DATE_FORMAT('2018-12-03 16:45', '%r') 04:45:00 PM
-- TIME_FORMAT('16:45', '%r') 04:45:00 PM
-- %q, %W: tên ngày trong tuần
-- %a: tên ngày viết tắt
-- %d: ngày trong tháng - 01
-- %e: ngày trong tháng - 1
-- %D: ngày trong tháng (1st, 2nd, 3rd, ...)
-- %j: ngày trong năm 001 -> 366
-- %b: tháng chữ viết tắt 3 chữ
-- %M: tháng chữ viết đủ
-- %c: tháng số
-- %m: tháng số có số 0
-- %U: tuần (chủ nhật là đầu tuần)
-- %Y: năm 4 số, y năm 2 số cuối
-- %h, %i, %s: giờ phút giây (lấy 12h)
-- %k: giờ nhưng chỉ 1 số, 5h = 5 chứ không phải 05 (lấy 24h)
-- %l: giống %k nhưng lấy 12h
-- %H: 24h còn h chỉ 12h
-- %r Time, 12-hour (hh:mm:ss AM or PM)
-- %T Time, 24-hour (hh:mm:ss)
-- %P: am hoặc pm

-- tính toán date
-- DATE_ADD(date,INTERVAL expression unit): cộng thêm
-- ví dụ: DATE_ADD('2018-12-31',INTERVAL 1 MONTH): cộng thêm 1 tháng
-- DATE_SUB(date,INTERVAL expression unit): trừ đi
-- DATEDIFF(date1, date2): khoảng cách giữa 2 date(ngày)
-- (TO_DAYS(date1) - TO_DAYS(date)): nó cx ra khoảng cách như vậy
-- TIME_TO_SEC(time): dùng trừ như trên nó cx ra nhưng sẽ ra time

SELECT *
FROM date_sample
WHERE MONTH(start_date) = 2 AND
DAYOFMONTH(start_date) = 28 AND
YEAR(start_date) = 2018

SELECT * FROM date_sample
WHERE EXTRACT(HOUR_MINUTE FROM start_date)
BETWEEN 900 AND 1200

-- hàm điều kiện case
SELECT invoice_number, terms_id,
CASE terms_id
  WHEN 1 THEN 'Net due 10 days'
  WHEN 2 THEN 'Net due 20 days'
  WHEN 3 THEN 'Net due 30 days'
  WHEN 4 THEN 'Net due 60 days'
  WHEN 5 THEN 'Net due 90 days'
  -- nó có lệnh ELSE nếu muốn [ELSE else_result_expression]
END AS terms
FROM invoices
-- hoặc
CASE
  WHEN DATEDIFF(NOW(), invoice_due_date) > 30 -- lấy khoảng cách ngày của hệ thống và trong máy
  THEN 'Over 30 days past due'
  WHEN DATEDIFF(NOW(), invoice_due_date) > 0
  THEN '1 to 30 days past due'
  ELSE 'Current'
END AS invoice_status

-- hàm if
IF(vendor_city = 'Fresno', 'Yes', 'No') AS is_city_fresno
IFNULL(payment_date, 'No Payment') AS new_date -- nếu null trả về chữ no, còn lại thì hiển thị

-- REGEXP 
REGEXP_LIKE(expr, pattern)
REGEXP_INSTR(expr, pattern [, start])
REGEXP_SUBSTR(expr, pattern [, start])
REGEXP_REPLACE(expr, pattern, replace[, start])

^ là đầu tiên 
$ là cuối cùng
. là bất kì ở đâu
| hoặc
char* là ko hoặc nhiều


REGEXP_LIKE('abc123', '123') 					1 -- tìm xem xâu có chứa sâu con ko, 1 - true
REGEXP_LIKE('abc123', '^123') 					0 -- có bắt đầu từ chuỗi con ko, 0 - false
REGEXP_INSTR('abc123', '123') 					4 -- trả về vị trí xuất hiện đầu tiên
REGEXP_SUBSTR('abc123', '[A-Z][1-9]*$') 		c123 
-- có định dạng, chứ ký tự, chứa số, chứ sâu bất kỳ ở cuối

REGEXP_REPLACE('abc123', '1|2', '3') 			abc333 -- thay thế nếu hoặc

-- xếp hạng
ROW_NUMBER()					OVER ([partition_clause] order_clause)

SELECT ROW_NUMBER() OVER(PARTITION BY vendor_state ORDER BY vendor_ name) AS row_number
-- PARTITION BY nó giúp di chuyển các hàng giống nhau về gần nhau, chứ ko gộp vào nhau
-- và row_number sẽ trả về stt hàng trong phân vùng PARTITION BY đó 

RANK()							OVER ([partition_clause] order_clause)
DENSE_RANK()					OVER ([partition_clause] order_clause)

SELECT RANK() OVER (ORDER BY invoice_ total) AS 'rank',
DENSE_ RANK() OVER (ORDER BY invoice_ total) AS 'dense_ rank'
-- cả 2 hàm trên đều trả về thứ tự hạng, nhưng rank nó sẽ trả về 1-1-1-4-4 còn dense trả về 1-1-1-2-2

NTILE(integer_ expression)		OVER ([partition_clause] order_clause)

SELECT NTILE(2) OVER (ORDER BY terms_ id) AS tile2,
NTILE(3) OVER (ORDER BY tenns_ id) AS tile3,
NTILE(4) OVER (ORDER BY terms id) AS tile4
-- trả về số nhóm của mỗi hàng, cái này hơi rối bỏ qua 

