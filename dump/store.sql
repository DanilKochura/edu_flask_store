-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Дек 14 2023 г., 19:33
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `store`
--
CREATE DATABASE IF NOT EXISTS `store` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `store`;

DELIMITER $$
--
-- Процедуры
--
DROP PROCEDURE IF EXISTS `invoice_rep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `invoice_rep` (`rep_month` INT, `rep_year` INT)   BEGIN
 insert into invoie_rep
 select id_Inv, name, sum_price, date_sup
    from invoice join supplier on invoice.id_Sup=supplier.id_Sup
    where year(date_sup)=rep_year and month(date_sup)=rep_month;
END$$

DROP PROCEDURE IF EXISTS `supplier_rep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `supplier_rep` (`rep_month` INT, `rep_year` INT)   BEGIN
DECLARE done INT DEFAULT 0;
    DECLARE name_sup varchar(45);
    DECLARE bank_n varchar(45);
    DECLARE phone_n varchar(45);
    DECLARE date_treaty_s date;
    DECLARE C1 CURSOR FOR
    select supplier.name, bank, phone, date_treaty from supplier
where year(date_treaty)=rep_year and month(date_treaty)=rep_month;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
    SET done = 1;
  
    OPEN C1;
    FETCH C1 INTO name_sup, bank_n, phone_n, date_treaty_s;
    WHILE done = 0 DO
    INSERT INTO supplier_rep VALUES(NULL, name_sup, bank_n, phone_n, date_treaty_s);
    FETCH C1 INTO name_sup, bank_n, phone_n, date_treaty_s;
  END WHILE;
    CLOSE C1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `external_user`
--

