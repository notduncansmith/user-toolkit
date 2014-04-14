/* mite:up */
ALTER TABLE `user` 
  ADD COLUMN `password` VARCHAR(100) NOT NULL AFTER `zip`,
  ADD COLUMN `username` VARCHAR(36) NOT NULL AFTER `password`;


/* mite:down */
ALTER TABLE `user`
  DROP COLUMN `username`,
  DROP COLUMN `password`;