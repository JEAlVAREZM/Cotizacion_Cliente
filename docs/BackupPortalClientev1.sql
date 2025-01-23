-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.30 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para cotizador
CREATE DATABASE IF NOT EXISTS `cotizador` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cotizador`;

-- Volcando estructura para procedimiento cotizador.sp_d_cotizacion_01
DELIMITER //
CREATE PROCEDURE `sp_d_cotizacion_01`(
	IN `pcotd_id` INT,
	IN `pcot_id` INT
)
BEGIN
	UPDATE td_cotizacion 
	SET 
	est = 0, 
	fech_elim=NOW()
	WHERE 
	cotd_id = pcotd_id;
	
	UPDATE tm_cotizacion 
	 SET
	 	cot_subtotal = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_profit = (SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_total = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)+(SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)

	 WHERE
	 	cot_id = pcot_id;
	
	SELECT pcotd_id AS 'cotd_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_i_cotizacion_01
DELIMITER //
CREATE PROCEDURE `sp_i_cotizacion_01`(
	IN `pcli_id` INT,
	IN `pcon_id` INT,
	IN `pcli_ruc` VARCHAR(50),
	IN `pcon_telf` VARCHAR(50),
	IN `pcon_email` VARCHAR(50),
	IN `pcot_descrip` VARCHAR(500),
	IN `pusu_id` INT
)
BEGIN
	 INSERT INTO tm_cotizacion (cot_id,cli_id, con_id,cli_ruc,con_telf,con_email,cot_descrip,usu_id,fech_crea,est)
    VALUES (null,pcli_id, pcon_id,pcli_ruc,pcon_telf,pcon_email,pcot_descrip,pusu_id,NOW(),2);
    
    SELECT LAST_INSERT_ID() AS 'cot_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_i_cotizacion_02
DELIMITER //
CREATE PROCEDURE `sp_i_cotizacion_02`(
	IN `pcot_id` INT,
	IN `pcat_id` INT,
	IN `pprod_id` INT,
	IN `pcotd_precio` DECIMAL(8,2),
	IN `pcotd_cant` INT,
	IN `pcotd_tipo` VARCHAR(1)
)
BEGIN
	 DECLARE pcotd_total DECIMAL(8,2);
    SET pcotd_total = pcotd_precio * pcotd_cant;

	 INSERT INTO td_cotizacion (cotd_id,cot_id,cat_id, prod_id,cotd_precio,cotd_cant,cotd_profit,cotd_total,cotd_tipo,fech_crea,est)
	 VALUES (null,pcot_id,pcat_id,pprod_id,pcotd_precio,pcotd_cant,0,pcotd_total,pcotd_tipo,NOW(),1);
	 
	 UPDATE tm_cotizacion 
	 SET
	 	cot_subtotal = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_profit = (SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_total = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)+(SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)

	 WHERE
	 	cot_id = pcot_id;
	 
	 SELECT LAST_INSERT_ID() AS 'cotd_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_l_contacto_01
DELIMITER //
CREATE PROCEDURE `sp_l_contacto_01`(
	IN `pcon_email` VARCHAR(50),
	IN `pcon_pass` VARCHAR(30)
)
BEGIN
	SELECT
	tm_contacto.con_id,
	tm_contacto.cli_id,
	tm_contacto.car_id,
	tm_contacto.con_nom,
	tm_contacto.con_email,
	tm_contacto.con_telf,
	tm_cliente.cli_id,
	tm_cliente.cli_nom,
	tm_cargo.car_id,
	tm_cargo.car_nom
	FROM tm_contacto
	INNER JOIN tm_cliente ON tm_contacto.cli_id = tm_cliente.cli_id
	INNER JOIN tm_cargo ON tm_contacto.car_id = tm_cargo.car_id
	WHERE
	tm_contacto.est=1
	AND TRIM(tm_contacto.con_email) = TRIM(pcon_email)
	AND TRIM(tm_contacto.con_pass) = TRIM(pcon_pass);
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_l_contacto_02
DELIMITER //
CREATE PROCEDURE `sp_l_contacto_02`(
	IN `pcon_id` int
)
BEGIN
	SET lc_time_names = 'es_ES';
	
	SELECT 
	tm_cotizacion.cot_id,
	tm_cotizacion.cli_id,
	tm_cliente.cli_nom,
	tm_cotizacion.cli_ruc,
	tm_cliente.cli_telf,
	tm_cliente.cli_email,
	tm_cotizacion.con_id,
	tm_contacto.con_nom,
	tm_cotizacion.con_telf,
	tm_cotizacion.con_email,
	tm_cotizacion.cot_saludo,
	tm_cotizacion.cot_adicional,
	tm_cotizacion.cot_contrato,
	tm_cotizacion.emp_id,
	tm_empresa.emp_nom,
	tm_empresa.emp_porcen,
	tm_empresa.emp_ruc,
	tm_empresa.emp_telf,
	tm_empresa.emp_email,
	tm_empresa.emp_web,
	cot_descrip,
	cot_subtotal,
	cot_profit,
	cot_total,
	tm_cotizacion.fech_crea,
	DATE_FORMAT(fech_crea, '%d/%m/%Y') AS fech_crea_format,
	MONTHNAME(fech_crea) AS mes_en_texto,
	CONCAT(
        DAYNAME(fech_crea),
        ' ',
        DATE_FORMAT(fech_crea, '%d'),
        ' ',
        MONTHNAME(fech_crea),
        ' del ',
        DATE_FORMAT(fech_crea, '%Y')
	) AS fecha_formateada,
	tm_cotizacion.fech_envio,
	tm_cotizacion.fech_visto,
	tm_cotizacion.fech_respuesta,
	CONCAT(
	  DAYNAME(tm_cotizacion.fech_respuesta),
	  ' ',
	  DATE_FORMAT(tm_cotizacion.fech_respuesta, '%d'),
	  ' ',
	  MONTHNAME(tm_cotizacion.fech_respuesta),
	  ' del ',
	  DATE_FORMAT(tm_cotizacion.fech_respuesta, '%Y'),
	 ' ',
	 DATE_FORMAT(tm_cotizacion.fech_respuesta, '%H:%i:%s')
	) AS fech_formateada_respuesta,
	CONCAT(
	  DAYNAME(tm_cotizacion.fech_envio),
	  ' ',
	  DATE_FORMAT(tm_cotizacion.fech_envio, '%d'),
	  ' ',
	  MONTHNAME(tm_cotizacion.fech_envio),
	  ' del ',
	  DATE_FORMAT(tm_cotizacion.fech_envio, '%Y'),
	 ' ',
	 DATE_FORMAT(tm_cotizacion.fech_envio, '%H:%i:%s')
	) AS fech_formateada_envio,
	CASE
        WHEN tm_cotizacion.cot_tipo = 'Visto' THEN 'Pendiente'
        ELSE cot_tipo
   END AS cot_tipo,
	tm_cotizacion.usu_id,
	tm_usuario.usu_nom,
	tm_usuario.usu_correo,
    CASE
        WHEN cot_tipo = 'Rechazado' THEN 'danger'
        WHEN cot_tipo = 'Aceptado' THEN 'success'
        WHEN cot_tipo = 'Visto' THEN 'focus'
        WHEN cot_tipo = 'Enviado' THEN 'warning'
        ELSE NULL
    END AS cot_color
	FROM 
	tm_cotizacion INNER JOIN 
	tm_cliente ON tm_cotizacion.cli_id = tm_cliente.cli_id INNER JOIN
	tm_contacto ON tm_cotizacion.con_id = tm_contacto.con_id INNER JOIN
	tm_empresa ON tm_cotizacion.emp_id = tm_empresa.emp_id INNER JOIN
	tm_usuario ON tm_cotizacion.usu_id = tm_usuario.usu_id
	WHERE
	tm_cotizacion.con_id = pcon_id
	AND cot_tipo NOT IN ("Borrador");
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_l_contacto_03
DELIMITER //
CREATE PROCEDURE `sp_l_contacto_03`(
	IN `pcon_id` int
)
BEGIN
	SELECT 
	tm_cotizacion.cot_id AS id,
	tm_cotizacion.fech_envio AS start,
	CONCAT("Cotización Nro: "," ",tm_cotizacion.cot_id) AS title,
	CONCAT(tm_cotizacion.cot_tipo," - ","Cotización para el cliente"," ",tm_cliente.cli_nom," ","y su contacto"," ",tm_contacto.con_nom) AS description,
	CASE
        WHEN tm_cotizacion.cot_tipo = 'Rechazado' THEN 'fc-event-light fc-event-solid-danger'
        WHEN tm_cotizacion.cot_tipo = 'Aceptado' THEN 'fc-event-light fc-event-solid-success'
        WHEN tm_cotizacion.cot_tipo = 'Visto' THEN 'fc-event-light fc-event-solid-focus'
        WHEN tm_cotizacion.cot_tipo = 'Enviado' THEN 'fc-event-light fc-event-solid-warning'
        ELSE NULL
   END AS className
	FROM 
	tm_cotizacion INNER JOIN 
	tm_cliente ON tm_cotizacion.cli_id = tm_cliente.cli_id INNER JOIN
	tm_contacto ON tm_cotizacion.con_id = tm_contacto.con_id INNER JOIN
	tm_empresa ON tm_cotizacion.emp_id = tm_empresa.emp_id INNER JOIN
	tm_usuario ON tm_cotizacion.usu_id = tm_usuario.usu_id
	WHERE
	tm_cotizacion.con_id = pcon_id
	AND cot_tipo NOT IN ("Borrador");
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_l_cotizacion_01
DELIMITER //
CREATE PROCEDURE `sp_l_cotizacion_01`(
	IN `pcot_id` INT
)
BEGIN
	SET lc_time_names = 'es_ES';
	
	SELECT 
	tm_cotizacion.cot_id,
	tm_cotizacion.cli_id,
	tm_cliente.cli_nom,
	tm_cotizacion.cli_ruc,
	tm_cliente.cli_telf,
	tm_cliente.cli_email,
	tm_cotizacion.con_id,
	tm_contacto.con_nom,
	tm_contacto.con_pass,
	tm_cotizacion.con_telf,
	tm_cotizacion.con_email,
	tm_cotizacion.cot_saludo,
	tm_cotizacion.cot_adicional,
	tm_cotizacion.cot_contrato,
	tm_cotizacion.emp_id,
	tm_empresa.emp_nom,
	tm_empresa.emp_porcen,
	tm_empresa.emp_ruc,
	tm_empresa.emp_telf,
	tm_empresa.emp_email,
	tm_empresa.emp_web,
	cot_descrip,
	cot_subtotal,
	cot_profit,
	cot_total,
	tm_cotizacion.fech_crea,
	DATE_FORMAT(fech_crea, '%d/%m/%Y') AS fech_crea_format,
	MONTHNAME(fech_crea) AS mes_en_texto,
	CONCAT(
        DAYNAME(fech_crea),
        ' ',
        DATE_FORMAT(fech_crea, '%d'),
        ' ',
        MONTHNAME(fech_crea),
        ' del ',
        DATE_FORMAT(fech_crea, '%Y')
    ) AS fecha_formateada,
    tm_cotizacion.fech_envio,
    tm_cotizacion.fech_visto,
    tm_cotizacion.fech_respuesta,
    CONCAT(
        DAYNAME(tm_cotizacion.fech_respuesta),
        ' ',
        DATE_FORMAT(tm_cotizacion.fech_respuesta, '%d'),
        ' ',
        MONTHNAME(tm_cotizacion.fech_respuesta),
        ' del ',
        DATE_FORMAT(tm_cotizacion.fech_respuesta, '%Y'),
	    ' ',
	    DATE_FORMAT(tm_cotizacion.fech_respuesta, '%H:%i:%s')
    ) AS fech_formateada_respuesta,
    tm_cotizacion.cot_tipo,
    tm_cotizacion.usu_id,
    tm_usuario.usu_nom,
    tm_usuario.usu_correo,
        CONCAT(
        DAYNAME(tm_cotizacion.fech_crea),
        ' ',
        DATE_FORMAT(tm_cotizacion.fech_crea, '%d'),
        ' ',
        MONTHNAME(tm_cotizacion.fech_crea),
        ' del ',
        DATE_FORMAT(tm_cotizacion.fech_crea, '%Y'),
	    ' ',
	    DATE_FORMAT(tm_cotizacion.fech_crea, '%H:%i:%s')
    ) AS l_fech_crea,
    CONCAT(
        DAYNAME(tm_cotizacion.fech_envio),
        ' ',
        DATE_FORMAT(tm_cotizacion.fech_envio, '%d'),
        ' ',
        MONTHNAME(tm_cotizacion.fech_envio),
        ' del ',
        DATE_FORMAT(tm_cotizacion.fech_envio, '%Y'),
	    ' ',
	    DATE_FORMAT(tm_cotizacion.fech_envio, '%H:%i:%s')
    ) AS l_fech_envio,
    CONCAT(
        DAYNAME(tm_cotizacion.fech_visto),
        ' ',
        DATE_FORMAT(tm_cotizacion.fech_visto, '%d'),
        ' ',
        MONTHNAME(tm_cotizacion.fech_visto),
        ' del ',
        DATE_FORMAT(tm_cotizacion.fech_visto, '%Y'),
	    ' ',
	    DATE_FORMAT(tm_cotizacion.fech_visto, '%H:%i:%s')
    ) AS l_fech_visto
	FROM 
	tm_cotizacion INNER JOIN 
	tm_cliente ON tm_cotizacion.cli_id = tm_cliente.cli_id INNER JOIN
	tm_contacto ON tm_cotizacion.con_id = tm_contacto.con_id INNER JOIN
	tm_empresa ON tm_cotizacion.emp_id = tm_empresa.emp_id INNER JOIN
	tm_usuario ON tm_cotizacion.usu_id = tm_usuario.usu_id
	WHERE
	tm_cotizacion.cot_id = pcot_id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_l_cotizacion_02
DELIMITER //
CREATE PROCEDURE `sp_l_cotizacion_02`(
	IN pusu_id INT
)
BEGIN
	SET lc_time_names = 'es_ES';
	
	SELECT 
	tm_cotizacion.cot_id,
	tm_cotizacion.cli_id,
	tm_cliente.cli_nom,
	tm_cotizacion.cli_ruc,
	tm_cliente.cli_telf,
	tm_cliente.cli_email,
	tm_cotizacion.con_id,
	tm_contacto.con_nom,
	tm_cotizacion.con_telf,
	tm_cotizacion.con_email,
	tm_cotizacion.cot_saludo,
	tm_cotizacion.cot_adicional,
	tm_cotizacion.cot_contrato,
	tm_cotizacion.emp_id,
	tm_empresa.emp_nom,
	tm_empresa.emp_porcen,
	tm_empresa.emp_ruc,
	tm_empresa.emp_telf,
	tm_empresa.emp_email,
	tm_empresa.emp_web,
	cot_descrip,
	cot_subtotal,
	cot_profit,
	cot_total,
	tm_cotizacion.fech_crea,
	DATE_FORMAT(fech_crea, '%d/%m/%Y') AS fech_crea_format,
	MONTHNAME(fech_crea) AS mes_en_texto,
	CONCAT(
        DAYNAME(fech_crea),
        ' ',
        DATE_FORMAT(fech_crea, '%d'),
        ' ',
        MONTHNAME(fech_crea),
        ' del ',
        DATE_FORMAT(fech_crea, '%Y')
    ) AS fecha_formateada,
    tm_cotizacion.fech_envio,
    tm_cotizacion.fech_visto,
    tm_cotizacion.fech_respuesta,
    CONCAT(
        DAYNAME(tm_cotizacion.fech_respuesta),
        ' ',
        DATE_FORMAT(tm_cotizacion.fech_respuesta, '%d'),
        ' ',
        MONTHNAME(tm_cotizacion.fech_respuesta),
        ' del ',
        DATE_FORMAT(tm_cotizacion.fech_respuesta, '%Y'),
	    ' ',
	    DATE_FORMAT(tm_cotizacion.fech_respuesta, '%H:%i:%s')
    ) AS fech_formateada_respuesta,
    tm_cotizacion.cot_tipo,
    tm_cotizacion.usu_id,
    tm_usuario.usu_nom,
    tm_usuario.usu_correo
	FROM 
	tm_cotizacion INNER JOIN 
	tm_cliente ON tm_cotizacion.cli_id = tm_cliente.cli_id INNER JOIN
	tm_contacto ON tm_cotizacion.con_id = tm_contacto.con_id INNER JOIN
	tm_empresa ON tm_cotizacion.emp_id = tm_empresa.emp_id INNER JOIN
	tm_usuario ON tm_cotizacion.usu_id = tm_usuario.usu_id
	WHERE
	tm_cotizacion.usu_id = pusu_id;
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_u_cotizacion_01
DELIMITER //
CREATE PROCEDURE `sp_u_cotizacion_01`(
	IN `pcotd_id` INT,
	IN `pcotd_precio` DECIMAL(8,2),
	IN `pcotd_cant` INT,
	IN `pcotd_profit` DECIMAL(8,2),
	IN `pcot_id` INT
)
BEGIN
   DECLARE pcotd_total DECIMAL(8,2);
    
	SET pcotd_total = (pcotd_cant * pcotd_precio) + pcotd_profit;
	 
	UPDATE td_cotizacion 
		SET 
	   	cotd_precio = pcotd_precio,
	   	cotd_cant = pcotd_cant,
	   	cotd_profit = pcotd_profit,
	   	cotd_total = pcotd_total
		WHERE 
	   	cotd_id = pcotd_id;
	   	
	 UPDATE tm_cotizacion 
	 SET
	 	cot_subtotal = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_profit = (SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1),
	 	cot_total = (SELECT SUM(cotd_total) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)+(SELECT SUM(cotd_profit) FROM td_cotizacion WHERE cot_id=pcot_id AND cotd_tipo='D' AND est=1)
	 WHERE
	 	cot_id = pcot_id;
        
   SELECT pcotd_id AS 'cotd_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_u_cotizacion_02
DELIMITER //
CREATE PROCEDURE `sp_u_cotizacion_02`(
	IN `pcot_id` INT,
	IN `pcot_saludo` VARCHAR(3000),
	IN `pcot_adicional` VARCHAR(3000),
	IN `pcot_contrato` VARCHAR(8000)
)
BEGIN
   UPDATE tm_cotizacion
   SET
   	cot_saludo = pcot_saludo,
   	cot_adicional = pcot_adicional,
   	cot_contrato = pcot_contrato,
   	cot_tipo = 'Enviado',
   	fech_envio = NOW(),
   	est = 1
   WHERE
   	cot_id = pcot_id;
   	
   SELECT pcot_id AS 'cot_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_u_cotizacion_03
DELIMITER //
CREATE PROCEDURE `sp_u_cotizacion_03`(
	IN `pcot_id` INT
)
BEGIN
   UPDATE tm_cotizacion
   SET
   	cot_tipo='Visto',
   	fech_visto = NOW()
   WHERE
   	cot_id = pcot_id;
   	
   SELECT pcot_id AS 'cot_id';
END//
DELIMITER ;

-- Volcando estructura para procedimiento cotizador.sp_u_cotizacion_04
DELIMITER //
CREATE PROCEDURE `sp_u_cotizacion_04`(
	IN `pcot_id` INT,
	IN `pcot_tipo` VARCHAR(50)
)
BEGIN
   UPDATE tm_cotizacion
   SET
   	cot_tipo=pcot_tipo,
   	fech_respuesta = NOW()
   WHERE
   	cot_id = pcot_id;
   	
   SELECT pcot_id AS 'cot_id';
END//
DELIMITER ;

-- Volcando estructura para tabla cotizador.td_cotizacion
CREATE TABLE IF NOT EXISTS `td_cotizacion` (
  `cotd_id` int NOT NULL AUTO_INCREMENT,
  `cot_id` int DEFAULT NULL,
  `cat_id` int DEFAULT NULL,
  `prod_id` int DEFAULT NULL,
  `cotd_precio` decimal(8,2) DEFAULT NULL,
  `cotd_cant` int DEFAULT NULL,
  `cotd_profit` decimal(8,2) DEFAULT NULL,
  `cotd_total` decimal(8,2) DEFAULT NULL,
  `cotd_tipo` varchar(1) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `fech_modi` datetime DEFAULT NULL,
  `fech_elim` datetime DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`cotd_id`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.td_cotizacion: ~173 rows (aproximadamente)
DELETE FROM `td_cotizacion`;
INSERT INTO `td_cotizacion` (`cotd_id`, `cot_id`, `cat_id`, `prod_id`, `cotd_precio`, `cotd_cant`, `cotd_profit`, `cotd_total`, `cotd_tipo`, `fech_crea`, `fech_modi`, `fech_elim`, `est`) VALUES
	(1, 1, 1, 1, 11.22, 2, 0.00, 22.44, 'D', '2023-08-16 13:05:09', NULL, NULL, 1),
	(2, 24, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 13:16:08', NULL, NULL, 1),
	(3, 25, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-16 19:48:45', NULL, NULL, 1),
	(4, 25, 2, 23, 229.99, 3, 0.00, 689.97, 'D', '2023-08-16 19:49:16', NULL, NULL, 1),
	(5, 26, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 19:51:14', NULL, NULL, 1),
	(6, 27, 1, 1, 9.99, 2, 0.00, 19.98, 'D', '2023-08-16 19:51:50', NULL, NULL, 1),
	(7, 28, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-16 19:54:05', NULL, NULL, 1),
	(8, 29, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-16 19:54:30', NULL, NULL, 1),
	(9, 30, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 19:54:59', NULL, NULL, 1),
	(10, 30, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 19:55:04', NULL, NULL, 1),
	(11, 30, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 20:47:46', NULL, NULL, 1),
	(12, 30, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 20:47:47', NULL, NULL, 1),
	(13, 30, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 20:47:48', NULL, NULL, 1),
	(14, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:36', NULL, NULL, 1),
	(15, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:40', NULL, NULL, 1),
	(16, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:42', NULL, NULL, 1),
	(17, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:42', NULL, NULL, 1),
	(18, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:42', NULL, NULL, 1),
	(19, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(20, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(21, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(22, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(23, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(24, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:43', NULL, NULL, 1),
	(25, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:44', NULL, NULL, 1),
	(26, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:44', NULL, NULL, 1),
	(27, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:44', NULL, NULL, 1),
	(28, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:44', NULL, NULL, 1),
	(29, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:44', NULL, NULL, 1),
	(30, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(31, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(32, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(33, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(34, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(35, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:45', NULL, NULL, 1),
	(36, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:46', NULL, NULL, 1),
	(37, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:46', NULL, NULL, 1),
	(38, 31, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:49:46', NULL, NULL, 1),
	(39, 32, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 20:57:12', NULL, NULL, 1),
	(40, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:48', NULL, NULL, 1),
	(41, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:49', NULL, NULL, 1),
	(42, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:49', NULL, NULL, 1),
	(43, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:50', NULL, NULL, 1),
	(44, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:50', NULL, NULL, 1),
	(45, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:57:50', NULL, NULL, 1),
	(46, 33, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 20:58:09', NULL, NULL, 1),
	(47, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:30', NULL, NULL, 1),
	(48, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:34', NULL, NULL, 1),
	(49, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:34', NULL, NULL, 1),
	(50, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(51, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(52, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(53, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(54, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(55, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:35', NULL, NULL, 1),
	(56, 34, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-16 22:49:36', NULL, NULL, 1),
	(57, 35, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 22:50:59', NULL, NULL, 1),
	(58, 35, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-16 22:51:04', NULL, NULL, 1),
	(59, 36, 5, 14, 139.99, 2, 0.00, 279.98, 'D', '2023-08-16 22:51:47', NULL, NULL, 1),
	(60, 37, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-16 22:52:09', NULL, NULL, 1),
	(61, 38, 2, 23, 229.99, 2, 0.00, 459.98, 'D', '2023-08-16 22:52:33', NULL, NULL, 1),
	(62, 39, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-22 18:12:06', NULL, NULL, 1),
	(63, 39, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-22 18:13:35', NULL, NULL, 1),
	(64, 40, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:14:54', NULL, NULL, 1),
	(65, 41, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:17:14', NULL, NULL, 1),
	(66, 42, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-22 18:18:22', NULL, NULL, 1),
	(67, 1, 1, 1, 11.22, 2, 0.00, 22.44, 'D', '2023-08-22 18:18:53', NULL, NULL, 1),
	(68, 43, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:19:53', NULL, NULL, 1),
	(69, 44, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:20:50', NULL, NULL, 1),
	(70, 44, 4, 9, 89.99, 3, 0.00, 269.97, 'D', '2023-08-22 18:20:55', NULL, NULL, 1),
	(71, 45, 5, 14, 139.99, 2, 0.00, 279.98, 'D', '2023-08-22 18:22:01', NULL, NULL, 1),
	(72, 45, 5, 14, 139.99, 3, 0.00, 419.97, 'D', '2023-08-22 18:22:05', NULL, NULL, 1),
	(73, 47, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-22 18:40:50', NULL, NULL, 1),
	(74, 48, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:42:27', NULL, NULL, 1),
	(75, 49, 5, 19, 189.99, 2, 0.00, 379.98, 'D', '2023-08-22 18:44:39', NULL, NULL, 1),
	(76, 50, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-22 18:55:31', NULL, NULL, 1),
	(77, 51, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-22 18:56:48', NULL, NULL, 1),
	(78, 51, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-08-22 18:57:21', NULL, NULL, 1),
	(79, 52, 5, 7, 69.99, 2, 0.00, 139.98, 'D', '2023-08-22 18:59:09', NULL, '2023-08-22 18:59:12', 0),
	(80, 52, 4, 9, 89.99, 3, 0.00, 269.97, 'D', '2023-08-22 18:59:21', NULL, '2023-08-22 18:59:30', 0),
	(81, 52, 6, 13, 129.99, 3, 0.00, 389.97, 'D', '2023-08-22 18:59:25', NULL, '2023-08-22 18:59:27', 0),
	(82, 52, 5, 14, 139.99, 2, 0.00, 279.98, 'D', '2023-08-22 19:40:00', NULL, '2023-08-22 19:40:03', 0),
	(83, 53, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-23 16:00:49', NULL, '2023-08-23 16:00:52', 0),
	(84, 53, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-23 16:00:57', NULL, NULL, 1),
	(85, 54, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-23 16:10:12', NULL, NULL, 1),
	(86, 55, 5, 7, 69.99, 2, 0.00, 139.98, 'D', '2023-08-23 16:19:09', NULL, NULL, 1),
	(87, 56, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-08-23 16:20:39', NULL, NULL, 1),
	(88, 57, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-23 16:22:08', NULL, NULL, 1),
	(89, 58, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-08-23 16:23:32', NULL, NULL, 1),
	(90, 59, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-23 16:25:57', NULL, NULL, 1),
	(91, 60, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-08-23 16:27:57', NULL, NULL, 1),
	(92, 61, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-28 21:15:31', NULL, NULL, 1),
	(93, 62, 4, 9, 89.99, 3, 100.00, 369.97, 'D', '2023-08-28 21:48:28', NULL, NULL, 1),
	(94, 62, 4, 9, 89.99, 2, 200.00, 379.98, 'D', '2023-08-28 21:48:56', NULL, NULL, 1),
	(95, 62, 4, 9, 89.99, 1, 0.00, 89.99, 'D', '2023-08-28 21:49:28', NULL, NULL, 1),
	(96, 63, 2, 3, 29.99, 2, 100.00, 159.98, 'D', '2023-08-28 21:54:28', NULL, NULL, 1),
	(97, 64, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-08-28 21:55:24', NULL, NULL, 1),
	(98, 65, 2, 3, 29.99, 1, 100.00, 129.99, 'D', '2023-08-28 21:55:57', NULL, NULL, 1),
	(99, 66, 2, 3, 29.99, 1, 0.00, 29.99, 'D', '2023-08-28 22:01:18', NULL, NULL, 1),
	(100, 67, 4, 9, 89.99, 1, 100.00, 189.99, 'D', '2023-08-28 22:04:08', NULL, '2023-08-28 22:04:27', 0),
	(101, 68, 2, 3, 29.99, 2, 50.00, 109.98, 'D', '2023-09-05 10:54:20', NULL, NULL, 1),
	(102, 72, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-05 11:33:11', NULL, NULL, 1),
	(103, 84, 2, 3, 29.99, 2, 100.00, 159.98, 'D', '2023-09-05 12:30:12', NULL, NULL, 1),
	(104, 84, 5, 19, 189.99, 3, 0.00, 569.97, 'D', '2023-09-05 12:31:24', NULL, NULL, 1),
	(105, 84, 2, 3, 29.99, 1, 0.00, 29.99, 'D', '2023-09-05 12:32:35', NULL, NULL, 1),
	(106, 84, 2, 3, 29.99, 3, 0.00, 89.97, 'D', '2023-09-05 12:32:56', NULL, NULL, 1),
	(107, 85, 2, 3, 29.99, 2, 50.00, 109.98, 'D', '2023-09-05 12:40:01', NULL, NULL, 1),
	(108, 86, 1, 1, 9.99, 2, 111.00, 130.98, 'D', '2023-09-05 12:41:32', NULL, NULL, 1),
	(109, 87, 2, 3, 29.99, 2, 100.00, 159.98, 'D', '2023-09-05 12:46:22', NULL, NULL, 1),
	(110, 88, 2, 3, 29.99, 2, 100.00, 159.98, 'D', '2023-09-05 12:51:01', NULL, '2023-09-05 12:51:39', 0),
	(111, 88, 2, 3, 29.99, 3, 0.00, 89.97, 'D', '2023-09-05 12:51:06', NULL, NULL, 1),
	(112, 89, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-05 19:19:08', NULL, NULL, 1),
	(113, 90, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-05 19:19:48', NULL, NULL, 1),
	(114, 90, 4, 9, 89.99, 3, 100.00, 369.97, 'D', '2023-09-05 19:19:55', NULL, '2023-09-05 19:20:10', 0),
	(115, 91, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-06 11:34:23', NULL, NULL, 1),
	(116, 92, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-06 11:40:05', NULL, NULL, 1),
	(117, 93, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-06 11:40:20', NULL, NULL, 1),
	(118, 94, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-06 11:41:08', NULL, NULL, 1),
	(119, 97, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-06 11:57:59', NULL, NULL, 1),
	(120, 98, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-06 12:03:35', NULL, NULL, 1),
	(121, 98, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-06 12:03:44', NULL, NULL, 1),
	(122, 99, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-06 12:07:41', NULL, '2023-09-06 12:07:53', 0),
	(123, 99, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-06 12:08:05', NULL, NULL, 1),
	(124, 100, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-06 12:09:40', NULL, NULL, 1),
	(125, 100, 4, 4, 39.99, 2, 0.00, 79.98, 'A', '2023-09-06 12:09:51', NULL, NULL, 1),
	(126, 100, 4, 4, 39.99, 3, 100.00, 219.97, 'D', '2023-09-06 12:09:59', NULL, NULL, 1),
	(127, 101, 5, 7, 69.99, 2, 0.00, 139.98, 'D', '2023-09-06 12:55:21', NULL, NULL, 1),
	(128, 101, 5, 7, 69.99, 1, 100.00, 169.99, 'D', '2023-09-06 12:55:26', NULL, NULL, 1),
	(129, 101, 4, 4, 39.99, 3, 100.00, 219.97, 'A', '2023-09-06 12:55:45', NULL, NULL, 1),
	(130, 101, 5, 7, 69.99, 1, 0.00, 69.99, 'D', '2023-09-06 12:56:01', NULL, NULL, 1),
	(131, 103, 2, 11, 109.99, 2, 0.00, 219.98, 'A', '2023-09-06 12:59:11', NULL, NULL, 1),
	(132, 127, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-07 19:08:19', NULL, NULL, 1),
	(133, 128, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-07 19:09:19', NULL, NULL, 1),
	(134, 129, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-07 19:10:30', NULL, NULL, 1),
	(135, 129, 5, 14, 139.99, 3, 200.00, 619.97, 'D', '2023-09-07 19:10:47', NULL, NULL, 1),
	(136, 130, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-08 10:55:14', NULL, NULL, 1),
	(137, 131, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 11:03:20', NULL, NULL, 1),
	(138, 132, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 11:04:00', NULL, NULL, 1),
	(139, 133, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-08 11:06:03', NULL, NULL, 1),
	(140, 134, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 11:08:11', NULL, NULL, 1),
	(141, 135, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-08 11:09:48', NULL, NULL, 1),
	(142, 136, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-08 11:19:58', NULL, NULL, 1),
	(143, 136, 6, 8, 79.99, 2, 0.00, 159.98, 'A', '2023-09-08 11:20:03', NULL, NULL, 1),
	(144, 138, 2, 16, 159.99, 2, 0.00, 319.98, 'D', '2023-09-08 11:47:06', NULL, NULL, 1),
	(145, 139, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 12:13:22', NULL, NULL, 1),
	(146, 139, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 12:13:25', NULL, NULL, 1),
	(147, 139, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-08 12:13:30', NULL, NULL, 1),
	(148, 139, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-08 12:13:33', NULL, NULL, 1),
	(149, 139, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-08 12:13:34', NULL, NULL, 1),
	(150, 140, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-08 12:14:34', NULL, NULL, 1),
	(151, 141, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-08 12:15:01', NULL, NULL, 1),
	(152, 142, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-08 12:15:35', NULL, NULL, 1),
	(153, 142, 4, 4, 39.99, 2, 0.00, 79.98, 'A', '2023-09-08 12:15:40', NULL, NULL, 1),
	(154, 143, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-09-08 12:16:01', NULL, NULL, 1),
	(155, 143, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-08 12:16:06', NULL, NULL, 1),
	(156, 144, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-11 12:31:34', NULL, NULL, 1),
	(157, 144, 6, 8, 79.99, 2, 0.00, 159.98, 'A', '2023-09-11 12:31:39', NULL, NULL, 1),
	(158, 145, 5, 14, 139.99, 2, 0.00, 279.98, 'D', '2023-09-11 12:43:05', NULL, NULL, 1),
	(159, 145, 4, 4, 39.99, 2, 0.00, 79.98, 'A', '2023-09-11 12:43:10', NULL, NULL, 1),
	(160, 146, 5, 7, 69.99, 2, 0.00, 139.98, 'D', '2023-09-11 12:43:53', NULL, NULL, 1),
	(161, 146, 4, 4, 39.99, 2, 0.00, 79.98, 'A', '2023-09-11 12:43:58', NULL, NULL, 1),
	(162, 147, 2, 11, 109.99, 2, 0.00, 219.98, 'A', '2023-09-11 13:00:13', NULL, NULL, 1),
	(163, 148, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-11 13:01:45', NULL, NULL, 1),
	(164, 148, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:01:52', NULL, '2023-09-11 13:01:59', 0),
	(165, 148, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:02:12', NULL, NULL, 1),
	(166, 148, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:02:14', NULL, '2023-09-11 13:02:33', 0),
	(167, 148, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:02:15', NULL, NULL, 1),
	(168, 149, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-11 13:06:09', NULL, NULL, 1),
	(169, 149, 2, 11, 109.99, 2, 0.00, 219.98, 'A', '2023-09-11 13:06:14', NULL, NULL, 1),
	(170, 149, 2, 11, 109.99, 2, 0.00, 219.98, 'A', '2023-09-11 13:06:15', NULL, NULL, 1),
	(171, 150, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-11 13:06:49', NULL, NULL, 1),
	(172, 150, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:06:54', NULL, NULL, 1),
	(173, 150, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:07:00', NULL, NULL, 1),
	(174, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-11 13:10:44', NULL, NULL, 1),
	(175, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:10:49', NULL, '2023-09-11 13:11:07', 0),
	(176, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:10:50', NULL, '2023-09-11 13:11:00', 0),
	(177, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:11:14', NULL, '2023-09-11 13:11:28', 0),
	(178, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:11:14', NULL, '2023-09-11 13:11:26', 0),
	(179, 151, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-11 13:11:15', NULL, '2023-09-11 13:11:24', 0),
	(180, 154, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-11 16:13:12', NULL, NULL, 1),
	(181, 154, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-11 17:10:32', NULL, NULL, 1),
	(182, 155, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-11 17:44:51', NULL, NULL, 1),
	(183, 155, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-11 17:44:53', NULL, NULL, 1),
	(184, 155, 4, 9, 89.99, 2, 0.00, 179.98, 'A', '2023-09-11 17:44:58', NULL, NULL, 1),
	(185, 155, 4, 9, 89.99, 2, 0.00, 179.98, 'A', '2023-09-11 17:44:59', NULL, NULL, 1),
	(186, 156, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-11 17:48:01', NULL, NULL, 1),
	(187, 157, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-09-11 18:12:35', NULL, NULL, 1),
	(188, 158, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-11 18:15:59', NULL, NULL, 1),
	(189, 159, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-13 12:16:30', NULL, NULL, 1),
	(190, 160, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-13 12:18:17', NULL, NULL, 1),
	(191, 161, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-13 12:19:16', NULL, NULL, 1),
	(192, 161, 5, 7, 69.99, 3, 0.00, 209.97, 'D', '2023-09-13 18:08:03', NULL, NULL, 1),
	(193, 161, 4, 15, 149.99, 2, 0.00, 299.98, 'D', '2023-09-13 18:08:08', NULL, NULL, 1),
	(194, 161, 6, 20, 199.99, 1, 0.00, 199.99, 'D', '2023-09-13 18:08:14', NULL, NULL, 1),
	(195, 162, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-14 13:53:51', NULL, NULL, 1),
	(196, 162, 2, 3, 29.99, 3, 0.00, 89.97, 'D', '2023-09-14 13:57:35', NULL, NULL, 1),
	(197, 162, 2, 3, 29.99, 3, 0.00, 89.97, 'D', '2023-09-14 13:57:37', NULL, NULL, 1),
	(198, 162, 2, 3, 29.99, 3, 0.00, 89.97, 'D', '2023-09-14 13:57:39', NULL, NULL, 1),
	(199, 162, 4, 9, 89.99, 2, 0.00, 179.98, 'A', '2023-09-14 15:40:10', NULL, NULL, 1),
	(200, 163, 4, 4, 39.99, 2, 0.00, 79.98, 'D', '2023-09-14 15:44:44', NULL, NULL, 1),
	(201, 163, 4, 4, 39.99, 2, 0.00, 79.98, 'A', '2023-09-14 15:44:51', NULL, NULL, 1),
	(202, 164, 5, 14, 139.99, 2, 0.00, 279.98, 'D', '2023-09-14 15:47:54', NULL, NULL, 1),
	(203, 164, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-14 15:47:59', NULL, NULL, 1),
	(204, 165, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-15 11:19:15', NULL, NULL, 1),
	(205, 165, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-15 11:19:20', NULL, NULL, 1),
	(206, 166, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-15 11:20:35', NULL, NULL, 1),
	(207, 167, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-15 11:24:07', NULL, NULL, 1),
	(208, 168, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-15 12:30:52', NULL, NULL, 1),
	(209, 169, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-15 12:44:10', NULL, NULL, 1),
	(210, 169, 4, 9, 89.99, 2, 0.00, 179.98, 'A', '2023-09-15 12:44:18', NULL, NULL, 1),
	(211, 170, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-19 12:26:54', NULL, '2023-09-19 12:26:57', 0),
	(212, 170, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-19 12:27:09', NULL, NULL, 1),
	(213, 171, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-24 18:20:54', NULL, NULL, 1),
	(214, 171, 5, 14, 139.99, 3, 233.00, 652.97, 'D', '2023-09-24 18:21:00', NULL, NULL, 1),
	(215, 171, 5, 19, 189.99, 2, 0.00, 379.98, 'A', '2023-09-24 18:21:13', NULL, NULL, 1),
	(216, 171, 5, 19, 189.99, 2, 0.00, 379.98, 'A', '2023-09-24 18:21:14', NULL, NULL, 1),
	(217, 171, 5, 19, 189.99, 2, 0.00, 379.98, 'A', '2023-09-24 18:21:15', NULL, NULL, 1),
	(218, 173, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-24 18:24:04', NULL, NULL, 1),
	(219, 173, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-24 18:24:05', NULL, NULL, 1),
	(220, 173, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-24 18:24:06', NULL, NULL, 1),
	(221, 173, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-24 18:24:06', NULL, NULL, 1),
	(222, 173, 2, 11, 109.99, 2, 0.00, 219.98, 'D', '2023-09-24 18:24:07', NULL, NULL, 1),
	(223, 173, 4, 4, 39.99, 3, 0.00, 119.97, 'A', '2023-09-24 18:24:11', NULL, NULL, 1),
	(224, 173, 4, 4, 39.99, 3, 0.00, 119.97, 'A', '2023-09-24 18:24:12', NULL, NULL, 1),
	(225, 173, 4, 4, 39.99, 3, 0.00, 119.97, 'A', '2023-09-24 18:24:13', NULL, NULL, 1),
	(226, 174, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 20:25:45', NULL, NULL, 1),
	(227, 174, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 20:25:47', NULL, NULL, 1),
	(228, 174, 4, 9, 89.99, 2, 500.00, 679.98, 'D', '2023-09-29 20:25:49', NULL, NULL, 1),
	(229, 174, 2, 3, 29.99, 2, 0.00, 59.98, 'A', '2023-09-29 20:26:02', NULL, NULL, 1),
	(230, 175, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 20:40:55', NULL, NULL, 1),
	(231, 175, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 20:40:58', NULL, NULL, 1),
	(232, 175, 5, 7, 69.99, 2, 0.00, 139.98, 'A', '2023-09-29 20:41:03', NULL, NULL, 1),
	(233, 177, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 21:51:09', NULL, NULL, 1),
	(234, 178, 2, 3, 29.99, 2, 0.00, 59.98, 'D', '2023-09-29 21:53:30', NULL, NULL, 1),
	(235, 180, 4, 9, 89.99, 2, 0.00, 179.98, 'D', '2023-09-29 22:09:35', NULL, NULL, 1);

-- Volcando estructura para tabla cotizador.tm_cargo
CREATE TABLE IF NOT EXISTS `tm_cargo` (
  `car_id` int NOT NULL AUTO_INCREMENT,
  `car_nom` varchar(50) NOT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`car_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_cargo: ~15 rows (aproximadamente)
