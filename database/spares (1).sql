-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2023 at 09:30 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spares`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `bill_amount` (IN `_employee_id` INT)   BEGIN

SELECT SUM(Amount) as salary from charge WHERE employee_id=_employee_id and active=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bill_monthly` (IN `_month_id` INT)   BEGIN

SELECT Amount from charge c JOIN employe e on c.employe_id=e.employe_id WHERE c.month=_month_id and c.employe_id=e.employe_id;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `charge_month` (IN `_month` INT, IN `_year` VARCHAR(100), IN `_description` TEXT, IN `_Account_id` INT, IN `_user_id` VARCHAR(100))   BEGIN
if(read_salary() > read_acount_balance(_Account_id))THEN
SELECT "Deny" as msg;
else
INSERT IGNORE INTO `charge`(`employee_id`, `title_id`, `Amount`, `Account_id`, `month`, `year`, `description`, `user_id`,`date`)
 SELECT e.employee_id,j.title_id,j.salary,_Account_id,_month,_year,_description,_user_id,
CURRENT_DATE from employe e JOIN job_title  j on e.title_id=j.title_id;
IF(row_count()>0)THEN
SELECT "Registered" as msg;
ELSE
SELECT "NOt" as msg;
END IF;    
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `charge_repo` (IN `_month_name` VARCHAR(100))   BEGIN


SELECT ch.charge_id,concat(e.frist_name,' ',e.last_name) as employee_name,ch.Amount,m.month_name,ch.year,a.bank_name,ch.description,ch.user_id,ch.active,ch.date FROM charge ch JOIN employe e ON ch.employee_id=e.employee_id JOIN account a ON ch.Account_id=a.Account_id JOIN month m ON ch.month=m.month_id WHERE active=0 AND m.month_name=_month_name;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_procedure` (IN `_username` VARCHAR(100), IN `_password` VARCHAR(100))   BEGIN


if EXISTS(SELECT * FROM users WHERE users.username = _username and users.password = MD5(_password))THEN	


if EXISTS(SELECT * FROM users WHERE users.username = _username and 	users.status = 'Active')THEN
 
SELECT * FROM users where users.username = _username;

ELSE

SELECT 'Locked' msg;

end if;
ELSE


SELECT 'Deny' msg;

END if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_repo` (IN `_customer_name` VARCHAR(100))   BEGIN

if(_customer_name = ' ')THEN

SELECT concat(cu.frist_name,' ',cu.last_name) AS customer_name,i.item_name,o.price,o.quantity,o.balance FROM orders o JOIN customers cu ON o.customer_id=cu.customer_id JOIN item i ON o.item_id=i.item_id;

ELSE

SELECT concat(cu.frist_name,' ',cu.last_name) AS customer_name,i.item_name,o.price,o.quantity,o.balance FROM orders o JOIN customers cu ON o.customer_id=cu.customer_id JOIN item i ON o.item_id=i.item_id WHERE cu.frist_name=_customer_name;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payment_statement` (IN `_tellphone` INT)   BEGIN

if(_tellphone = '0000-00-00')THEN
SELECT concat(c.frist_name, ' ', c.last_name) as customer_name, ca.car_name,p.amount as price, p.amount_paid,p.balance,ac.bank_name,pm.name as method,p.date from payment p JOIN customers c on p.customer_id=c.customer_id JOIN account ac on p.Account_id=ac.Account_id
JOIN payment_method pm on p.p_method_id=pm.p_method_id JOIN sell s on p.customer_id=s.customer_id JOIN car ca on s.car_id=ca.car_id;
ELSE
SELECT concat(c.frist_name, ' ', c.last_name) as customer_name, ca.car_name,p.amount as price, p.amount_paid,p.balance,ac.bank_name,pm.name as method,p.date from payment p JOIN customers c on p.customer_id=c.customer_id JOIN account ac on p.Account_id=ac.Account_id
JOIN payment_method pm on p.p_method_id=pm.p_method_id JOIN sell s on p.customer_id=s.customer_id JOIN car ca on s.car_id=ca.car_id WHERE c.phone=_tellphone;
END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_all_employe` ()   BEGIN

