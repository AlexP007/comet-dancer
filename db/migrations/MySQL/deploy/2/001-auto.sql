--
-- Created by SQL::Translator::Producer::MySQL
-- Created on Wed May 25 18:55:30 2022
--
;
SET foreign_key_checks=0;
--
-- Table: `roles`
--
CREATE TABLE `roles` (
  `id` integer NOT NULL auto_increment,
  `role` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `roles_role` (`role`)
) ENGINE=InnoDB;
--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `username` varchar(32) NOT NULL,
  `password` varchar(64) NULL,
  `name` varchar(128) NULL,
  `email` varchar(255) NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `registered` datetime NOT NULL,
  `lastlogin` datetime NULL,
  `pw_changed` datetime NULL,
  `pw_reset_code` varchar(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE `users_email` (`email`),
  UNIQUE `users_username` (`username`)
) ENGINE=InnoDB;
--
-- Table: `user_roles`
--
CREATE TABLE `user_roles` (
  `user_id` integer NOT NULL,
  `role_id` integer NOT NULL,
  INDEX `user_roles_idx_role_id` (`role_id`),
  INDEX `user_roles_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `user_roles_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `user_roles_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;
SET foreign_key_checks=1;
