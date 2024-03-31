-- 1
USE ap;

DROP TRIGGER IF EXISTS invoices_before_update;

DELIMITER //

CREATE TRIGGER invoices_before_update
  BEFORE UPDATE ON invoices
  FOR EACH ROW
BEGIN
  DECLARE sum_line_item_amount DECIMAL(9,2);
  
  SELECT SUM(line_item_amount) 
  INTO sum_line_item_amount
  FROM invoice_line_items
  WHERE invoice_id = NEW.invoice_id;
  
  IF sum_line_item_amount != NEW.invoice_total THEN
    SIGNAL SQLSTATE 'HY000'
      SET MESSAGE_TEXT = 'Line item total must match invoice total.';
  ELSEIF NEW.payment_total + NEW.credit_total > NEW.invoice_total THEN
    SIGNAL SQLSTATE 'HY000'
      SET MESSAGE_TEXT = 'Payment total + credit total can not be greater than invoice total.';
  END IF;
END//

DELIMITER ;

UPDATE invoices
SET payment_total = 0, credit_total = 0
WHERE invoice_id = 112;

SELECT invoice_id, invoice_total, credit_total, payment_total
FROM invoices
WHERE invoice_id = 112;

-- lỗi bởi vì payment_total + credit_total sẽ lớn hơn invoice_total
UPDATE invoices
SET payment_total = 10000, credit_total = 1000
WHERE invoice_id = 112;

-- 2
USE ap;

DROP TRIGGER IF EXISTS invoices_after_update;

DELIMITER //

CREATE TRIGGER invoices_after_update
  AFTER UPDATE ON invoices
  FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES
    (OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 
    'UPDATED', NOW());
END//

DELIMITER ;

UPDATE invoices
SET payment_total = 100
WHERE invoice_id = 112;

SELECT * FROM invoices_audit;

-- clean up
UPDATE invoices
SET payment_total = 0
WHERE invoice_id = 112;

-- clean up
-- DELETE FROM invoices_audit WHERE vendor_id = 110 LIMIT 100;

-- 3
USE ap;

-- thực thi nếu bộ lập lịch sự kiện không bật
-- SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS minute_test;

DELIMITER //

CREATE EVENT minute_test
ON SCHEDULE EVERY 1 MINUTE
DO BEGIN
    INSERT INTO invoices_audit VALUES
    (9999, 'test', 999.99, 'INSERTED', NOW());
END//

DELIMITER ;

SHOW EVENTS LIKE 'min%';

SELECT * FROM invoices_audit;

DROP EVENT minute_test;