SELECT e.employee_id as ID,concat(e.frist_name, ' ', e.last_name) as Employe, e.phone,e.city,e.state,b.address as branch,j.position,j.salary from employe e JOIN branch b on e.branch_id=b.branch_id JOIN job_title j on e.title_id=j.title_id ORDER BY e.employee_id;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_all_items` ()   BEGIN

SELECT c.item_id,c.item_name,cm.modal as item_modal,c.size,s.company_name,c.unit_price,c.price from item c JOIN Category cm on c.Category_id=cm.Category_id JOIN suplier s on c.suplier_id=s.suplier_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_all_item_price` (IN `_item_id` INT)   BEGIN

SELECT c.item_id,c.price FROM item c WHERE c.item_id=_item_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_all_users` ()   BEGIN

SELECT u.user_id,concat(e.frist_name, ' ', e.last_name) as employe_name, u.username,u.image,u.date from users u JOIN employe e on u.employee_id=e.employee_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_amount` (IN `_customer_id` INT)   BEGIN

SELECT o.balance FROM orders o WHERE o.customer_id=_customer_id;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_customer_statement` (IN `_from` DATE, IN `_to` DATE)   BEGIN
if(_from = '0000-00-00')THEN
SELECT * FROM customers;
ELSE
SELECT * FROM customers WHERE  customers.date BETWEEN _from and _to ORDER by customers.date ASC;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_employe_name` ()   BEGIN

SELECT e.employee_id, concat(e.frist_name, ' ', e.last_name) as full_name from employe e;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_employe_statement` (IN `_tellphone` INT)   BEGIN
if(_tellphone = '0000-00-00')THEN
SELECT e.employe_id,e.frist_name,e.last_name,e.phone,e.city,e.state,b.address as branch,jt.position,jt.salary from employe e JOIN branch b on e.branch_id=b.branch_id JOIN job_title jt on e.title_id=jt.title_id;
ELSE
SELECT e.employe_id,e.frist_name,e.last_name,e.phone,e.city,e.state,b.address as branch,jt.position,jt.salary from employe e JOIN branch b on e.branch_id=b.branch_id JOIN job_title jt on e.title_id=jt.title_id WHERE phone=_tellphone;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_sell_statement` (IN `_tellphone` INT)   BEGIN

if(_tellphone = '0000-00-00')THEN
SELECT concat(c.frist_name, ' ', c.last_name) as customer_name, ca.car_name,ca.price,s.quantity,s.price as Total_price,s.date from sell s JOIN customers c on s.customer_id=c.customer_id JOIN car ca on s.car_id=ca.car_id;
ELSE
SELECT concat(c.frist_name, ' ', c.last_name) as customer_name, ca.car_name,ca.price,s.quantity,s.price as Total_price,s.date from sell s JOIN customers c on s.customer_id=c.customer_id JOIN car ca on s.car_id=ca.car_id 
WHERE c.phone=_tellphone;
END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `register_expense_sp` (IN `_id` INT, IN `_amount` FLOAT(11,2), IN `_type` VARCHAR(50), IN `_desc` TEXT, IN `_userId` VARCHAR(50), IN `_Account_id` INT)   BEGIN
 if(_type = 'Expense')THEN

if((SELECT read_acount_balance(_Account_id) < _amount))THEN

SELECT 'Deny' as Message;

ELSE

INSERT into expense(expense.amount,expense.type,expense.description,expense.user_id,expense.Account_id)
VALUES(_amount,_type,_desc,_userId,_Account_id);

SELECT 'Registered' as Message;

END if;
ELSE
if(_type = 'Expense')THEN

if((SELECT read_acount_balance(_Account_id) < _amount))THEN

SELECT 'Deny' as Message;
END IF;
ELSE
if EXISTS( SELECT * FROM expense WHERE expense.id = _id)THEN
UPDATE expense SET expense.amount = _amount, expense.type = _type, expense.description = _desc,expense.user_id=_userId,expense.Account_id=_Account_id
WHERE expense.id = _id;

SELECT 'Updated' as Message;
ELSE

INSERT into expense(expense.amount,expense.type,expense.description,expense.user_id,expense.Account_id)
VALUES(_amount,_type,_desc,_userId,_Account_id);

SELECT 'Registered' as Message;

