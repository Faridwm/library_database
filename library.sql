-- SQL version 5.0.1
-- Server version: 10.4.11-MariaDB

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";
SET @@GLOBAL.event_scheduler = ON;

--
-- Database: `library`
--
CREATE DATABASE IF NOT EXISTS `library` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `library`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_author`$$
CREATE PROCEDURE `add_author` (`first_name` VARCHAR(20), `last_name` VARCHAR(30), `gender` ENUM('M','F'), `birthday_date` DATE, `phone` VARCHAR(20), `address` VARCHAR(255))  BEGIN
	INSERT INTO authors VALUES (author_id(), first_name, last_name, gender, birthday_date, phone, address);
END$$

DROP PROCEDURE IF EXISTS `add_book`$$
CREATE PROCEDURE `add_book` (`isbn` CHAR(13), `name` VARCHAR(100), `category` CHAR(3), `stock` SMALLINT, `publisher` INT, `release_date` DATE, `release_city` VARCHAR(100), `ls_authors` VARCHAR(255))  BEGIN
	DECLARE b_id int UNSIGNED;

	DECLARE c_ls_authors varchar(255);
	DECLARE char_list INT;
    DECLARE char_sub INT;
    DECLARE sub TEXT;

	SET b_id = book_id();
	INSERT INTO books VALUES(b_id, isbn, name, category, stock, stock, publisher, release_date, release_city);
	
	SET c_ls_authors := ls_authors;
	
	do_this:
	LOOP
	IF c_ls_authors = "" THEN
		LEAVE do_this;
	END IF;
	
	SET char_list := char_length(c_ls_authors);
    SET sub := substring_index(c_ls_authors, ', ', 1);
    INSERT INTO books_authors (id_book, id_author) VALUES (b_id, sub);
   
--    cut list
	 SET char_sub := char_length(substring_index(c_ls_authors, ',', 1)) + 3;
     SET c_ls_authors := MID(c_ls_authors, char_sub, char_list);
    
    END LOOP do_this;
	
	
END$$

DROP PROCEDURE IF EXISTS `add_emp`$$
CREATE PROCEDURE `add_emp` (`first_name` VARCHAR(20), `last_name` VARCHAR(30), `gender` ENUM('M','F'), `birthday_date` DATE, `position` INT, `phone` VARCHAR(20), `address` VARCHAR(255), `hire_date` DATE)  BEGIN
	INSERT INTO employees VALUES (emp_id(birthday_date), first_name, last_name, gender, birthday_date, `position`, phone, address, hire_date, now());
END$$

DROP PROCEDURE IF EXISTS `add_member`$$
CREATE PROCEDURE `add_member` (`first_name` VARCHAR(20), `last_name` VARCHAR(30), `email` VARCHAR(50), `gender` ENUM('M','F'), `phone` VARCHAR(20), `birthday_date` DATE, `address` VARCHAR(255), `job` INT)  BEGIN
	INSERT INTO members VALUES (mbr_id(), email, first_name, last_name, gender, phone, birthday_date, address, job, now(), adddate(now(), INTERVAL 5 YEAR));
END$$

DROP PROCEDURE IF EXISTS `extend_member_expired`$$
CREATE PROCEDURE `extend_member_expired` (`mbr_id` INT UNSIGNED)  BEGIN
	DECLARE exp_date date;
	DECLARE now_date date;
	
	SET exp_date := (SELECT m.expired_member FROM members m WHERE m.id = mbr_id);
	SET now_date := now();
	
	
	IF (now_date < exp_date) THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = "Member belom expired";
	END IF;
	
	UPDATE members SET members.expired_member = adddate(exp_date, INTERVAL 5 YEAR) WHERE id = mbr_id;
END$$

DROP PROCEDURE IF EXISTS `loan_book`$$
CREATE PROCEDURE `loan_book` (`member_id` INT UNSIGNED, `emp_id` INT UNSIGNED, `ls_book_id` VARCHAR(255), `loan_note` VARCHAR(255))  BEGIN
	DECLARE avai_book int;
	
	DECLARE loan_id int UNSIGNED;

	DECLARE c_ls_book TEXT;
    DECLARE char_list INT;
    DECLARE char_sub INT;
    DECLARE sub TEXT;
	   	
	SET loan_id := loan_book_id();
-- 	insert to loan table
	INSERT INTO loans (id, id_member, emp_id_borrow, date_borrow, expired_date_return, loan_note) VALUES (loan_id, member_id, emp_id, now(), adddate(now(), INTERVAL 7 DAY), loan_note);


	SET c_ls_book := ls_book_id;
-- 	looping for insert books_loan
	do_this:
	LOOP
	IF c_ls_book = "" THEN
		LEAVE do_this;
	END IF;
	
	SET char_list := char_length(c_ls_book);
    SET sub := substring_index(c_ls_book, ', ', 1);
    INSERT INTO books_loan (id_book, id_loan) VALUES (sub, loan_id);
   
--    cut list
	 SET char_sub := char_length(substring_index(c_ls_book, ',', 1)) + 3;
     SET c_ls_book := MID(c_ls_book, char_sub, char_list);
    
    END LOOP do_this;
END$$

DROP PROCEDURE IF EXISTS `return_book`$$
CREATE PROCEDURE `return_book` (`loan_id` INT UNSIGNED, `emp_id` INT UNSIGNED, `return_date` DATE)  BEGIN
	DECLARE exp_date date;
	DECLARE sts int;
	
	SET sts := (SELECT l.status FROM loans l WHERE id = loan_id);

	IF sts = 0 OR sts = 2 THEN
		SIGNAL SQLSTATE '45000'
		SET message_text = "Buku Telah dikembalikan";
	END IF;

	SET exp_date := (SELECT l.expired_date_return FROM loans l WHERE id = loan_id);

	IF date(return_date) > exp_date THEN
		SET sts = 2;
	ELSE 
		SET sts = 0;
	END IF;
	
	UPDATE loans SET emp_id_return = emp_id, date_return = return_date, status = sts WHERE id = loan_id;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `author_id`$$
CREATE FUNCTION `author_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(a.id) FROM authors a), 6) + 1, 1);
 	SET new_id := CONCAT(2, LPAD(new_id, 6, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `book_id`$$
CREATE FUNCTION `book_id` () RETURNS CHAR(10) CHARSET utf8mb4 BEGIN
	DECLARE new_id char(10);
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(b.id) FROM books b), 9) + 1, 1);
 	SET new_id := CONCAT(6, LPAD(new_id, 9, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `emp_id`$$
CREATE FUNCTION `emp_id` (`birth_date` DATE) RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	DECLARE dt int UNSIGNED;
	
	SET dt := date_format(birth_date, "%y%m%d");
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(e.id) FROM employees e), 3) + 1, 1);
 	SET new_id := CONCAT(3, dt, LPAD(new_id, 3, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `emp_position_id`$$
CREATE FUNCTION `emp_position_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(ep.id) FROM employees_positions ep), 2) + 1, 1);
 	SET new_id := CONCAT(2, LPAD(new_id, 2, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `loan_book_id`$$
CREATE FUNCTION `loan_book_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	DECLARE dt int UNSIGNED;
	
	SET dt := date_format(now(), "%y%m");
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(l.id) FROM loans l WHERE MID(l.id, 2, 4) = dt), 4) + 1, 1);
 	SET new_id := CONCAT(9, dt, LPAD(new_id, 4, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `mbr_id`$$
CREATE FUNCTION `mbr_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	DECLARE dt int UNSIGNED;
	
	SET dt := date_format(now(), "%y%m%d");
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(m.id) FROM members m WHERE LEFT(m.id, 6) = dt), 4) + 1, 1);
 	SET new_id := CONCAT(dt, LPAD(new_id, 4, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `mbr_jobs_id`$$
CREATE FUNCTION `mbr_jobs_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(mj.id) FROM member_jobs mj), 2) + 1, 1);
 	SET new_id := CONCAT(1, LPAD(new_id, 2, 0));
	RETURN new_id;