DELETE FROM `tm_cargo`;
INSERT INTO `tm_cargo` (`car_id`, `car_nom`, `est`) VALUES
	(1, 'Gerente', 1),
	(2, 'Subgerente', 1),
	(3, 'Jefe de departamento', 1),
	(4, 'Coordinador de proyecto', 1),
	(5, 'Analista de sistemas', 1),
	(6, 'Programador', 1),
	(7, 'Diseñador gráfico', 1),
	(8, 'Asistente administrativo', 1),
	(9, 'Contador', 1),
	(10, 'Auditor', 1),
	(11, 'Ejecutivo de ventas', 1),
	(12, 'Representante de servicio al cliente', 1),
	(13, 'Técnico de soporte', 1),
	(14, 'Ingeniero de calidad', 1),
	(15, 'Inspector de calidad', 1);

-- Volcando estructura para tabla cotizador.tm_categoria
CREATE TABLE IF NOT EXISTS `tm_categoria` (
  `cat_id` int NOT NULL AUTO_INCREMENT,
  `cat_nom` varchar(255) CHARACTER SET utf16 COLLATE utf16_spanish_ci DEFAULT NULL,
  `cat_descrip` varchar(255) CHARACTER SET utf16 COLLATE utf16_spanish_ci DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`cat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_categoria: ~18 rows (aproximadamente)
DELETE FROM `tm_categoria`;
INSERT INTO `tm_categoria` (`cat_id`, `cat_nom`, `cat_descrip`, `est`) VALUES
	(1, 'Categoría 1', 'Descripción de la Categoría 1', 1),
	(2, 'Categoría 2', 'Descripción de la Categoría 2', 1),
	(3, '2222', '2222', 0),
	(4, 'Categoría 4', 'Descripción de la Categoría 4', 1),
	(5, 'Categoría 5', 'Descripción de la Categoría 5', 1),
	(6, 'Categoría 6', 'Descripción de la Categoría 6', 1),
	(7, 'Categoría 7', 'Descripción de la Categoría 7', 1),
	(8, 'test', 'test', 0),
	(9, 'test nombre', 'test descripcion', 0),
	(10, 'test', 'test', 0),
	(11, 'test1', 'test2', 0),
	(12, 'test', 'test', 0),
	(13, 'test', 'test', 0),
	(14, 'test', 'test', 0),
	(15, 'test', 'test', 0),
	(16, 'test', 'test', 0),
	(17, 'test', 'test', 0),
	(18, 'test', 'test', 0),
	(19, 'categoria8', 'test', 1);

-- Volcando estructura para tabla cotizador.tm_cliente
CREATE TABLE IF NOT EXISTS `tm_cliente` (
  `cli_id` int NOT NULL AUTO_INCREMENT,
  `cli_nom` varchar(255) DEFAULT NULL,
  `cli_ruc` varchar(11) DEFAULT NULL,
  `cli_telf` varchar(20) DEFAULT NULL,
  `cli_email` varchar(255) DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`cli_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_cliente: ~26 rows (aproximadamente)
DELETE FROM `tm_cliente`;
INSERT INTO `tm_cliente` (`cli_id`, `cli_nom`, `cli_ruc`, `cli_telf`, `cli_email`, `est`) VALUES
	(1, 'Google Inc.', '12345678901', '12345678', 'cliente1@ejemplo.com', 1),
	(2, 'Microsoft Corporation', '23456789012', '23456789', 'cliente2@ejemplo.com', 1),
	(3, 'Apple Inc.', '34567890123', '34567890', 'cliente3@ejemplo.com', 1),
	(4, 'Amazon.com, Inc.', '45678901234', '45678901', 'cliente4@ejemplo.com', 1),
	(5, 'Facebook, Inc.', '56789012345', '56789012', 'cliente5@ejemplo.com', 1),
	(6, 'Tesla, Inc.', '67890123456', '67890123', 'cliente6@ejemplo.com', 1),
	(7, 'Walmart Inc.', '78901234567', '78901234', 'cliente7@ejemplo.com', 1),
	(8, 'Berkshire Hathaway Inc.', '89012345678', '89012345', 'cliente8@ejemplo.com', 1),
	(9, 'Johnson & Johnson', '90123456789', '90123456', 'cliente9@ejemplo.com', 1),
	(10, 'Procter & Gamble Co.', '01234567890', '01234567', 'cliente10@ejemplo.com', 1),
	(11, 'Google Inc.', '12345678901', '12345678', 'cliente11@ejemplo.com', 1),
	(12, 'Microsoft Corporation', '23456789012', '23456789', 'cliente12@ejemplo.com', 1),
	(13, 'Apple Inc.', '34567890123', '34567890', 'cliente13@ejemplo.com', 1),
	(14, 'Amazon.com, Inc.', '45678901234', '45678901', 'cliente14@ejemplo.com', 1),
	(15, 'Facebook, Inc.', '56789012345', '56789012', 'cliente15@ejemplo.com', 1),
	(16, 'Tesla, Inc.', '67890123456', '67890123', 'cliente16@ejemplo.com', 1),
	(17, 'Walmart Inc.', '78901234567', '78901234', 'cliente17@ejemplo.com', 1),
	(18, 'Berkshire Hathaway Inc.', '89012345678', '89012345', 'cliente18@ejemplo.com', 1),
	(19, 'Johnson & Johnson', '90123456789', '90123456', 'cliente19@ejemplo.com', 1),
	(20, 'Procter & Gamble Co.', '01234567890', '01234567', 'cliente20@ejemplo.com', 1),
	(21, 'Google Inc.', '12345678901', '12345678', 'cliente21@ejemplo.com', 1),
	(22, 'Microsoft Corporation', '23456789012', '23456789', 'cliente22@ejemplo.com', 1),
	(23, 'Apple Inc.', '34567890123', '34567890', 'cliente23@ejemplo.com', 1),
	(24, 'Amazon.com, Inc.', '45678901234', '45678901', 'cliente24@ejemplo.com', 1),
	(25, 'Facebook, Inc.', '56789012345', '56789012', 'cliente25@ejemplo.com', 1),
	(26, 'Tesla, Inc.', '67890123456', '67890123', 'cliente26@ejemplo.com', 1),
	(27, 'test4', '1234', '1234', 'davis_anderson_874@hotmail.com', 0);

-- Volcando estructura para tabla cotizador.tm_contacto
CREATE TABLE IF NOT EXISTS `tm_contacto` (
  `con_id` int NOT NULL AUTO_INCREMENT,
  `cli_id` int NOT NULL,
  `car_id` int NOT NULL,
  `con_nom` varchar(255) NOT NULL,
  `con_email` varchar(255) NOT NULL,
  `con_telf` varchar(20) NOT NULL,
  `con_pass` varchar(20) NOT NULL DEFAULT '',
  `est` int NOT NULL,
  PRIMARY KEY (`con_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_contacto: ~49 rows (aproximadamente)
DELETE FROM `tm_contacto`;
INSERT INTO `tm_contacto` (`con_id`, `cli_id`, `car_id`, `con_nom`, `con_email`, `con_telf`, `con_pass`, `est`) VALUES
	(1, 5, 9, 'Juan Perez', 'juanperez@example.com', '+51981233834', '0APOQN', 1),
	(2, 4, 2, 'Ana Garcia', 'anagarcia@example.com', '+51981233834', '5J4GG7', 1),
	(3, 2, 7, 'Luis Hernandez', 'luish@example.com', '+51981233834', 'GM9DY4', 1),
	(4, 10, 1, 'Maria Rodriguez', 'mariar@example.com', '+51981233834', '5GBETC', 1),
	(5, 3, 5, 'Pedro Gomez', 'pedrogomez@example.com', '+51981233834', '40DS1N', 1),
	(6, 1, 6, 'Carla Gonzalez', 'carlagonzalez@example.com', '+51981233834', 'M0DU8L', 1),
	(7, 9, 11, 'Mario Castro', 'mariocastro@example.com', '+51981233834', 'FK5Q7R', 1),
	(8, 8, 8, 'Laura Vargas', 'lauravargas@example.com', '+51981233834', '66AF1C', 1),
	(9, 5, 3, 'Ricardo Ramirez', 'ricardor@example.com', '+51981233834', '754YBK', 1),
	(10, 7, 4, 'Sofia Garcia', 'sofiagarcia@example.com', '+51981233834', '56IHR6', 1),
	(11, 11, 2, 'Carlos Valdez', 'carlosv@example.com', '+51981233834', '961SXM', 1),
	(12, 6, 10, 'Ana Maria Flores', 'anamariaf@example.com', '+51981233834', '2B1HRS', 1),
	(13, 2, 15, 'Fernando Morales', 'fernandom@example.com', '+51981233834', 'DI0C9J', 1),
	(14, 8, 8, 'Natalia Hernandez', 'nataliah@example.com', '+51981233834', 'HF1HJ2', 1),
	(15, 1, 7, 'Luisa Perez', 'luisaperez@example.com', '+51981233834', 'N92NOV', 1),
	(16, 4, 4, 'Jorge Chavez', 'jorgechavez@example.com', '+51981233834', '63P4VA', 1),
	(17, 3, 12, 'Luz Marin', 'luzmarin@example.com', '+51981233834', 'OK1U02', 1),
	(18, 9, 14, 'Felix Torres', 'felixtorres@example.com', '+51981233834', 'IKIYIL', 1),
	(19, 6, 7, 'Carolina Vega', 'carolinavega@example.com', '+51981233834', 'KD82A8', 1),
	(20, 10, 1, 'Gabriel Espinoza', 'gabe@example.com', '+51981233834', 'P6600F', 1),
	(21, 5, 2, 'Marcela Castro', 'marcelac@example.com', '+51981233834', 'MP52AO', 1),
	(22, 7, 8, 'Daniel Ramirez', 'danielr@example.com', '+51981233834', '2O9MZ2', 1),
	(23, 2, 6, 'Valeria Flores', 'valeriaf@example.com', '+51981233834', 'BN55G6', 1),
	(24, 8, 13, 'Lucia Herrera', 'luciah@example.com', '+51981233834', 'DCLMTD', 1),
	(25, 1, 5, 'Miguel Fernandez', 'miguelf@example.com', '+51981233834', 'EE3EOV', 1),
	(26, 1, 4, 'Anderson Bastidas', 'davisanderson87@gmail.com', '+51981233834', 'FOOLQP', 1),
	(27, 2, 10, 'María Rodríguez', 'maria.rodriguez@example.com', '+51981233834', '9DDQMO', 1),
	(28, 3, 8, 'Pedro López', 'pedro.lopez@example.com', '+51981233834', '6HF1CL', 1),
	(29, 4, 12, 'Ana García', 'ana.garcia@example.com', '+51981233834', 'OKPC5U', 1),
	(30, 5, 9, 'Carlos Ramírez', 'carlos.ramirez@example.com', '+51981233834', 'A8DD1P', 1),
	(31, 6, 7, 'Lucía Torres', 'lucia.torres@example.com', '+51981233834', 'FL8LP8', 1),
	(32, 7, 6, 'Juanita Fernández', 'juanita.fernandez@example.com', '+51981233834', '640970', 1),
	(33, 8, 5, 'Pedro González', 'pedro.gonzalez@example.com', '+51981233834', 'H3GUFW', 1),
	(34, 9, 3, 'Ana María García', 'anamaria.garcia@example.com', '+51981233834', 'DD1VKP', 1),
	(35, 10, 11, 'Carlos Eduardo Ramírez', 'carloseduardo.ramirez@example.com', '+51981233834', '39BZOC', 1),
	(36, 11, 14, 'Marcela Torres', 'marcela.torres@example.com', '+51981233834', '017VV7', 1),
	(37, 12, 1, 'José Antonio Hernández', 'joseantonio.hernandez@example.com', '+51981233834', '4CMP19', 1),
	(38, 13, 13, 'Sofía González', 'sofia.gonzalez@example.com', '+51981233834', '14HPIF', 1),
	(39, 14, 15, 'Martín López', 'martin.lopez@example.com', '+51981233834', 'AOEIOE', 1),
	(40, 15, 2, 'Fabiola Rodríguez', 'fabiola.rodriguez@example.com', '+51981233834', 'BC0NPL', 1),
	(41, 16, 6, 'Miguel Ángel Hernández', 'miguelangel.hernandez@example.com', '+51981233834', 'MCLRNI', 1),
	(42, 17, 3, 'Paula Sánchez', 'paula.sanchez@example.com', '+51981233834', '6P27W3', 1),
	(43, 18, 9, 'Mario Jiménez', 'mario.jimenez@example.com', '+51981233834', 'G7EEUJ', 1),
	(44, 19, 11, 'Laura Gutiérrez', 'laura.gutierrez@example.com', '+51981233834', 'LMK9NP', 1),
	(45, 20, 5, 'Andrés Castro', 'andres.castro@example.com', '+51981233834', '77I5SA', 1),
	(46, 21, 2, 'Silvia Soto', 'silvia.soto@example.com', '+51981233834', 'L47072', 1),
	(47, 22, 14, 'Javier González', 'javier.gonzalez@example.com', '+51981233834', 'EP8YHH', 1),
	(48, 1, 1, 'test', 'davis_anderson_87@hotmail.com', '+51981233834', 'M5BQ88', 0),
	(49, 1, 3, 'test2', 'davis_anderson_87@hotmail.com', '+51981233834', '51HV3L', 0);

-- Volcando estructura para tabla cotizador.tm_cotizacion
CREATE TABLE IF NOT EXISTS `tm_cotizacion` (
  `cot_id` int NOT NULL AUTO_INCREMENT,
  `usu_id` int DEFAULT NULL,
  `emp_id` int DEFAULT '1',
  `cli_id` int DEFAULT NULL,
  `con_id` int DEFAULT NULL,
  `cli_ruc` varchar(50) DEFAULT NULL,
  `con_telf` varchar(50) DEFAULT NULL,
  `con_email` varchar(50) DEFAULT NULL,
  `cot_descrip` varchar(500) DEFAULT NULL,
  `emp_porcen` int DEFAULT '0',
  `cot_subtotal` decimal(8,2) DEFAULT '0.00',
  `cot_profit` decimal(8,2) DEFAULT '0.00',
  `cot_total` decimal(8,2) DEFAULT '0.00',
  `cot_saludo` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cot_adicional` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cot_contrato` varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cot_tipo` varchar(50) DEFAULT 'Borrador',
  `fech_envio` datetime DEFAULT NULL,
  `fech_visto` datetime DEFAULT NULL,
  `fech_respuesta` datetime DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `est` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`cot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_cotizacion: ~169 rows (aproximadamente)
DELETE FROM `tm_cotizacion`;
INSERT INTO `tm_cotizacion` (`cot_id`, `usu_id`, `emp_id`, `cli_id`, `con_id`, `cli_ruc`, `con_telf`, `con_email`, `cot_descrip`, `emp_porcen`, `cot_subtotal`, `cot_profit`, `cot_total`, `cot_saludo`, `cot_adicional`, `cot_contrato`, `cot_tipo`, `fech_envio`, `fech_visto`, `fech_respuesta`, `fech_crea`, `est`) VALUES
	(1, 1, 1, 1, 1, '123', '1234', 'email', 'descripcion', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-14 15:43:09', 1),
	(2, 1, 1, 1, 1, '123', '1234', 'email', 'descripcion', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-14 15:48:44', 1),
	(3, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', 'testas', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-14 17:11:20', 1),
	(4, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', 'tasadasd', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-14 17:13:15', 1),
	(5, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', 'asdasd', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 12:57:08', 1),
	(6, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '123', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:00:32', 2),
	(7, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', 'asdasd', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:01:05', 2),
	(8, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:04:40', 2),
	(9, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:05:52', 2),
	(10, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:06:28', 2),
	(11, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:07:01', 2),
	(12, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:12:04', 2),
	(13, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:12:35', 2),
	(14, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:12:49', 2),
	(15, 1, 1, NULL, 1, '15', '12345678901', '555-5432', 'luisaperez@example.com', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:15:02', 2),
	(16, 1, 1, NULL, 1, '15', '12345678901', '555-5432', 'luisaperez@example.com', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:15:09', 2),
	(17, 1, 1, 3, 5, '34567890123', '555-8765', 'pedrogomez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:21:45', 2),
	(18, 1, 1, 3, 5, '34567890123', '555-8765', 'pedrogomez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:21:50', 2),
	(19, 1, 1, 3, 5, '34567890123', '555-8765', 'pedrogomez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-15 13:21:54', 2),
	(20, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 12:30:58', 2),
	(21, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', 'test', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 13:13:04', 2),
	(22, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 13:13:56', 2),
	(23, 1, 1, 3, 5, '34567890123', '555-8765', 'pedrogomez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 13:15:18', 2),
	(24, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 13:16:02', 2),
	(25, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:48:37', 2),
	(26, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:51:10', 2),
	(27, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:51:44', 2),
	(28, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:53:15', 2),
	(29, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:54:26', 2),
	(30, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 19:54:55', 2),
	(31, 1, 1, 3, 17, '34567890123', '555-7654', 'luzmarin@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 20:49:29', 2),
	(32, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 20:57:04', 2),
	(33, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 20:57:45', 2),
	(34, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 22:49:26', 2),
	(35, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 22:50:53', 2),
	(36, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 22:51:43', 2),
	(37, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 22:52:06', 2),
	(38, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-16 22:52:30', 2),
	(39, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:11:56', 2),
	(40, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:14:49', 2),
	(41, 1, 1, 3, 17, '34567890123', '555-7654', 'luzmarin@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:17:06', 2),
	(42, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:18:19', 2),
	(43, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:19:49', 2),
	(44, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:20:46', 2),
	(45, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:21:58', 2),
	(46, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:37:52', 2),
	(47, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:39:46', 2),
	(48, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:42:20', 2),
	(49, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:44:33', 2),
	(50, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:55:26', 2),
	(51, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:56:44', 2),
	(52, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-22 18:59:05', 2),
	(53, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:00:45', 2),
	(54, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:10:07', 2),
	(55, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:19:06', 2),
	(56, 1, 1, 1, 25, '12345678901', '555-6543', 'miguelf@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:20:36', 2),
	(57, 1, 1, 3, 17, '34567890123', '555-7654', 'luzmarin@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:22:04', 2),
	(58, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:23:29', 2),
	(59, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:25:54', 2),
	(60, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-23 16:27:53', 2),
	(61, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 21:15:26', 2),
	(62, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 21:48:23', 2),
	(63, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 21:54:23', 2),
	(64, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 21:55:18', 2),
	(65, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 21:55:53', 2),
	(66, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 22:00:59', 2),
	(67, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-08-28 22:04:03', 2),
	(68, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 10:54:13', 2),
	(69, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:31:24', 2),
	(70, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:31:52', 2),
	(71, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:32:34', 2),
	(72, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:33:04', 2),
	(73, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:34:10', 2),
	(74, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:34:27', 2),
	(75, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:34:51', 2),
	(76, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:38:22', 2),
	(77, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:39:02', 2),
	(78, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:39:07', 2),
	(79, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:40:26', 2),
	(80, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:43:36', 2),
	(81, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:45:34', 2),
	(82, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:46:19', 2),
	(83, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 11:46:35', 2),
	(84, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 749.91, 0.00, 749.91, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 12:30:07', 2),
	(85, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 12:39:57', 2),
	(86, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 19.98, 0.00, 19.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 12:41:28', 2),
	(87, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 159.98, 100.00, 259.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 12:46:18', 2),
	(88, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 89.97, 0.00, 89.97, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 12:50:57', 2),
	(89, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 19:19:03', 2),
	(90, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-05 19:19:44', 2),
	(91, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:34:18', 2),
	(92, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:40:02', 2),
	(93, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:40:17', 2),
	(94, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:41:04', 2),
	(95, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:53:57', 2),
	(96, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:55:35', 2),
	(97, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 11:57:55', 2),
	(98, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 139.96, 0.00, 139.96, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:03:30', 2),
	(99, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:07:32', 2),
	(100, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 379.93, 100.00, 479.93, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:09:36', 2),
	(101, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 379.96, 100.00, 479.96, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:55:14', 2),
	(102, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:58:22', 2),
	(103, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-06 12:59:05', 2),
	(104, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:39:06', 2),
	(105, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:39:10', 2),
	(106, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:39:18', 2),
	(107, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:39:19', 2),
	(108, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:47:17', 2),
	(109, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:49:47', 2),
	(110, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:50:22', 2),
	(111, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:52:02', 2),
	(112, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:52:52', 2),
	(113, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:53:19', 2),
	(114, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 11:53:43', 2),
	(115, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:17:22', 2),
	(116, 1, 1, 2, 27, '23456789012', '555-5678', 'maria.rodriguez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:18:47', 2),
	(117, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:21:16', 2),
	(118, 1, 1, 1, 25, '12345678901', '555-6543', 'miguelf@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:22:13', 2),
	(119, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:22:39', 2),
	(120, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:56:54', 2),
	(121, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 12:57:34', 2),
	(122, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 13:12:04', 2),
	(123, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 13:13:51', 2),
	(124, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 13:16:19', 2),
	(125, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 13:17:46', 2),
	(126, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 18:55:53', 2),
	(127, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 219.98, 0.00, 219.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 19:08:15', 2),
	(128, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 19:09:15', 2),
	(129, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 839.95, 200.00, 1039.95, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-07 19:10:28', 2),
	(130, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 10:55:06', 2),
	(131, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 79.98, 0.00, 79.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:03:17', 2),
	(132, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 79.98, 0.00, 79.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:03:57', 2),
	(133, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:06:00', 2),
	(134, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 79.98, 0.00, 79.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:08:08', 2),
	(135, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:09:45', 2),
	(136, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:19:54', 2),
	(137, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:28:54', 2),
	(138, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 319.98, 0.00, 319.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 11:47:00', 2),
	(139, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 159.96, 0.00, 159.96, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 12:13:18', 2),
	(140, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 12:14:30', 2),
	(141, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 12:14:58', 2),
	(142, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 79.98, 0.00, 79.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 12:15:32', 2),
	(143, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 299.98, 0.00, 299.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-08 12:15:58', 2),
	(144, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 12:31:25', 2),
	(145, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 279.98, 0.00, 279.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 12:43:02', 2),
	(146, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 139.98, 0.00, 139.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 12:43:49', 2),
	(147, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 13:00:01', 2),
	(148, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 13:01:41', 2),
	(149, 1, 1, 3, 5, '34567890123', '555-8765', 'pedrogomez@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 13:06:06', 2),
	(150, 1, 1, 2, 13, '23456789012', '555-6543', 'fernandom@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 13:06:47', 2),
	(151, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 13:10:41', 2),
	(152, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 16:07:02', 2),
	(153, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 16:08:40', 2),
	(154, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 16:12:56', 2),
	(155, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 439.96, 0.00, 439.96, 'ad', 'as', 'as', 'Enviado', '2023-09-11 17:47:44', NULL, NULL, '2023-09-11 17:44:48', 1),
	(156, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 179.98, 0.00, 179.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 17:47:59', 2),
	(157, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 299.98, 0.00, 299.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-11 18:12:31', 2),
	(158, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 179.98, 0.00, 179.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-11 18:16:51', NULL, NULL, '2023-09-11 18:15:56', 1),
	(159, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 79.98, 0.00, 79.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-13 12:17:07', NULL, NULL, '2023-09-13 12:16:26', 1),
	(160, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 59.98, 0.00, 59.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-13 12:18:22', NULL, NULL, '2023-09-13 12:18:14', 1),
	(161, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 769.92, 0.00, 769.92, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-13 18:09:44', NULL, NULL, '2023-09-13 12:19:13', 1),
	(162, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 329.89, 0.00, 329.89, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:asdadasdasdasdadas', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:asdadasdasdasdadas', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-14 15:40:26', NULL, NULL, '2023-09-14 13:53:48', 1),
	(163, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 79.98, 0.00, 79.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-14 15:44:41', 2),
	(164, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 279.98, 0.00, 279.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-14 15:48:14', NULL, NULL, '2023-09-14 15:47:51', 1),
	(165, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 59.98, 0.00, 59.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-15 11:19:10', 2),
	(166, 1, 1, 1, 6, '12345678901', '555-3456', 'carlagonzalez@example.com', '', 0, 59.98, 0.00, 59.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-15 11:20:43', NULL, NULL, '2023-09-15 11:20:31', 1),
	(167, 1, 1, 1, 26, '12345678901', '555-1234', 'davis_anderson_87@hotmail.com', '', 0, 219.98, 0.00, 219.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Aceptado', '2023-09-15 11:24:19', '2023-09-15 12:40:22', '2023-09-18 23:16:06', '2023-09-15 11:24:03', 1),
	(168, 1, 1, 1, 26, '12345678901', '555-1234', 'davis_anderson_87@hotmail.com', '', 0, 59.98, 0.00, 59.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Aceptado', '2023-09-15 12:31:27', '2023-09-15 12:33:57', '2023-09-18 23:14:11', '2023-09-15 12:30:48', 1),
	(169, 1, 1, 1, 26, '12345678901', '555-1234', 'davisanderson87@gmail.com', '', 0, 59.98, 0.00, 59.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Rechazado', '2023-09-15 12:44:27', '2023-09-15 12:44:48', '2023-09-18 22:31:25', '2023-09-15 12:44:07', 1),
	(170, 1, 1, 2, 3, '23456789012', '555-9876', 'luish@example.com', '', 0, 219.98, 0.00, 219.98, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-19 12:26:50', 2),
	(171, 1, 1, 1, 15, '12345678901', '555-5432', 'luisaperez@example.com', '', 0, 832.95, 233.00, 1065.95, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-24 18:22:11', NULL, NULL, '2023-09-24 18:20:51', 1),
	(172, 1, 1, 1, 26, '12345678901', '555-1234', 'davisanderson87@gmail.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-24 18:22:02', 2),
	(173, 1, 1, 1, 26, '12345678901', '555-1234', 'davisanderson87@gmail.com', '', 0, 1099.90, 0.00, 1099.90, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Visto', '2023-09-24 18:24:19', '2023-09-24 18:25:06', NULL, '2023-09-24 18:24:01', 1),
	(174, 1, 1, 1, 26, '12345678901', '555-1234', 'davisanderson87@gmail.com', '', 0, 1039.94, 500.00, 1539.94, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-29 20:26:11', NULL, NULL, '2023-09-29 20:25:41', 1),
	(175, 1, 1, 1, 6, '12345678901', '+51981233834', 'carlagonzalez@example.com', '', 0, 359.96, 0.00, 359.96, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-29 21:48:07', NULL, NULL, '2023-09-29 20:40:51', 1),
	(176, 1, 1, 1, 26, '12345678901', '+51981233834', 'davisanderson87@gmail.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-29 20:42:08', 2),
	(177, 1, 1, 1, 26, '12345678901', '+51981233834', 'davisanderson87@gmail.com', '', 0, 179.98, 0.00, 179.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-29 21:51:21', NULL, NULL, '2023-09-29 21:51:07', 1),
	(178, 1, 1, 1, 26, '12345678901', '+51981233834', 'davisanderson87@gmail.com', '', 0, 59.98, 0.00, 59.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-29 22:07:27', NULL, NULL, '2023-09-29 21:53:27', 1),
	(179, 1, 1, 1, 26, '12345678901', '+51981233834', 'davisanderson87@gmail.com', '', 0, 0.00, 0.00, 0.00, NULL, NULL, NULL, 'Borrador', NULL, NULL, NULL, '2023-09-29 21:55:13', 2),
	(180, 1, 1, 1, 26, '12345678901', '+51981233834', 'davisanderson87@gmail.com', '', 0, 179.98, 0.00, 179.98, 'Es un placer para nosotros enviarle la cotización solicitada. Hemos tomado en cuenta todos los detalles proporcionados y hemos elaborado una oferta que creemos se ajusta a sus necesidades.Adjunto a este correo con la cotización detallada, donde podrá encontrar todos los precios, descripciones de los productos/servicios y las condiciones asociadas. Estamos seguros de que encontrará nuestra propuesta competitiva y de alta calidad.Si tiene alguna pregunta adicional o desea realizar modificaciones en la cotización, no dude en contactarnos. Estamos aquí para brindarle el mejor servicio y trabajar juntos para satisfacer sus requerimientos.', 'Detalle de los Costos Adicionales que no han sido Tenidos en Cuenta en la Cotización Inicial:', 'CONTRATO DE ACEPTACIÓN DE COTIZACIÓN\n\nEntre AnderCode INC, en adelante "El Proveedor," y [Nombre del Cliente], en adelante "El Cliente."\n\nEl Cliente ha revisado la cotización proporcionada por El Proveedor, la cual incluye una descripción detallada de los productos y/o servicios a ser suministrados. Al aceptar esta cotización, El Cliente acuerda contratar a El Proveedor para la provisión de dichos productos y/o servicios de acuerdo con los términos y condiciones estipulados en la cotización.\n\nEl Cliente acepta pagar a El Proveedor la cantidad especificada en la cotización dentro de los plazos acordados. Los detalles específicos de los pagos, incluyendo el monto total, fechas de vencimiento y cualquier término adicional relacionado con el pago, se detallan en la cotización adjunta. El Cliente comprende y acepta que el incumplimiento de los términos de pago acarreará consecuencias definidas en la cotización.\n\nEl plazo de este contrato comenzará en la fecha de aceptación de la cotización por parte del Cliente y continuará de acuerdo con la duración estipulada en la cotización. Cualquier terminación anticipada deberá ser acordada por escrito entre las partes y estará sujeta a las condiciones detalladas en la cotización. Ambas partes se comprometen a cumplir con todas las obligaciones y responsabilidades establecidas en este contrato durante su vigencia.\n\n                ', 'Enviado', '2023-09-29 22:17:24', NULL, NULL, '2023-09-29 22:09:30', 1);

-- Volcando estructura para tabla cotizador.tm_empresa
CREATE TABLE IF NOT EXISTS `tm_empresa` (
  `emp_id` int NOT NULL AUTO_INCREMENT,
  `emp_nom` varchar(255) NOT NULL,
  `emp_porcen` int NOT NULL,
  `emp_ruc` varchar(12) DEFAULT NULL,
  `emp_telf` varchar(12) DEFAULT NULL,
  `emp_email` varchar(30) DEFAULT NULL,
  `emp_web` varchar(100) DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_empresa: ~1 rows (aproximadamente)
DELETE FROM `tm_empresa`;
INSERT INTO `tm_empresa` (`emp_id`, `emp_nom`, `emp_porcen`, `emp_ruc`, `emp_telf`, `emp_email`, `emp_web`, `est`) VALUES
	(1, 'AnderCode Inc', 20, '2020212031', '555-6789', 'empresalocal@andercode.com', 'andercode.net', 1);

-- Volcando estructura para tabla cotizador.tm_producto
CREATE TABLE IF NOT EXISTS `tm_producto` (
  `prod_id` int NOT NULL AUTO_INCREMENT,
  `cat_id` int DEFAULT NULL,
  `prod_nom` varchar(255) CHARACTER SET utf16 COLLATE utf16_spanish_ci DEFAULT NULL,
  `prod_descrip` varchar(255) CHARACTER SET utf16 COLLATE utf16_spanish_ci DEFAULT NULL,
  `prod_precio` decimal(10,2) DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`prod_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla cotizador.tm_producto: ~25 rows (aproximadamente)
DELETE FROM `tm_producto`;
INSERT INTO `tm_producto` (`prod_id`, `cat_id`, `prod_nom`, `prod_descrip`, `prod_precio`, `est`) VALUES
	(1, 1, 'Producto 1', 'Descripción del Producto 1', 9.99, 1),
	(2, 7, 'Producto 2', 'Descripción del Producto 2', 19.99, 1),
	(3, 2, 'Producto 3', 'Descripción del Producto 3', 29.99, 1),
	(4, 4, 'Producto 4', 'Descripción del Producto 4', 39.99, 1),
	(5, 3, 'Producto 5', 'Descripción del Producto 5', 49.99, 1),
	(6, 1, 'Producto 6', 'Descripción del Producto 6', 59.99, 1),
	(7, 5, 'Producto 7', 'Descripción del Producto 7', 69.99, 1),
	(8, 6, 'Producto 8', 'Descripción del Producto 8', 79.99, 1),
	(9, 4, 'Producto 9', 'Descripción del Producto 9', 89.99, 1),
	(10, 3, 'Producto 10', 'Descripción del Producto 10', 99.99, 1),
	(11, 2, 'Producto 11', 'Descripción del Producto 11', 109.99, 1),
	(12, 1, 'Producto 12', 'Descripción del Producto 12', 119.99, 1),
	(13, 6, 'Producto 13', 'Descripción del Producto 13', 129.99, 1),
	(14, 5, 'Producto 14', 'Descripción del Producto 14', 139.99, 1),
	(15, 4, 'Producto 15', 'Descripción del Producto 15', 149.99, 1),
	(16, 2, 'Producto 16', 'Descripción del Producto 16', 159.99, 1),
	(17, 3, 'Producto 17', 'Descripción del Producto 17', 169.99, 1),
	(18, 1, 'Producto 18', 'Descripción del Producto 18', 179.99, 1),
	(19, 5, 'Producto 19', 'Descripción del Producto 19', 189.99, 1),
	(20, 6, 'Producto 20', 'Descripción del Producto 20', 199.99, 1),
	(21, 4, 'Producto 21', 'Descripción del Producto 21', 209.99, 1),
	(22, 3, 'Producto 22', 'Descripción del Producto 22', 219.99, 1),
	(23, 2, 'Producto 23', 'Descripción del Producto 23', 229.99, 1),
	(24, 7, 'Producto 24', 'Descripción del Producto 24', 239.99, 1),
	(25, 6, 'Producto 25', 'Descripción del Producto 25', 249.99, 1),
	(26, 1, 'test', 'test', 11.00, 1),
	(27, 2, 'test2', 'test2', 1.00, 0);

-- Volcando estructura para tabla cotizador.tm_usuario
CREATE TABLE IF NOT EXISTS `tm_usuario` (
  `usu_id` int NOT NULL AUTO_INCREMENT,
  `usu_correo` varchar(150) COLLATE utf16_spanish_ci DEFAULT NULL,
  `usu_nom` varchar(150) COLLATE utf16_spanish_ci DEFAULT NULL,
  `usu_pass` varchar(50) COLLATE utf16_spanish_ci DEFAULT NULL,
  `est` int DEFAULT NULL,
  PRIMARY KEY (`usu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf16 COLLATE=utf16_spanish_ci;

-- Volcando datos para la tabla cotizador.tm_usuario: ~1 rows (aproximadamente)
DELETE FROM `tm_usuario`;
INSERT INTO `tm_usuario` (`usu_id`, `usu_correo`, `usu_nom`, `usu_pass`, `est`) VALUES
	(1, 'davis_anderson_87@hotmail.com', 'Anderson', '123456', 1),
	(2, 'sucursal222@andercode.com', 'test1', '1234567', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
