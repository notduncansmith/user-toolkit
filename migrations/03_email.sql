/* mite:up */
ALTER TABLE `user` 
  ADD COLUMN `email` VARCHAR(45) NOT NULL;


/* mite:down */
ALTER TABLE `user`
  DROP COLUMN `email`;