END if;
END IF;

END if;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `read_acount_balance` (`_Account_id` INT) RETURNS INT(11)  BEGIN
SET @balance=0.00;
SELECT SUM(balance)INTO @balance FROM account WHERE Account_id
=_Account_id;
RETURN @balance;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `read_salary` () RETURNS DECIMAL(11,2)  BEGIN
SET @salary=0.00;
SELECT SUM(salary)INTO @salary FROM job_title;
RETURN @salary;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `Account_id` int(11) NOT NULL,
  `bank_name` varchar(50) NOT NULL,
  `holder_name` varchar(50) NOT NULL,
  `accoun_number` int(11) NOT NULL,
  `balance` decimal(12,0) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Account_id`, `bank_name`, `holder_name`, `accoun_number`, `balance`, `date`) VALUES
(2, 'IBS_bank', 'samafale', 618846254, 30540, '2023-06-17 12:10:17'),
(3, 'Hormuud', 'anwar', 616095981, 8219, '2023-06-18 07:27:54'),
(5, 'Edahab', 'farxaan', 2147483647, 80, '2023-06-04 18:52:10'),
(6, 'som', 'samafale', 2002000, 100, '2023-06-16 06:08:23');

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `bill_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `Amount` decimal(12,0) DEFAULT NULL,
  `user` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`bill_id`, `employee_id`, `Amount`, `user`) VALUES
(1, 1, 200, 'admin');

--
-- Triggers `bill`
--
DELIMITER $$
CREATE TRIGGER `update_active` AFTER INSERT ON `bill` FOR EACH ROW BEGIN

update charge set active=1 WHERE
employee_id=new.employee_id;


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branch_id` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`branch_id`, `address`, `city`, `state`, `date`) VALUES
(1, 'hodan', 'mugdisho', 'banadir', '2023-05-07 20:54:52'),
(3, 'hilwaa', 'mugdisho', 'banadir', '2023-05-08 22:13:50'),
(4, 'wadada warshadaha', 'hargeysa', 'awdal', '2023-06-16 06:36:10');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_id` int(11) NOT NULL,
  `modal` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Category_id`, `modal`) VALUES
(1, 'bir dheer'),
(2, 'olyo'),
(3, 'mmm'),
(4, 'anwar'),
(5, 'anwar'),
(6, 'maanka'),
(7, 'maanka');

-- --------------------------------------------------------

--
-- Table structure for table `charge`
--

CREATE TABLE `charge` (
  `charge_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `title_id` int(11) NOT NULL,
  `Amount` decimal(12,0) NOT NULL,
  `month` int(11) NOT NULL,
  `year` varchar(100) NOT NULL,
  `Account_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `active` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `charge`
--
DELIMITER $$
CREATE TRIGGER `update_balance` AFTER INSERT ON `charge` FOR EACH ROW BEGIN
UPDATE account SET balance= balance-new.Amount
WHERE Account_id=new.Account_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `frist_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `frist_name`, `last_name`, `phone`, `address`, `city`, `state`, `date`) VALUES
(1, 'maxamed ', 'nuur', '616727782', 'dayniile', 'mugdisho', 'Banaadir', '2023-06-03 11:03:08'),
(2, 'shuuriye', 'saciid', '3733878', 'hilwaa', 'mugdisho', 'banaadir', '2023-06-04 14:26:54'),
(3, 'nafiso', 'saciid', '373783', 'hilwaa', 'mugdisho', 'banaadir', '2023-06-04 14:28:00'),
(4, 'cabdalla', 'abdiwaahid', '61728282', 'taleex', 'mugdisho', 'banadir', '2023-06-05 07:07:14'),
(5, 'nuur', 'cali', '266278268', 'hodan', 'mugdisho', 'banadir', '2023-06-05 07:31:56'),
(6, 'caisha', 'saciid', '6627628', 'hilwaa', 'mugdisho', 'banadir', '2023-06-05 07:32:20'),
(7, 'faiza', 'nuur', '2626782', 'yaaqshiid', 'mugdisho', 'banadir', '2023-06-05 07:32:42'),
(8, 'abdikaafi', 'saalax', '252565676', 'hilwaa', 'mugdisho', 'banadir', '2023-06-05 07:46:48'),
(9, 'abdifitaax', 'maxamed', '762767867', 'hilwaa', 'mugdisho', 'banaadir', '2023-06-05 07:47:23');

