/* mite:up */
CREATE TABLE `role` (
  `id` VARCHAR(36) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC)
);

CREATE TABLE `user_role` (
  `userId` VARCHAR(36) NOT NULL,
  `roleId` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`userId`),
  CONSTRAINT `userId`
    FOREIGN KEY (`userId`)
    REFERENCES `user` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `roleId`
    FOREIGN KEY (`roleId`)
    REFERENCES `role` (`id`)
    ON DELETE CASCADE
);



/* mite:down */
DROP TABLE `user_role`;
DROP TABLE `role`;