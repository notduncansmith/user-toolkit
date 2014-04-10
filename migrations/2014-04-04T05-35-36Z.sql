/* mite:up */
CREATE TABLE `user` (
  `id` VARCHAR(36) NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `streetAddress1` VARCHAR(100) NULL,
  `streetAddress2` VARCHAR(100) NULL,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(40) NULL,
  `zip` VARCHAR(5) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC)
);

/* mite:down */
DROP TABLE `user`;

