USE ap;

-- 1
DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter from semicolon to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE invoice_count   INT;

  SELECT COUNT(*)
  INTO invoice_count
  FROM invoices
  WHERE invoice_total - payment_total - credit_total >= 5000;
  
  SELECT CONCAT(invoice_count, ' invoices exceed $5000.') AS message;
END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL test();

-- 2
DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter from semicolon to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE count_balance_due   INT;
  DECLARE total_balance_due   DECIMAL(9,2);

  SELECT COUNT(*), SUM(invoice_total - payment_total - credit_total)
  INTO count_balance_due, total_balance_due
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

  IF total_balance_due >= 30000 THEN
    SELECT count_balance_due AS count_balance_due, 
           total_balance_due AS total_balance_due;
  ELSE
    SELECT 'Total balance due is less than $30,000.' AS message;
  END IF;
END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL test();

-- 3
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE i         INT DEFAULT 10;
  DECLARE factorial INT DEFAULT 10;

  WHILE i > 1 DO
    SET factorial = factorial * (i - 1);
    SET i = i - 1;
  END WHILE;
  
  SELECT CONCAT('The factorial of 10 is: ', FORMAT(factorial,0), '.') AS message;

END//

DELIMITER ;

CALL test();

-- 4
DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter from semicolon to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE vendor_name_var     VARCHAR(50);
  DECLARE invoice_number_var  VARCHAR(50);
  DECLARE balance_due_var     DECIMAL(9,2);

  DECLARE s                   VARCHAR(400)   DEFAULT '';
  DECLARE row_not_found       INT            DEFAULT FALSE;
  
  DECLARE invoices_cursor CURSOR FOR
    SELECT vendor_name, invoice_number,
      invoice_total - payment_total - credit_total AS balance_due
    FROM vendors v JOIN invoices i
      ON v.vendor_id = i.vendor_id
    WHERE invoice_total - payment_total - credit_total >= 5000
    ORDER BY balance_due DESC;

  BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
    END WHILE;
  END;

  CLOSE invoices_cursor;    
  
  SELECT s AS message;
END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL test();

-- 5
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE column_cannot_be_null TINYINT DEFAULT FALSE;

  DECLARE CONTINUE HANDLER FOR 1048
    SET column_cannot_be_null = TRUE;

  UPDATE invoices
  SET invoice_due_date = NULL
  WHERE invoice_id = 1;
  
  IF column_cannot_be_null = TRUE THEN
    SELECT 'Row was not updated - column cannot be null.' AS message;
  ELSE
    SELECT '1 row was updated.' AS message;    
  END IF;

END//

DELIMITER ;

CALL test();

-- 6 
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT;
  DECLARE divisor_found TINYINT DEFAULT TRUE;
  DECLARE s VARCHAR(400) DEFAULT '';

  WHILE i < 100 DO
    SET j = i - 1;
    WHILE j > 1 DO
      IF i % j = 0 THEN
        SET j = 1;
        SET divisor_found = TRUE;
      ELSE
        SET j = j - 1;            
      END IF;
    END WHILE;
    IF divisor_found != TRUE THEN
      SET s = CONCAT(s, i, ' | ');
    END IF;
    SET i = i + 1;
    SET divisor_found = FALSE;
  END WHILE;

SELECT s AS 'Prime numbers < 100';

END//


DELIMITER ;

CALL test();

-- 7
DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter from semicolon to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE vendor_name_var     VARCHAR(50);
  DECLARE invoice_number_var  VARCHAR(50);
  DECLARE balance_due_var     DECIMAL(9,2);

  DECLARE s                   VARCHAR(400)   DEFAULT '';
  DECLARE row_not_found       INT            DEFAULT FALSE;
  
  DECLARE invoices_cursor CURSOR FOR
    SELECT vendor_name, invoice_number,
      invoice_total - payment_total - credit_total AS balance_due
    FROM vendors v JOIN invoices i
      ON v.vendor_id = i.vendor_id
    WHERE invoice_total - payment_total - credit_total >= 5000
    ORDER BY balance_due DESC;

  -- Loop 1
  BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$20,000 or More: ');      
                             
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      IF balance_due_var >= 20000 THEN
        SET s = CONCAT(s, balance_due_var, '|',
                          invoice_number_var, '|',
                          vendor_name_var, '//');
      END IF;
    END WHILE;    
  END;

  CLOSE invoices_cursor;    

  -- Loop 2
  SET row_not_found = FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$10,000 to $20,000: ');
        
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      IF balance_due_var >= 10000 AND balance_due_var < 20000 THEN
        SET s = CONCAT(s, balance_due_var, '|',
                          invoice_number_var, '|',
                          vendor_name_var, '//');
      END IF;
    END WHILE;    
  END;

  CLOSE invoices_cursor;    

  -- Loop 3
  SET row_not_found = FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    SET s = CONCAT(s, '$5,000 to $10,000: ');
        
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      IF balance_due_var >= 5000 AND balance_due_var < 10000 THEN
        SET s = CONCAT(s, balance_due_var, '|',
                          invoice_number_var, '|',
                          vendor_name_var, '//');
      END IF;
    END WHILE;    
  END;

  CLOSE invoices_cursor;    
  
  -- Display the string variable
  SELECT s AS message;
END//
    
-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL test();