-- --------------------------------------------------------

--
-- Table structure for table `employe`
--

CREATE TABLE `employe` (
  `employee_id` int(11) NOT NULL,
  `frist_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `title_id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employe`
--

INSERT INTO `employe` (`employee_id`, `frist_name`, `last_name`, `phone`, `city`, `state`, `branch_id`, `title_id`, `date`) VALUES
(1, 'maanka', 'ali', '676823433', 'mugdisho', 'hiiran', 4, 3, '2023-06-18 07:46:46');

-- --------------------------------------------------------

--
-- Table structure for table `expense`
--

CREATE TABLE `expense` (
  `id` int(11) NOT NULL,
  `amount` float(9,2) NOT NULL,
  `type` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `Account_id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expense`
--

INSERT INTO `expense` (`id`, `amount`, `type`, `description`, `user_id`, `Account_id`, `date`) VALUES
(1, 200.00, 'Income', 'webhost', 'USR001', 5, '2023-06-03 22:31:26'),
(2, 400.00, 'Expense', 'kiro', 'USR001', 2, '2023-06-04 14:28:54'),
(3, 300.00, 'Income', 'web', 'USR001', 2, '2023-06-04 14:30:36'),
(4, 100.00, 'Income', 'web', 'USR001', 2, '2023-06-04 14:30:46'),
(5, 14700.00, 'Expense', 'mushaar', 'USR001', 3, '2023-06-18 07:27:54');

--
-- Triggers `expense`
--
DELIMITER $$
CREATE TRIGGER `update_acc` AFTER INSERT ON `expense` FOR EACH ROW BEGIN
    IF NEW.type = 'Income' THEN
        UPDATE account
        SET balance = balance+new.amount
        WHERE Account_id=new.Account_id;
        
        ELSE
                UPDATE account
        SET balance = balance-new.amount
        WHERE Account_id=new.Account_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `Category_id` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `suplier_id` int(11) NOT NULL,
  `unit_price` float(11,2) NOT NULL,
  `price` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`item_id`, `item_name`, `Category_id`, `size`, `suplier_id`, `unit_price`, `price`, `date`) VALUES
(2, 'toyota', 1, 66, 1, 7000.00, 7800, '2023-05-11 10:56:20'),
(3, 'marchines', 2, 69, 2, 4000.00, 4900, '2023-05-10 07:57:11'),
(4, 'Tesla Model S', 1, 34, 8, 9000.00, 9800, '2023-05-27 06:22:10'),
(5, 'Jaguar F-Type', 9, 34, 3, 9000.00, 9900, '2023-05-27 06:22:47'),
(6, 'Kia Sportage', 11, 34, 9, 9000.00, 9800, '2023-05-27 06:23:11'),
(7, 'Mazda MX-5 Miata', 12, 34, 11, 9000.00, 9800, '2023-05-27 06:23:33'),
(8, 'pay', 1, 122, 1, 100.00, 200, '2023-06-16 06:07:11'),
(9, 'matoor', 1, 30, 1, 100.00, 200, '2023-06-16 06:20:02');

-- --------------------------------------------------------

--
-- Table structure for table `job_title`
--

CREATE TABLE `job_title` (
  `title_id` int(11) NOT NULL,
  `position` varchar(50) NOT NULL,
  `salary` decimal(12,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_title`
--

INSERT INTO `job_title` (`title_id`, `position`, `salary`) VALUES
(1, 'waardiye', 200),
(2, 'cleaner', 240),
(3, 'Manager', 700),
(4, 'Assistant Manager', 500),
(5, 'Administrator', 2000);

-- --------------------------------------------------------

--
-- Table structure for table `month`
--

CREATE TABLE `month` (
  `month_id` int(11) NOT NULL,
  `month_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `month`
--

INSERT INTO `month` (`month_id`, `month_name`) VALUES
(1, 'Jan'),
(2, 'Feb'),
(3, 'Mar'),
(4, 'Apr'),
(5, 'May'),
(6, 'Jun'),
(7, 'July'),
(8, 'Aug'),
(9, 'Sep'),
(10, 'Oct'),
(11, 'Nov'),
(12, 'Dec');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `quantity` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `item_id`, `price`, `quantity`, `balance`, `status`, `date`) VALUES
(1, 1, 2, 500, 4, 9000, 'paid', '2023-06-18 07:25:45'),
(2, 3, 3, 14700, 3, 14700, 'pending', '2023-06-17 18:54:00');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `amount` decimal(12,0) NOT NULL,
  `account_id` int(11) NOT NULL,
  `p_method_id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`payment_id`, `customer_id`, `amount`, `account_id`, `p_method_id`, `date`) VALUES
(1, 1, 9000, 3, 1, '2023-06-18 07:25:45');

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `update_status` AFTER INSERT ON `payment` FOR EACH ROW BEGIN

UPDATE orders set STATUS='paid' WHERE customer_id=new.customer_id;


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payment_method`
--

CREATE TABLE `payment_method` (
  `p_method_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_method`
--

INSERT INTO `payment_method` (`p_method_id`, `name`) VALUES
(1, 'Evc'),
(2, 'EDahab'),
(3, 'Bank');

-- --------------------------------------------------------

--
-- Table structure for table `suplier`
--

CREATE TABLE `suplier` (
  `suplier_id` int(11) NOT NULL,
  `company_name` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suplier`
--

INSERT INTO `suplier` (`suplier_id`, `company_name`, `country`) VALUES
(1, 'Toyota', 'Japan'),
(2, 'Ford', 'United States'),
(3, 'General Motors (GM)', 'United States'),
(4, 'Honda', 'Japan'),
(5, 'Nissan', 'Japan'),
(6, 'Volkswagen (VW)', 'Germany'),
(7, 'BMW', 'Germany'),
(8, 'Tesla', 'United States'),
(9, 'Mazda', 'Japan'),
(10, 'Subaru', 'Japan'),
(11, 'Lexus', 'Japan'),
(12, 'Chevrolet', 'United States');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(50) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `image` varchar(50) NOT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'Active',
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `employee_id`, `username`, `password`, `image`, `status`, `date`) VALUES
('USR001', 1, 'maanka', '202cb962ac59075b964b07152d234b70', 'USR001.png', 'Active', '2023-06-18 07:47:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`Account_id`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `account_id` (`user`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_id`);

--
-- Indexes for table `charge`
--
ALTER TABLE `charge`
  ADD PRIMARY KEY (`charge_id`),
  ADD UNIQUE KEY `employe_id` (`employee_id`,`month`,`year`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `employe`
--
ALTER TABLE `employe`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `branch_id` (`branch_id`),
  ADD KEY `title_id` (`title_id`);

--
-- Indexes for table `expense`
--
ALTER TABLE `expense`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `car_modal_id` (`Category_id`),
  ADD KEY `suplier_id` (`suplier_id`);

--
-- Indexes for table `job_title`
--
ALTER TABLE `job_title`
  ADD PRIMARY KEY (`title_id`);

--
-- Indexes for table `month`
--
ALTER TABLE `month`
  ADD PRIMARY KEY (`month_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`);

--
-- Indexes for table `payment_method`
--
ALTER TABLE `payment_method`
  ADD PRIMARY KEY (`p_method_id`);

--
-- Indexes for table `suplier`
--
ALTER TABLE `suplier`
  ADD PRIMARY KEY (`suplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD KEY `employe_id` (`employee_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `Account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `branch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `charge`
--
ALTER TABLE `charge`
  MODIFY `charge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `employe`
--
ALTER TABLE `employe`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `expense`
--
ALTER TABLE `expense`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `job_title`
--
ALTER TABLE `job_title`
  MODIFY `title_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `month`
--
ALTER TABLE `month`
  MODIFY `month_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payment_method`
--
ALTER TABLE `payment_method`
  MODIFY `p_method_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `suplier`
--
ALTER TABLE `suplier`
  MODIFY `suplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employe`
--
ALTER TABLE `employe`
  ADD CONSTRAINT `employe_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`),
  ADD CONSTRAINT `employe_ibfk_2` FOREIGN KEY (`title_id`) REFERENCES `job_title` (`title_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