END$$

DROP FUNCTION IF EXISTS `publisher_id`$$
CREATE FUNCTION `publisher_id` () RETURNS INT(10) UNSIGNED BEGIN
	DECLARE new_id INT UNSIGNED;
	
	SET new_id := COALESCE(RIGHT((SELECT MAX(p.id) FROM publishers p), 4) + 1, 1);
 	SET new_id := CONCAT(3, LPAD(new_id, 4, 0));
	RETURN new_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
CREATE TABLE IF NOT EXISTS `authors` (
  `id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `birthday_date` date NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `authors_un_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `id` char(10) NOT NULL,
  `isbn` char(13) NOT NULL,
  `name` varchar(100) NOT NULL,
  `category` char(3) NOT NULL,
  `stock` smallint(5) UNSIGNED NOT NULL,
  `avaibility` smallint(5) UNSIGNED NOT NULL,
  `publisher` int(10) UNSIGNED NOT NULL,
  `release_date` date NOT NULL,
  `release_city` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `books_un_isbn` (`isbn`),
  KEY `books_fk_category` (`category`),
  KEY `books_fk_piblisher` (`publisher`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `books_authors`
--

DROP TABLE IF EXISTS `books_authors`;
CREATE TABLE IF NOT EXISTS `books_authors` (
  `id_book` char(10) NOT NULL,
  `id_author` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_book`,`id_author`),
  KEY `books_authors_fk_author` (`id_author`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `books_loan`
--

DROP TABLE IF EXISTS `books_loan`;
CREATE TABLE IF NOT EXISTS `books_loan` (
  `id_book` char(10) NOT NULL,
  `id_loan` int(10) UNSIGNED NOT NULL,
  `status` enum('0','1') NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_book`,`id_loan`),
  KEY `books_loan_fk_loan` (`id_loan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `books_loan`
--
DROP TRIGGER IF EXISTS `avaibility_after_loan`;
DELIMITER $$
CREATE TRIGGER `avaibility_after_loan` AFTER INSERT ON `books_loan` FOR EACH ROW BEGIN 
DECLARE avaibility_book int;

SET avaibility_book := (SELECT b.avaibility FROM books b WHERE b.id = NEW.id_book);

UPDATE books SET books.avaibility = avaibility_book - 1 WHERE id = NEW.id_book;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `avaibility_after_return`;
DELIMITER $$
CREATE TRIGGER `avaibility_after_return` BEFORE UPDATE ON `books_loan` FOR EACH ROW BEGIN 
DECLARE avaibility_book int;

IF NEW.status = '0' THEN
	SET avaibility_book := (SELECT b.avaibility FROM books b WHERE b.id = NEW.id_book);

	UPDATE books SET books.avaibility = avaibility_book + 1 WHERE id = NEW.id_book;
ELSE 
	SET avaibility_book := (SELECT b.avaibility FROM books b WHERE b.id = NEW.id_book);

	UPDATE books SET books.avaibility = avaibility_book WHERE id = NEW.id_book;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories_books`
--

DROP TABLE IF EXISTS `categories_books`;
CREATE TABLE IF NOT EXISTS `categories_books` (
  `id` char(3) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `category_desc` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `birthday_date` date NOT NULL,
  `position` int(10) UNSIGNED NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `hire_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_un_phone` (`phone`),
  KEY `employees_fk_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `employees_positions`
--

DROP TABLE IF EXISTS `employees_positions`;
CREATE TABLE IF NOT EXISTS `employees_positions` (
  `id` int(10) UNSIGNED NOT NULL,
  `position_name` varchar(100) NOT NULL,
  `position_desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_positions_un_name` (`position_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
CREATE TABLE IF NOT EXISTS `loans` (
  `id` int(10) UNSIGNED NOT NULL,
  `id_member` int(10) UNSIGNED NOT NULL,
  `emp_id_borrow` int(10) UNSIGNED NOT NULL,
  `date_borrow` date NOT NULL DEFAULT current_timestamp(),
  `emp_id_return` int(10) UNSIGNED DEFAULT NULL,
  `date_return` date DEFAULT NULL,
  `expired_date_return` date NOT NULL DEFAULT (current_timestamp() + interval 7 day),
  `loan_note` varchar(255) DEFAULT NULL,
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0 = buku dikembalikan, 1 = buku dipinjam, 2 = buku dikembalikan tetapi lewat jadwal pengembalian, 3 = buku belum dikembalikan dan lewat jadwal pengembalian',
  PRIMARY KEY (`id`),
  KEY `loans_fk_member` (`id_member`),
  KEY `loans_fk_employee_borrow` (`emp_id_borrow`),
  KEY `loans_fk_employee_return` (`emp_id_return`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `loans`
--
DROP TRIGGER IF EXISTS `return_book`;
DELIMITER $$
CREATE TRIGGER `return_book` BEFORE UPDATE ON `loans` FOR EACH ROW BEGIN 
	IF NEW.status = 0 OR NEW.status = 2 THEN 
		UPDATE books_loan SET status = '0' WHERE id_loan = OLD.id;	
	END IF;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE IF NOT EXISTS `members` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(50) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `birthday_date` date NOT NULL,
  `address` varchar(255) NOT NULL,
  `job` int(10) UNSIGNED NOT NULL,
  `create_member` date DEFAULT current_timestamp(),
  `expired_member` date DEFAULT (current_timestamp() + interval 5 year),
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_un_email` (`email`),
  UNIQUE KEY `members_un_phone` (`phone`),
  KEY `members_fk_job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `member_jobs`
--

DROP TABLE IF EXISTS `member_jobs`;
CREATE TABLE IF NOT EXISTS `member_jobs` (
  `id` int(10) UNSIGNED NOT NULL,
  `job_name` varchar(100) NOT NULL,
  `job_desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_jobs_un_name` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

DROP TABLE IF EXISTS `publishers`;
CREATE TABLE IF NOT EXISTS `publishers` (
  `id` int(10) UNSIGNED NOT NULL,
  `pub_name` varchar(200) NOT NULL,
  `pub_phone` varchar(20) NOT NULL,
  `pub_city` varchar(100) NOT NULL,
  `pub_address` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `publishers_un_phone` (`pub_phone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_books`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_books`;
CREATE TABLE IF NOT EXISTS `view_books` (
`id` char(10)
,`isbn` char(13)
,`name` varchar(100)
,`category_id` char(3)
,`category_name` varchar(100)
,`publisher_id` int(10) unsigned
,`pub_name` varchar(200)
,`stock` smallint(5) unsigned
,`avaibility` smallint(5) unsigned
,`release_date` date
,`release_city` varchar(100)
,`authors` mediumtext
,`status` varchar(13)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_employees`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_employees`;
CREATE TABLE IF NOT EXISTS `view_employees` (
`id` int(10) unsigned
,`name` varchar(52)
,`gender` enum('M','F')
,`birthday_date` date
,`phone` varchar(20)
,`address` varchar(255)
,`hire_date` date
,`id_position` int(10) unsigned
,`position_name` varchar(100)
,`position_desc` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_loans`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_loans`;
CREATE TABLE IF NOT EXISTS `view_loans` (
`id` int(10) unsigned
,`id_member` int(10) unsigned
,`member_name` varchar(52)
,`date_borrow` date
,`date_return` date
,`expired_date_return` date
,`loan_note` varchar(255)
,`book_id` mediumtext
,`status` varchar(40)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_members`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `view_members`;
CREATE TABLE IF NOT EXISTS `view_members` (
`id` int(10) unsigned
,`email` varchar(50)
,`name` varchar(52)
,`gender` enum('M','F')
,`birthday_date` date
,`create_member` date
,`expired_member` date
,`phone` varchar(20)
,`job_id` int(10) unsigned
,`job_name` varchar(100)
,`job_desc` varchar(255)
,`status` varchar(7)
);

-- --------------------------------------------------------

--
-- Structure for view `view_books`
--
DROP TABLE IF EXISTS `view_books`;

DROP VIEW IF EXISTS `view_books`;
CREATE OR REPLACE VIEW `view_books`  AS  select `b`.`id` AS `id`,`b`.`isbn` AS `isbn`,`b`.`name` AS `name`,`cb`.`id` AS `category_id`,`cb`.`category_name` AS `category_name`,`p`.`id` AS `publisher_id`,`p`.`pub_name` AS `pub_name`,`b`.`stock` AS `stock`,`b`.`avaibility` AS `avaibility`,`b`.`release_date` AS `release_date`,`b`.`release_city` AS `release_city`,group_concat(`ba`.`id_author` separator ', ') AS `authors`,if(`b`.`avaibility` > 0,'Available','Not Available') AS `status` from (((`books` `b` join `categories_books` `cb` on(`b`.`category` = `cb`.`id`)) join `publishers` `p` on(`b`.`publisher` = `p`.`id`)) join `books_authors` `ba` on(`b`.`id` = `ba`.`id_book`)) group by `b`.`id` ;

-- --------------------------------------------------------

--
-- Structure for view `view_employees`
--
DROP TABLE IF EXISTS `view_employees`;

DROP VIEW IF EXISTS `view_employees`;
CREATE OR REPLACE VIEW `view_employees`  AS  select `e`.`id` AS `id`,concat(`e`.`last_name`,', ',`e`.`first_name`) AS `name`,`e`.`gender` AS `gender`,`e`.`birthday_date` AS `birthday_date`,`e`.`phone` AS `phone`,`e`.`address` AS `address`,`e`.`hire_date` AS `hire_date`,`ep`.`id` AS `id_position`,`ep`.`position_name` AS `position_name`,`ep`.`position_desc` AS `position_desc` from (`employees` `e` join `employees_positions` `ep` on(`e`.`position` = `ep`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_loans`
--
DROP TABLE IF EXISTS `view_loans`;

DROP VIEW IF EXISTS `view_loans`;
CREATE OR REPLACE VIEW `view_loans`  AS  select `l`.`id` AS `id`,`m`.`id` AS `id_member`,concat(`m`.`last_name`,', ',`m`.`first_name`) AS `member_name`,`l`.`date_borrow` AS `date_borrow`,`l`.`date_return` AS `date_return`,`l`.`expired_date_return` AS `expired_date_return`,`l`.`loan_note` AS `loan_note`,group_concat(`b`.`id` separator ', ') AS `book_id`,case `l`.`status` when 0 then 'Books returned' when 1 then 'Books borrowed' when 2 then 'Books returned but past the return daten' when 3 then 'Books borrowe and past the return date' else 'ERROR' end AS `status` from (((`loans` `l` join `books_loan` `bl` on(`bl`.`id_loan` = `l`.`id`)) join `books` `b` on(`bl`.`id_book` = `b`.`id`)) join `members` `m` on(`m`.`id` = `l`.`id_member`)) group by `l`.`id` ;

-- --------------------------------------------------------

--
-- Structure for view `view_members`
--
DROP TABLE IF EXISTS `view_members`;

DROP VIEW IF EXISTS `view_members`;
CREATE OR REPLACE VIEW `view_members`  AS  select `m`.`id` AS `id`,`m`.`email` AS `email`,concat(`m`.`last_name`,', ',`m`.`first_name`) AS `name`,`m`.`gender` AS `gender`,`m`.`birthday_date` AS `birthday_date`,`m`.`create_member` AS `create_member`,`m`.`expired_member` AS `expired_member`,`m`.`phone` AS `phone`,`mj`.`id` AS `job_id`,`mj`.`job_name` AS `job_name`,`mj`.`job_desc` AS `job_desc`,if(`m`.`status` = 1,'Aktif','Expired') AS `status` from (`members` `m` join `member_jobs` `mj` on(`m`.`job` = `mj`.`id`)) ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_fk_category` FOREIGN KEY (`category`) REFERENCES `categories_books` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `books_fk_piblisher` FOREIGN KEY (`publisher`) REFERENCES `publishers` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `books_authors`
--
ALTER TABLE `books_authors`
  ADD CONSTRAINT `books_authors_fk_author` FOREIGN KEY (`id_author`) REFERENCES `authors` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `books_authors_fk_book` FOREIGN KEY (`id_book`) REFERENCES `books` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `books_loan`
--
ALTER TABLE `books_loan`
  ADD CONSTRAINT `books_loan_fk_book` FOREIGN KEY (`id_book`) REFERENCES `books` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `books_loan_fk_loan` FOREIGN KEY (`id_loan`) REFERENCES `loans` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_fk_position` FOREIGN KEY (`position`) REFERENCES `employees_positions` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_fk_employee_borrow` FOREIGN KEY (`emp_id_borrow`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `loans_fk_employee_return` FOREIGN KEY (`emp_id_return`) REFERENCES `employees` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `loans_fk_member` FOREIGN KEY (`id_member`) REFERENCES `members` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_fk_job` FOREIGN KEY (`job`) REFERENCES `member_jobs` (`id`) ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
DROP EVENT `check_sts_member`$$
CREATE EVENT `check_sts_member` ON SCHEDULE EVERY 1 DAY STARTS '2020-07-10 13:14:54' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE members SET status = 0 WHERE timestampdiff(day, date(now()), expired_member) < 0$$

DROP EVENT `check_loan_book_expired`$$
CREATE EVENT `check_loan_book_expired` ON SCHEDULE EVERY 1 DAY STARTS '2020-07-10 13:15:01' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE loans SET status = 3 WHERE timestampdiff(day, date(now()), expired_date_return) < 0 AND status = 1$$

DELIMITER ;
COMMIT;
