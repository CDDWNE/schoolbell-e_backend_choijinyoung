-- Host: 127.0.0.1    Database: approvals
-- ------------------------------------------------------
-- Server version	8.0.41
USE approvals;


DROP TABLE IF EXISTS `approval_histories`;
DROP TABLE IF EXISTS `approval_requests`;
DROP TABLE IF EXISTS `user_roles`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `users`;

--
-- Table structure for table 'users'
--
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `join_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'roles'
--
CREATE TABLE `roles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `role_name` VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'user_roles'
--
CREATE TABLE `user_roles` (
  `user_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'approve_requests'
--
CREATE TABLE `approval_requests` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `requester_id` INT NOT NULL,
  `request_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT,
  `current_step` INT NOT NULL DEFAULT 1,
  `total_steps` INT NOT NULL,
  `overall_status` ENUM('pending', 'in_progress', 'approved', 'rejected', 'canceled') NOT NULL DEFAULT 'pending',
  `current_approver` INT NOT NULL,
  `feedback` TEXT,
  FOREIGN KEY (`requester_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`current_approver`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table 'approve_histories'
--
CREATE TABLE `approval_histories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `approval_request_id` INT NOT NULL,
  `step` INT NOT NULL,
  `approver_id` INT NOT NULL,
  `status` ENUM('approved', 'rejected', 'canceled') NOT NULL,
  `action_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`approval_request_id`) REFERENCES `approval_requests`(`id`),
  FOREIGN KEY (`approver_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- query for pending approval requests to a specific user
--
PREPARE approval_request FROM
'SELECT
    ar.request_date,
    ar.title,
    ar.content,
    ar.current_step,
    ar.overall_status,
    u.name as requester_name
FROM approval_requests ar
JOIN users u ON ar.requester_id = u.id
WHERE ar.current_approver = ?
	AND ar.overall_status IN (''pending'', ''in_progress'')';
