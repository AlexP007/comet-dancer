-- Convert schema '/var/www/app/bin/../db/migrations/_source/deploy/1/001-auto.yml' to '/var/www/app/bin/../db/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE `users` ADD COLUMN `registered` datetime NOT NULL;

;

COMMIT;

