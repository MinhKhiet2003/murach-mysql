-- 1

USE ap;

DROP PROCEDURE IF EXISTS insert_glaccount;

DELIMITER //

CREATE PROCEDURE insert_glaccount
(
  account_number_param        INT,   
  account_description_param   VARCHAR(50)
)
BEGIN
  INSERT INTO general_ledger_accounts
  VALUES (account_number_param, account_description_param);
END//

DELIMITER ;

-- Test fail: 
CALL insert_glaccount(700, 'Cash');

-- Test success: 
CALL insert_glaccount(700, 'Internet Services');

-- Clean up: 
DELETE FROM general_ledger_accounts WHERE account_number = 700;


-- 2
USE ap;

DROP FUNCTION IF EXISTS test_glaccounts_description;

DELIMITER //

CREATE FUNCTION test_glaccounts_description
(
   account_description_param VARCHAR(50)
)
RETURNS INT
DETERMINISTIC READS SQL DATA
BEGIN
  DECLARE account_description_var VARCHAR(50);

  SELECT account_description
  INTO account_description_var
  FROM general_ledger_accounts
  WHERE account_description = account_description_param;
  
  IF account_description_var IS NOT NULL THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
  
END//

DELIMITER ;

-- Test success: 
SELECT test_glaccounts_description('Book Inventory') AS message;

-- Test fail: 
SELECT test_glaccounts_description('Fail') AS message;

-- 3
USE ap;

DROP PROCEDURE IF EXISTS insert_glaccount_with_test;

DELIMITER //

CREATE PROCEDURE insert_glaccount_with_test
(
  account_number_param        INT,   
  account_description_param   VARCHAR(50)
)
BEGIN
  IF test_glaccounts_description(account_description_param) = TRUE THEN
    SIGNAL SQLSTATE '23000' 
      SET MYSQL_ERRNO = 1062,
          MESSAGE_TEXT = 'Duplicate account description.';    
  ELSE
    INSERT INTO general_ledger_accounts
    VALUES (account_number_param, account_description_param);
  END IF;
END//

DELIMITER ;

-- Test fail: 
CALL insert_glaccount(700, 'Cash');

-- Test success: 
CALL insert_glaccount(700, 'Internet Services');

-- Clean up: 
DELETE FROM general_ledger_accounts WHERE account_number = 700;


-- 4
USE ap;

DROP PROCEDURE IF EXISTS insert_terms;

DELIMITER //

CREATE PROCEDURE insert_terms
(
  terms_due_days_param      INT,
  terms_description_param    VARCHAR(50)
)
BEGIN  
  DECLARE sql_error TINYINT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    
  -- Set default values for NULL values
  IF terms_description_param IS NULL THEN
    SET terms_description_param = CONCAT('Net due ', terms_due_days_param, ' days');
  END IF;

  START TRANSACTION;
  
  INSERT INTO terms
  VALUES (DEFAULT, terms_description_param, terms_due_days_param);
  
  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//

DELIMITER ;

CALL insert_terms (120, 'Net due 120 days');
CALL insert_terms (150, NULL);

-- Clean up
DELETE FROM terms WHERE terms_id > 5;