DROP TABLE IF EXISTS `external_user`;
CREATE TABLE `external_user` (
  `user_id` int(11) NOT NULL,
  `user_group` varchar(45) NOT NULL,
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `external_user`
--

INSERT INTO `external_user` (`user_id`, `user_group`, `login`, `password`, `supplier_id`) VALUES
(1, 'supplier', 'rosprod', 'rosprod', 1),
(2, 'supplier', '5ka', '5ka', 2),
(3, 'supplier', 'perek', 'perek', 3),
(4, 'supplier', 'vvill', 'vvill', 4),
(5, 'supplier', 'metro', 'metro', 5),
(6, 'supplier', 'lenta', 'lenta', 6),
(7, 'supplier', 'ashan', 'ashan', 7);

-- --------------------------------------------------------

--
-- Структура таблицы `internal_user`
--

DROP TABLE IF EXISTS `internal_user`;
CREATE TABLE `internal_user` (
  `user_id` int(11) NOT NULL,
  `user_group` varchar(45) DEFAULT NULL,
  `login` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `internal_user`
--

INSERT INTO `internal_user` (`user_id`, `user_group`, `login`, `password`) VALUES
(1, 'admin', 'admin', 'admin'),
(2, 'internal', 'manager', 'manager');

-- --------------------------------------------------------

--
-- Структура таблицы `invoice`
--

DROP TABLE IF EXISTS `invoice`;
CREATE TABLE `invoice` (
  `id_Inv` int(11) NOT NULL,
  `id_Sup` int(11) NOT NULL,
  `sum_price` int(11) NOT NULL,
  `date_sup` date NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `invoice`
--

INSERT INTO `invoice` (`id_Inv`, `id_Sup`, `sum_price`, `date_sup`, `status`) VALUES
(60, 1, 159869, '2023-12-09', 0),
(61, 1, 6000, '2023-12-09', 0),
(62, 1, 6390, '2023-12-09', 0),
(63, 4, 43523, '2023-12-09', 0),
(64, 6, 18930, '2023-12-09', 0),
(65, 5, 49492, '2023-12-09', 0),
(66, 6, 5600, '2023-12-11', 0),
(67, 6, 14840, '2023-12-12', 0),
(68, 6, 6942, '2023-12-12', 0),
(69, 6, 240, '2023-12-13', 0),
(70, 4, 10200, '2023-12-13', 0),
(71, 4, 5600, '2023-12-13', 0),
(72, 4, 9600, '2023-12-13', 0),
(73, 2, 122, '2023-12-14', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `invoie_rep`
--

DROP TABLE IF EXISTS `invoie_rep`;
CREATE TABLE `invoie_rep` (
  `id_Inv_rep` int(11) NOT NULL,
  `name_sup` varchar(45) NOT NULL,
  `sum_sup` int(11) NOT NULL,
  `date_sup` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `invoie_rep`
--

INSERT INTO `invoie_rep` (`id_Inv_rep`, `name_sup`, `sum_sup`, `date_sup`) VALUES
(60, 'РосПродукт', 159869, '2023-12-09'),
(61, 'РосПродукт', 6000, '2023-12-09'),
(62, 'РосПродукт', 6390, '2023-12-09'),
(63, 'ВкусВилл', 43523, '2023-12-09'),
(64, 'Лента', 18930, '2023-12-09'),
(65, 'Метро', 49492, '2023-12-09'),
(66, 'Лента', 5600, '2023-12-11');

-- --------------------------------------------------------

--
-- Структура таблицы `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id_prod` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `prod_code` int(11) NOT NULL,
  `units` varchar(45) NOT NULL,
  `group` varchar(45) NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `product`
--

INSERT INTO `product` (`id_prod`, `name`, `prod_code`, `units`, `group`, `image`) VALUES
(1, 'ручки', 123, 'шт', 'канцелярия', 'https://vsememy.ru/kartinki/wp-content/uploads/2023/03/1639220083_34-papik-pro-p-ruchka-klipart-34.jpg'),
(2, 'сахар', 111, 'кг', 'продукты', 'https://palladi.ru/upload/iblock/11a/11af009f8980092cc1821200154ef028.jpg'),
(3, 'молоко', 100, 'шт', 'продукты', 'https://www.freepngdownload.com/image/thumb/milk-png-free-download-65.png'),
(4, 'конфеты', 902, 'кг', 'продукты', 'https://cdn3.static1-sima-land.com/items/4284871/0/700.jpg'),
(5, 'вода', 320, 'л', 'продукты', 'https://uploads-ssl.webflow.com/6263eb84515057209d2b1537/62e0526fadde6b19f8103651_bottledwater-blank.jpg'),
(6, 'мыло', 289, 'шт', 'бытовая химия', 'https://sun9-59.userapi.com/impf/tV9BLY0ewkYgeOxKYjii9FKn9HofWa2f8hEPCg/fwjMD_ZI3xo.jpg?size=1080x783&quality=96&sign=67e6a14f6b9e0a898534854c99f37bdf&c_uniq_tag=e-drY_go9cHzAWLMDSWv3ndL1AY8nGglTK4y3IbBaP0&type=album'),
(7, 'масло растительное', 279, 'шт', 'продукты', 'https://w7.pngwing.com/pngs/927/527/png-transparent-vegetable-oil-cooking-oils-seed-oil-olive-oil-miscellaneous-food-plastic-bottle.png'),
(8, 'соль', 209, 'шт', 'продукты', 'https://avatars.mds.yandex.net/i?id=5629f5215e3ac1f25211bfabfc9bbd116296209a-9709143-images-thumbs&n=13'),
(9, 'шампунь', 620, 'шт', 'косметика', 'https://c.shld.net/rpx/i/s/i/spin/10040446/prod_2241215612??hei=64&wid=64&qlt=50'),
(10, 'стиральный порошок', 459, 'кг', 'бытовая химия', 'https://avatars.mds.yandex.net/i?id=8976216ebf5a2d677c68cd68de74a0c9c1753fed-9705905-images-thumbs&n=13'),
(11, 'лимон', 250, 'шт', 'продукты', 'https://www.freepngimg.com/thumb/lemon/1-2-lemon-picture.png'),
(12, 'печенье', 790, 'кг', 'продукты', 'http://antivor.ru/uploads/thumbs/store/product/0x600_ba48ecd47300993f0a9bef2aacbb2663.jpg'),
(13, 'шоколад', 345, 'шт', 'продукты', 'https://grizly.club/uploads/posts/2023-01/1674674346_grizly-club-p-shokoladka-klipart-52.jpg'),
(14, 'курица', 348, 'кг', 'продукты', 'https://i.imgflip.com/4g0oh7.png'),
(15, 'капуста', 820, 'шт', 'продукты', 'https://data10.proshkolu.ru/content/media/pic/std/4000000/3862000/3861873-6bdc77c7a16c787d.png'),
(16, 'яйца', 986, 'шт', 'продукты', 'https://imgproxy.sbermarket.ru/imgproxy/size-680-680/czM6Ly9jb250ZW50LWltYWdlcy1wcm9kL3Byb2R1Y3RzLzE1OTg1ODQ1L29yaWdpbmFsLzEvMjAyMi0wOC0yM1QxNSUzQTIwJTNBMTEuMTczMDAwJTJCMDAlM0EwMC8xNTk4NTg0NV8xLmpwZw==.jpg'),
(17, 'хлеб', 211, 'шт', 'продукты', 'https://media.baamboozle.com/uploads/images/44351/1588929083_853078');

-- --------------------------------------------------------

--
-- Структура таблицы `product_invoice`
--

DROP TABLE IF EXISTS `product_invoice`;
CREATE TABLE `product_invoice` (
  `id_prod_inv` int(11) NOT NULL,
  `id_Inv` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `product_invoice`
--

INSERT INTO `product_invoice` (`id_prod_inv`, `id_Inv`, `id_prod`, `amount`, `price`) VALUES
(81, 60, 1, 1, 57),
(82, 60, 15, 1, 24),
(83, 60, 2, 1, 6),
(84, 60, 3, 23, 45),
(85, 60, 5, 26, 100),
(86, 60, 9, 23, 6789),
(87, 61, 2, 50, 80),
(88, 61, 3, 20, 100),
(89, 62, 1, 60, 59),
(90, 62, 2, 50, 57),
(91, 63, 1, 89, 456),
(92, 63, 2, 6, 166),
(93, 63, 3, 29, 67),
(94, 64, 13, 80, 57),
(95, 64, 14, 30, 379),
(96, 64, 17, 50, 60),
(97, 65, 12, 120, 80),
(98, 65, 15, 56, 37),
(99, 65, 16, 340, 89),
(100, 65, 9, 20, 378),
(101, 66, 1, 65, 40),
(102, 66, 11, 50, 60),
(103, 67, 1, 132, 45),
(104, 67, 3, 100, 89),
(105, 68, 1, 78, 89),
(106, 69, 1, 10, 24),
(107, 70, 4, 30, 340),
(108, 71, 5, 140, 40),
(109, 72, 6, 75, 128),
(110, 73, 1, 1, 122);

-- --------------------------------------------------------

--
-- Структура таблицы `stock`
--

DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock` (
  `id_stock` int(11) NOT NULL,
  `id_product` int(11) NOT NULL,
  `date_up` varchar(45) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `stock`
--

INSERT INTO `stock` (`id_stock`, `id_product`, `date_up`, `amount`) VALUES
(23, 2, '2023-12-09', 106),
(24, 3, '2023-12-12', 149),
(25, 1, '2023-12-14', 435),
(26, 13, '2023-12-09', 80),
(27, 14, '2023-12-09', 30),
(28, 17, '2023-12-09', 50),
(29, 12, '2023-12-09', 120),
(30, 15, '2023-12-09', 56),
(31, 16, '2023-12-09', 340),
(32, 9, '2023-12-09', 20),
(33, 11, '2023-12-11', 50),
(34, 4, '2023-12-13', 30),
(35, 5, '2023-12-13', 140),
(36, 6, '2023-12-13', 75);

-- --------------------------------------------------------

--
-- Структура таблицы `supplier`
--

DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id_Sup` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `city` varchar(45) NOT NULL,
  `bank` varchar(45) NOT NULL,
  `bank_acc` int(11) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `date_treaty` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `supplier`
--

INSERT INTO `supplier` (`id_Sup`, `name`, `city`, `bank`, `bank_acc`, `phone`, `date_treaty`) VALUES
(1, 'РосПродукт', 'Москва', 'Сбербанк', 1234567, '79109792161', '2023-10-24'),
(2, 'Пятерочка', 'Ярославль', 'Тинькофф', 1345892, '79121242298', '2023-09-01'),
(3, 'Перекресток', 'Усинск', 'Сбербанк', 2132444, '78910382433', '2023-09-23'),
(4, 'ВкусВилл', 'Москва', 'Сбербанк', 3222225, '74568765345', '2022-10-01'),
(5, 'Метро', 'Воронеж', 'Сбербанк', 3456789, '79876534567', '2023-10-08'),
(6, 'Лента', 'Саратов', 'АльфаБанк', 5678998, '79876543223', '2023-01-03'),
(7, 'Ашан', 'Краснодар', 'Сбербанк', 4567899, '79876543238', '2023-02-10');

-- --------------------------------------------------------

--
-- Структура таблицы `supplier_rep`
--

DROP TABLE IF EXISTS `supplier_rep`;
CREATE TABLE `supplier_rep` (
  `id_rep_sup` int(11) NOT NULL,
  `name_sup` varchar(45) NOT NULL,
  `bank` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `date_treaty` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Дамп данных таблицы `supplier_rep`
--

INSERT INTO `supplier_rep` (`id_rep_sup`, `name_sup`, `bank`, `phone`, `date_treaty`) VALUES
(11, 'Пятерочка', 'Тинькофф', '79121242298', '2023-09-01'),
(12, 'Перекресток', 'Сбербанк', '78910382433', '2023-09-23'),
(13, 'РосПродукт', 'Сбербанк', '79109792161', '2023-10-24'),
(14, 'Метро', 'Сбербанк', '79876534567', '2023-10-08');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `external_user`
--
ALTER TABLE `external_user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `id_supplier_idx` (`supplier_id`);

--
-- Индексы таблицы `internal_user`
--
ALTER TABLE `internal_user`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id_Inv`),
  ADD KEY `id_Sup_idx` (`id_Sup`);

--
-- Индексы таблицы `invoie_rep`
--
ALTER TABLE `invoie_rep`
  ADD PRIMARY KEY (`id_Inv_rep`);

--
-- Индексы таблицы `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id_prod`);

--
-- Индексы таблицы `product_invoice`
--
ALTER TABLE `product_invoice`
  ADD PRIMARY KEY (`id_prod_inv`),
  ADD KEY `id_prod_idx` (`id_prod`),
  ADD KEY `id_Inv_idx` (`id_Inv`);

--
-- Индексы таблицы `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`id_stock`),
  ADD KEY `id_prod_idx` (`id_product`);

--
-- Индексы таблицы `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_Sup`);

--
-- Индексы таблицы `supplier_rep`
--
ALTER TABLE `supplier_rep`
  ADD PRIMARY KEY (`id_rep_sup`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `invoice`
--
ALTER TABLE `invoice`
  MODIFY `id_Inv` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT для таблицы `product_invoice`
--
ALTER TABLE `product_invoice`
  MODIFY `id_prod_inv` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT для таблицы `stock`
--
ALTER TABLE `stock`
  MODIFY `id_stock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `supplier_rep`
--
ALTER TABLE `supplier_rep`
  MODIFY `id_rep_sup` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `external_user`
--
ALTER TABLE `external_user`
  ADD CONSTRAINT `supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id_Sup`);

--
-- Ограничения внешнего ключа таблицы `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `id_Sup` FOREIGN KEY (`id_Sup`) REFERENCES `supplier` (`id_Sup`);

--
-- Ограничения внешнего ключа таблицы `product_invoice`
--
ALTER TABLE `product_invoice`
  ADD CONSTRAINT `id_Inv` FOREIGN KEY (`id_Inv`) REFERENCES `invoice` (`id_Inv`),
  ADD CONSTRAINT `id_prod` FOREIGN KEY (`id_prod`) REFERENCES `product` (`id_prod`);

--
-- Ограничения внешнего ключа таблицы `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `id_product` FOREIGN KEY (`id_product`) REFERENCES `product` (`id_prod`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
