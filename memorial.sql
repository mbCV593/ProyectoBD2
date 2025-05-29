/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 10.4.32-MariaDB : Database - proyectofinal
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`proyectofinal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `proyectofinal`;

/*Table structure for table `auditoria_cambios` */

DROP TABLE IF EXISTS `auditoria_cambios`;

CREATE TABLE `auditoria_cambios` (
  `ID_Auditoria` bigint(20) NOT NULL AUTO_INCREMENT,
  `Nombre_Tabla_Afectada` varchar(100) NOT NULL COMMENT 'Nombre de la tabla que fue modificada.',
  `ID_Registro_Afectado_PK1` varchar(255) DEFAULT NULL COMMENT 'Valor de la clave primaria (o parte 1 si es compuesta) del registro afectado.',
  `ID_Registro_Afectado_PK2` varchar(255) DEFAULT NULL COMMENT 'Valor de la parte 2 de la clave primaria si es compuesta.',
  `Correo_Usuario_Responsable` varchar(255) DEFAULT NULL COMMENT 'Usuario del sistema que realizó el cambio (FK a Usuario_Sistema.Correo_Electronico).',
  `IP_Origen_Cambio` varchar(45) DEFAULT NULL COMMENT 'Dirección IP desde donde se originó el cambio (IPv4 o IPv6).',
  `Tipo_Operacion_Realizada` enum('INSERT','UPDATE','DELETE','LOGIN_FALLIDO','LOGIN_EXITOSO','ACCESO_REPORTE') NOT NULL COMMENT 'Tipo de operación o evento auditado.',
  `Fecha_Hora_Operacion` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora exactas en que se realizó la operación.',
  `Valores_Originales_Registro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Valores del registro antes del cambio (formato JSON), aplicable para UPDATE y DELETE.' CHECK (json_valid(`Valores_Originales_Registro`)),
  `Valores_Nuevos_Registro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Valores del registro después del cambio (formato JSON), aplicable para INSERT y UPDATE.' CHECK (json_valid(`Valores_Nuevos_Registro`)),
  `Descripcion_Adicional_Cambio` text DEFAULT NULL COMMENT 'Descripción adicional, justificación del cambio o detalles del evento.',
  `User_Agent_Navegador` varchar(512) DEFAULT NULL COMMENT 'Información del User-Agent del cliente que realizó la acción.',
  PRIMARY KEY (`ID_Auditoria`),
  KEY `FK_AuditoriaCambios_RefUsuarioSistema` (`Correo_Usuario_Responsable`),
  CONSTRAINT `FK_AuditoriaCambios_RefUsuarioSistema` FOREIGN KEY (`Correo_Usuario_Responsable`) REFERENCES `usuario_sistema` (`Correo_Electronico`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla para registrar un historial detallado de cambios y eventos importantes en el sistema.';

/*Table structure for table `batalla` */

DROP TABLE IF EXISTS `batalla`;

CREATE TABLE `batalla` (
  `ID_Batalla` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Batalla` varchar(255) NOT NULL COMMENT 'Nombre comúnmente conocido de la batalla.',
  `ID_Campana` int(11) DEFAULT NULL COMMENT 'Campaña militar a la que pertenece la batalla (FK a Campana_Militar.ID_Campana, opcional).',
  `ID_Pais_Batalla` int(11) NOT NULL COMMENT 'País donde se desarrolló principalmente la batalla (FK a Pais.ID_Pais).',
  `ID_Lugar_Batalla` int(11) DEFAULT NULL COMMENT 'Lugar geográfico específico (ciudad, región) de la batalla (FK a Lugar.ID_Lugar).',
  `Lugar_Especifico_Texto` varchar(255) DEFAULT NULL COMMENT 'Descripción textual adicional del lugar si no hay ID_Lugar o como complemento (Ej: "Cerca del río Volga").',
  `Fecha_Inicio_Batalla` date NOT NULL COMMENT 'Fecha de inicio de la batalla.',
  `Fecha_Fin_Batalla` date DEFAULT NULL COMMENT 'Fecha de finalización de la batalla (nulo si fue un solo día o se desconoce el fin exacto).',
  `Descripcion_Batalla` text DEFAULT NULL COMMENT 'Breve descripción o resumen de los eventos principales de la batalla.',
  `Resultado_Batalla` text DEFAULT NULL COMMENT 'Resultado o desenlace de la batalla (Ej: Victoria Aliada, Victoria del Eje, Indeciso, Retirada Táctica).',
  `Bajas_Estimadas_Eje` int(11) DEFAULT NULL COMMENT 'Número total estimado de bajas (muertos, heridos, capturados) del Eje.',
  `Bajas_Estimadas_Aliados` int(11) DEFAULT NULL COMMENT 'Número total estimado de bajas (muertos, heridos, capturados) de los Aliados.',
  `Unidades_Principales_Eje_Texto` text DEFAULT NULL COMMENT 'Listado descriptivo de unidades principales del Eje involucradas.',
  `Unidades_Principales_Aliados_Texto` text DEFAULT NULL COMMENT 'Listado descriptivo de unidades principales de los Aliados involucradas.',
  `Importancia_Estrategica` text DEFAULT NULL COMMENT 'Notas sobre la importancia estratégica de la batalla.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Batalla`),
  KEY `FK_Batalla_CampanaMilitar` (`ID_Campana`),
  KEY `FK_Batalla_LugarBatalla` (`ID_Lugar_Batalla`),
  KEY `IDX_Batalla_Nombre` (`Nombre_Batalla`),
  KEY `IDX_Batalla_FechaInicio` (`Fecha_Inicio_Batalla`),
  KEY `IDX_Batalla_Pais` (`ID_Pais_Batalla`),
  CONSTRAINT `FK_Batalla_CampanaMilitar` FOREIGN KEY (`ID_Campana`) REFERENCES `campana_militar` (`ID_Campana`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Batalla_LugarBatalla` FOREIGN KEY (`ID_Lugar_Batalla`) REFERENCES `lugar` (`ID_Lugar`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Batalla_PaisBatalla` FOREIGN KEY (`ID_Pais_Batalla`) REFERENCES `pais` (`ID_Pais`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Información detallada de las batallas ocurridas.';

/*Table structure for table `campana_militar` */

DROP TABLE IF EXISTS `campana_militar`;

CREATE TABLE `campana_militar` (
  `ID_Campana` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Oficial_Campana` varchar(255) NOT NULL COMMENT 'Nombre oficial de la campaña u operación militar.',
  `Nombre_Codigo_Operacion` varchar(255) DEFAULT NULL COMMENT 'Nombre en clave de la operación (Ej: Operación Barbarroja, Día D).',
  `Descripcion_Campana` text DEFAULT NULL COMMENT 'Descripción general de los objetivos, desarrollo y participantes de la campaña.',
  `Fecha_Inicio_Campana` date DEFAULT NULL COMMENT 'Fecha de inicio de la campaña.',
  `Fecha_Fin_Campana` date DEFAULT NULL COMMENT 'Fecha de finalización de la campaña.',
  `Objetivo_Campana` text DEFAULT NULL COMMENT 'Objetivos estratégicos y tácticos principales de la campaña.',
  `Resultado_Campana` text DEFAULT NULL COMMENT 'Resultado o desenlace general de la campaña.',
  `Teatro_Operaciones` varchar(150) DEFAULT NULL COMMENT 'Principal teatro de operaciones donde se desarrolló (Ej: Frente Oriental, Frente Occidental, Pacífico, Mediterráneo).',
  `Paises_Principales_Eje` text DEFAULT NULL COMMENT 'Listado de países principales del Eje involucrados.',
  `Paises_Principales_Aliados` text DEFAULT NULL COMMENT 'Listado de países principales de los Aliados involucrados.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Campana`),
  UNIQUE KEY `UQ_Campana_NombreOficial_Inicio` (`Nombre_Oficial_Campana`,`Fecha_Inicio_Campana`),
  UNIQUE KEY `UQ_Campana_NombreCodigo` (`Nombre_Codigo_Operacion`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Información detallada sobre campañas y operaciones militares.';

/*Table structure for table `causa_muerte` */

DROP TABLE IF EXISTS `causa_muerte`;

CREATE TABLE `causa_muerte` (
  `ID_Causa_Muerte` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion_Causa` varchar(255) NOT NULL COMMENT 'Descripción detallada de la causa de muerte (Ej: Caído en combate por artillería, Herida de bala infectada, Neumonía en cautiverio).',
  `Categoria_Causa` enum('Combate Directo','Consecuencia de Combate','Enfermedad','Accidente','Cautiverio/Prisión','Suicidio','Ejecución','Desconocida','Otra') NOT NULL DEFAULT 'Desconocida' COMMENT 'Categoría general de la causa de muerte.',
  `Requiere_Detalle_Adicional` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Indica si esta causa usualmente requiere más detalles en notas.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Causa_Muerte`),
  UNIQUE KEY `Descripcion_Causa` (`Descripcion_Causa`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo estandarizado de causas de muerte.';

/*Table structure for table `informacion_muerte_transporte` */

DROP TABLE IF EXISTS `informacion_muerte_transporte`;

CREATE TABLE `informacion_muerte_transporte` (
  `ID_Muerte_Transporte` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Soldado` int(11) NOT NULL COMMENT 'Identificador del soldado (FK a Soldado.ID_Soldado).',
  `Tipo_Transporte_Accidente` varchar(100) NOT NULL COMMENT 'Tipo de transporte donde ocurrió la muerte (Ej: Navío, Submarino, Avión de Combate, Bombardero, Tanque, Tren, Camión).',
  `Naturaleza_Mision_Transporte` varchar(100) DEFAULT NULL COMMENT 'Naturaleza o función del transporte/misión (Ej: Combate, Transporte de Tropas, Carga, Patrulla, Reconocimiento).',
  `Nombre_O_Identificador_Transporte` varchar(255) DEFAULT NULL COMMENT 'Nombre o número de identificación del navío, avión, etc., si se conoce (Ej: U-Boot U-96, B-17 "Memphis Belle").',
  `Ubicacion_Geografica_Transporte_Muerte` text NOT NULL COMMENT 'Descripción de la ubicación geográfica del transporte al momento de ocurrir la muerte (Ej: "Atlántico Norte, cerca de Islandia", "Sobrevolando Dresde").',
  `Coordenadas_Transporte_Muerte_Lat` decimal(10,8) DEFAULT NULL COMMENT 'Latitud geográfica aproximada del transporte al momento de la muerte.',
  `Coordenadas_Transporte_Muerte_Lon` decimal(11,8) DEFAULT NULL COMMENT 'Longitud geográfica aproximada del transporte al momento de la muerte.',
  `Causa_Incidente_Transporte` text DEFAULT NULL COMMENT 'Causa del incidente que llevó a la muerte en el transporte (Ej: Derribado por fuego antiaéreo, Hundido por torpedo, Accidente de aterrizaje).',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Muerte_Transporte`),
  UNIQUE KEY `ID_Soldado` (`ID_Soldado`),
  CONSTRAINT `FK_MuerteTransporte_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalles específicos si la muerte del soldado ocurrió en un medio de transporte durante una operación o accidente.';

/*Table structure for table `lugar` */

DROP TABLE IF EXISTS `lugar`;

CREATE TABLE `lugar` (
  `ID_Lugar` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Pais` int(11) NOT NULL COMMENT 'País al que pertenece el lugar (FK a Pais.ID_Pais).',
  `Nombre_Lugar` varchar(255) NOT NULL COMMENT 'Nombre del lugar (ciudad, pueblo, villa, región, provincia, estado, etc.).',
  `Tipo_Lugar` varchar(50) DEFAULT NULL COMMENT 'Tipo de lugar (Ej: Ciudad, Pueblo, Provincia, Estado, Región Geográfica).',
  `Coordenadas_Lat` decimal(10,8) DEFAULT NULL COMMENT 'Latitud geográfica del lugar (formato decimal).',
  `Coordenadas_Lon` decimal(11,8) DEFAULT NULL COMMENT 'Longitud geográfica del lugar (formato decimal).',
  `Altitud_Metros` int(11) DEFAULT NULL COMMENT 'Altitud del lugar en metros sobre el nivel del mar (opcional).',
  `Notas_Lugar` text DEFAULT NULL COMMENT 'Notas adicionales o históricas sobre el lugar.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Lugar`),
  UNIQUE KEY `UQ_Lugar_Pais_Nombre_Tipo` (`ID_Pais`,`Nombre_Lugar`,`Tipo_Lugar`) COMMENT 'Un lugar específico en un país con un tipo debería ser único.',
  KEY `IDX_Lugar_Nombre` (`Nombre_Lugar`),
  CONSTRAINT `FK_Lugar_Pais` FOREIGN KEY (`ID_Pais`) REFERENCES `pais` (`ID_Pais`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de lugares geográficos relevantes (nacimiento, muerte, batalla, inhumación).';

/*Table structure for table `lugar_inhumacion` */

DROP TABLE IF EXISTS `lugar_inhumacion`;

CREATE TABLE `lugar_inhumacion` (
  `ID_Soldado` int(11) NOT NULL COMMENT 'Clave primaria y foránea al soldado (FK a Soldado.ID_Soldado).',
  `ID_Pais_Inhumacion` int(11) DEFAULT NULL COMMENT 'País donde fue inhumado el soldado (FK a Pais.ID_Pais).',
  `ID_Lugar_Inhumacion_Detallado` int(11) DEFAULT NULL COMMENT 'FK a Lugar para el lugar específico (pueblo, villa) de inhumación.',
  `Lugar_Detallado_Texto_Inhumacion` varchar(255) DEFAULT NULL COMMENT 'Descripción textual del estado, pueblo o villa, si no se usa FK o como complemento.',
  `Nombre_Cementerio_Memorial` varchar(255) DEFAULT NULL COMMENT 'Nombre del cementerio o memorial donde fue inhumado o se le conmemora.',
  `Tipo_Sitio_Inhumacion` enum('Tumba Individual','Fosa Común','Memorial (Sin Restos)','Cenotafio','Desconocido','Perdido en Mar/Aire') NOT NULL DEFAULT 'Desconocido',
  `Ubicacion_Exacta_Tumba` varchar(255) DEFAULT NULL COMMENT 'Ubicación específica de la tumba/placa dentro del cementerio/memorial (Ej: Sección A, Fila 10, Tumba 5).',
  `Coordenadas_Sitio_Lat` decimal(10,8) DEFAULT NULL COMMENT 'Latitud geográfica del cementerio/memorial.',
  `Coordenadas_Sitio_Lon` decimal(11,8) DEFAULT NULL COMMENT 'Longitud geográfica del cementerio/memorial.',
  `Es_Inhumacion_Desconocida_Confirmado` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'TRUE si se ha confirmado que se desconoce el lugar exacto de inhumación.',
  `Anotacion_Lugar_Desconocido` text DEFAULT NULL COMMENT 'Nota explicativa si el lugar es desconocido. Usualmente indica que se referencia el lugar de muerte o último conocido.',
  `Fotografia_Tumba_URL` varchar(2048) DEFAULT NULL,
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Soldado`),
  KEY `FK_LugarInhumacion_RefPais` (`ID_Pais_Inhumacion`),
  KEY `FK_LugarInhumacion_RefLugar` (`ID_Lugar_Inhumacion_Detallado`),
  CONSTRAINT `FK_LugarInhumacion_RefLugar` FOREIGN KEY (`ID_Lugar_Inhumacion_Detallado`) REFERENCES `lugar` (`ID_Lugar`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_LugarInhumacion_RefPais` FOREIGN KEY (`ID_Pais_Inhumacion`) REFERENCES `pais` (`ID_Pais`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_LugarInhumacion_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Información detallada sobre el lugar de inhumación o conmemoración del soldado.';

/*Table structure for table `medalla` */

DROP TABLE IF EXISTS `medalla`;

CREATE TABLE `medalla` (
  `ID_Medalla` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Medalla` varchar(255) NOT NULL COMMENT 'Nombre oficial de la medalla, condecoración o distintivo.',
  `Descripcion_Medalla` text DEFAULT NULL COMMENT 'Descripción de la medalla, su significado y simbolismo.',
  `ID_Pais_Otorga` int(11) DEFAULT NULL COMMENT 'País que otorga la medalla (FK a Pais.ID_Pais).',
  `Criterio_Otorgamiento` text DEFAULT NULL COMMENT 'Criterios generales o motivos comunes para su otorgamiento.',
  `Tipo_Condecoracion` enum('Valor','Servicio Meritorio','Campaña','Herida','Antigüedad','Conmemorativa','Otra') NOT NULL DEFAULT 'Otra',
  `Imagen_Medalla_URL` varchar(2048) DEFAULT NULL COMMENT 'URL a una imagen representativa de la medalla.',
  `Fecha_Institucion_Medalla` date DEFAULT NULL COMMENT 'Fecha en que la medalla fue instituida.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Medalla`),
  UNIQUE KEY `UQ_Medalla_Nombre_PaisOtorga` (`Nombre_Medalla`,`ID_Pais_Otorga`),
  KEY `FK_Medalla_PaisOtorga` (`ID_Pais_Otorga`),
  CONSTRAINT `FK_Medalla_PaisOtorga` FOREIGN KEY (`ID_Pais_Otorga`) REFERENCES `pais` (`ID_Pais`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de medallas, condecoraciones y distintivos militares.';

/*Table structure for table `pais` */

DROP TABLE IF EXISTS `pais`;

CREATE TABLE `pais` (
  `ID_Pais` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Pais` varchar(100) NOT NULL COMMENT 'Nombre oficial y común del país.',
  `Codigo_ISO_Alfa2` char(2) DEFAULT NULL COMMENT 'Código ISO 3166-1 Alfa-2 del país (Ej: US, DE, GB).',
  `Codigo_ISO_Alfa3` char(3) DEFAULT NULL COMMENT 'Código ISO 3166-1 Alfa-3 del país (Ej: USA, DEU, GBR).',
  `Continente` varchar(50) DEFAULT NULL COMMENT 'Continente al que pertenece el país.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp() COMMENT 'Fecha de creación del registro en la base de datos.',
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Fecha de última actualización del registro en la base de datos.',
  PRIMARY KEY (`ID_Pais`),
  UNIQUE KEY `Nombre_Pais` (`Nombre_Pais`),
  UNIQUE KEY `Codigo_ISO_Alfa2` (`Codigo_ISO_Alfa2`),
  UNIQUE KEY `Codigo_ISO_Alfa3` (`Codigo_ISO_Alfa3`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de países involucrados o de referencia.';

/*Table structure for table `rama_ejercito` */

DROP TABLE IF EXISTS `rama_ejercito`;

CREATE TABLE `rama_ejercito` (
  `ID_Rama_Ejercito` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Rama` varchar(100) NOT NULL COMMENT 'Nombre de la rama del ejército (Ej: Ejército de Tierra, Marina de Guerra, Fuerza Aérea, Fuerzas Especiales, Waffen-SS, Guardia Nacional).',
  `Descripcion_Rama` text DEFAULT NULL COMMENT 'Descripción detallada de las funciones y características de la rama del ejército.',
  `Siglas_Rama` varchar(20) DEFAULT NULL COMMENT 'Siglas o abreviatura común de la rama.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Rama_Ejercito`),
  UNIQUE KEY `Nombre_Rama` (`Nombre_Rama`),
  UNIQUE KEY `Siglas_Rama` (`Siglas_Rama`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de las diferentes ramas de las fuerzas armadas.';

/*Table structure for table `rango` */

DROP TABLE IF EXISTS `rango`;

CREATE TABLE `rango` (
  `ID_Rango` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Rango` varchar(100) NOT NULL COMMENT 'Nombre del rango militar (Ej: Soldado, Sargento, Capitán, General).',
  `Abreviatura_Rango` varchar(30) DEFAULT NULL COMMENT 'Abreviatura común del rango (Ej: Sdo., Sgt., Cap., Gral.).',
  `Orden_Jerarquico` int(11) NOT NULL DEFAULT 0 COMMENT 'Valor numérico para facilitar el ordenamiento por jerarquía (mayor número = mayor rango).',
  `ID_Rama_Ejercito_Aplicable` int(11) DEFAULT NULL COMMENT 'Si el rango es específico o predominantemente usado en una rama del ejército (FK a Rama_Ejercito.ID_Rama_Ejercito).',
  `Equivalencia_OTAN` varchar(10) DEFAULT NULL COMMENT 'Código de rango equivalente OTAN (Ej: OR-1, OF-3), si aplica.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Rango`),
  UNIQUE KEY `UQ_Rango_Nombre_Rama` (`Nombre_Rango`,`ID_Rama_Ejercito_Aplicable`) COMMENT 'Un nombre de rango debe ser único dentro de una rama específica, o global si la rama es NULL.',
  KEY `FK_Rango_RamaEjercitoAplicable` (`ID_Rama_Ejercito_Aplicable`),
  CONSTRAINT `FK_Rango_RamaEjercitoAplicable` FOREIGN KEY (`ID_Rama_Ejercito_Aplicable`) REFERENCES `rama_ejercito` (`ID_Rama_Ejercito`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de rangos militares y su jerarquía.';

/*Table structure for table `soldado` */

DROP TABLE IF EXISTS `soldado`;

CREATE TABLE `soldado` (
  `ID_Soldado` int(11) NOT NULL AUTO_INCREMENT,
  `Nombres` varchar(150) NOT NULL COMMENT 'Nombres de pila del soldado.',
  `Patronimico` varchar(100) DEFAULT NULL COMMENT 'Segundo nombre o patronímico, si aplica (común en algunas culturas).',
  `Apellidos` varchar(150) NOT NULL COMMENT 'Apellidos del soldado.',
  `Nombre_Completo_Busqueda` varchar(402) GENERATED ALWAYS AS (trim(concat_ws(' ',`Nombres`,`Patronimico`,`Apellidos`))) STORED COMMENT 'Campo calculado para facilitar búsquedas de nombre completo. STORED para indexación.',
  `Sexo` enum('Masculino','Femenino','Desconocido') NOT NULL DEFAULT 'Desconocido',
  `ID_Pais_Origen` int(11) NOT NULL COMMENT 'País de origen (nacionalidad al momento del servicio) del soldado (FK a Pais.ID_Pais).',
  `ID_Lugar_Nacimiento` int(11) NOT NULL COMMENT 'Lugar de nacimiento del soldado (FK a Lugar.ID_Lugar).',
  `Fecha_Nacimiento` date NOT NULL COMMENT 'Fecha de nacimiento del soldado.',
  `Fecha_Nacimiento_Precision` enum('Exacta','Mes y Año','Solo Año','Aproximada') NOT NULL DEFAULT 'Exacta',
  `ID_Lugar_Muerte` int(11) DEFAULT NULL COMMENT 'Lugar donde murió el soldado (FK a Lugar.ID_Lugar, puede ser nulo si se desconoce).',
  `Fecha_Muerte` date DEFAULT NULL COMMENT 'Fecha de muerte del soldado (puede ser nula si se desconoce).',
  `Fecha_Muerte_Precision` enum('Exacta','Mes y Año','Solo Año','Aproximada','Declarado Muerto') NOT NULL DEFAULT 'Exacta',
  `ID_Causa_Muerte` int(11) DEFAULT NULL COMMENT 'Causa de la muerte del soldado (FK a Causa_Muerte.ID_Causa_Muerte).',
  `ID_Rama_Ejercito` int(11) DEFAULT NULL COMMENT 'Rama del ejército a la que perteneció el soldado principalmente (FK a Rama_Ejercito.ID_Rama_Ejercito).',
  `Numero_Identificacion_Militar` varchar(50) DEFAULT NULL COMMENT 'Número de servicio o identificación militar único del soldado, si se conoce.',
  `Notas_Adicionales_Soldado` text DEFAULT NULL COMMENT 'Espacio para cualquier información adicional relevante no estructurada sobre el soldado.',
  `Fotografia_URL` varchar(2048) DEFAULT NULL COMMENT 'URL a una fotografía del soldado, si existe y está permitida.',
  `Estado_Registro` enum('Verificado','Pendiente Verificacion','Incompleto','Disputado') NOT NULL DEFAULT 'Pendiente Verificacion',
  `Fuente_Informacion_Principal` text DEFAULT NULL COMMENT 'Referencia a la fuente principal de donde se obtuvo la información del soldado.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Soldado`),
  UNIQUE KEY `Numero_Identificacion_Militar` (`Numero_Identificacion_Militar`),
  KEY `FK_Soldado_LugarNac` (`ID_Lugar_Nacimiento`),
  KEY `FK_Soldado_LugarFall` (`ID_Lugar_Muerte`),
  KEY `FK_Soldado_CausaFall` (`ID_Causa_Muerte`),
  KEY `FK_Soldado_RamaMil` (`ID_Rama_Ejercito`),
  KEY `IDX_Soldado_NombreCompleto` (`Nombre_Completo_Busqueda`),
  KEY `IDX_Soldado_ApellidosNombres` (`Apellidos`,`Nombres`),
  KEY `IDX_Soldado_FechaNac` (`Fecha_Nacimiento`),
  KEY `IDX_Soldado_FechaFall` (`Fecha_Muerte`),
  KEY `IDX_Soldado_PaisOrg` (`ID_Pais_Origen`),
  KEY `IDX_Soldado_NumIdent` (`Numero_Identificacion_Militar`),
  CONSTRAINT `FK_Soldado_CausaFall` FOREIGN KEY (`ID_Causa_Muerte`) REFERENCES `causa_muerte` (`ID_Causa_Muerte`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Soldado_LugarFall` FOREIGN KEY (`ID_Lugar_Muerte`) REFERENCES `lugar` (`ID_Lugar`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Soldado_LugarNac` FOREIGN KEY (`ID_Lugar_Nacimiento`) REFERENCES `lugar` (`ID_Lugar`) ON UPDATE CASCADE,
  CONSTRAINT `FK_Soldado_PaisNacionalidad` FOREIGN KEY (`ID_Pais_Origen`) REFERENCES `pais` (`ID_Pais`) ON UPDATE CASCADE,
  CONSTRAINT `FK_Soldado_RamaMil` FOREIGN KEY (`ID_Rama_Ejercito`) REFERENCES `rama_ejercito` (`ID_Rama_Ejercito`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Información detallada y central de los soldados caídos durante la SGM.';

/*Table structure for table `soldado_ascenso` */

DROP TABLE IF EXISTS `soldado_ascenso`;

CREATE TABLE `soldado_ascenso` (
  `ID_Soldado_Ascenso` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Soldado` int(11) NOT NULL COMMENT 'Identificador del soldado (FK a Soldado.ID_Soldado).',
  `ID_Rango` int(11) NOT NULL COMMENT 'Identificador del rango obtenido (FK a Rango.ID_Rango).',
  `Fecha_Inicio_Rango` date NOT NULL COMMENT 'Fecha en que el soldado obtuvo este rango.',
  `Fecha_Fin_Rango` date DEFAULT NULL COMMENT 'Fecha en que el soldado dejó este rango. Nulo si es el rango activo hasta su muerte/fin de servicio.',
  `Documento_Referencia_Ascenso` varchar(255) DEFAULT NULL COMMENT 'Referencia a documento o decreto que oficializa el ascenso.',
  `Notas_Adicionales_Ascenso` text DEFAULT NULL COMMENT 'Notas adicionales sobre el ascenso o las circunstancias del mismo.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Soldado_Ascenso`),
  UNIQUE KEY `UQ_Soldado_Rango_FechaInicio` (`ID_Soldado`,`ID_Rango`,`Fecha_Inicio_Rango`),
  KEY `FK_SoldadoAscenso_RefRango` (`ID_Rango`),
  CONSTRAINT `FK_SoldadoAscenso_RefRango` FOREIGN KEY (`ID_Rango`) REFERENCES `rango` (`ID_Rango`) ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoAscenso_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Historial de ascensos y rangos ostentados por el soldado a lo largo de su servicio.';

/*Table structure for table `soldado_medalla` */

DROP TABLE IF EXISTS `soldado_medalla`;

CREATE TABLE `soldado_medalla` (
  `ID_Soldado_Medalla` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Soldado` int(11) NOT NULL COMMENT 'Identificador del soldado (FK a Soldado.ID_Soldado).',
  `ID_Medalla` int(11) NOT NULL COMMENT 'Identificador de la medalla (FK a Medalla.ID_Medalla).',
  `Fecha_Obtencion_Medalla` date DEFAULT NULL COMMENT 'Fecha en que se otorgó la medalla al soldado.',
  `Motivo_Condecoracion_Especifico` text DEFAULT NULL COMMENT 'Motivo específico o hazaña particular por la cual se otorgó esta medalla a este soldado.',
  `ID_Batalla_Relacionada_Medalla` int(11) DEFAULT NULL COMMENT 'Batalla en la que se ganó la medalla, si aplica (FK a Batalla.ID_Batalla).',
  `Documento_Referencia_Medalla` varchar(255) DEFAULT NULL COMMENT 'Referencia a documento oficial que acredita la condecoración (Ej: Número de decreto, página de diario oficial).',
  `Otorgada_Postumamente` tinyint(1) NOT NULL DEFAULT 0,
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Soldado_Medalla`),
  UNIQUE KEY `UQ_Soldado_Medalla_Fecha` (`ID_Soldado`,`ID_Medalla`,`Fecha_Obtencion_Medalla`),
  KEY `FK_SoldadoMedalla_RefMedalla` (`ID_Medalla`),
  KEY `FK_SoldadoMedalla_RefBatalla` (`ID_Batalla_Relacionada_Medalla`),
  CONSTRAINT `FK_SoldadoMedalla_RefBatalla` FOREIGN KEY (`ID_Batalla_Relacionada_Medalla`) REFERENCES `batalla` (`ID_Batalla`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoMedalla_RefMedalla` FOREIGN KEY (`ID_Medalla`) REFERENCES `medalla` (`ID_Medalla`) ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoMedalla_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de medallas y condecoraciones otorgadas a cada soldado.';

/*Table structure for table `soldado_participacion_batalla` */

DROP TABLE IF EXISTS `soldado_participacion_batalla`;

CREATE TABLE `soldado_participacion_batalla` (
  `ID_Participacion_Batalla` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Soldado` int(11) NOT NULL COMMENT 'Identificador del soldado participante (FK a Soldado.ID_Soldado).',
  `ID_Batalla` int(11) NOT NULL COMMENT 'Identificador de la batalla en la que participó (FK a Batalla.ID_Batalla).',
  `ID_Unidad_Militar_En_Batalla` int(11) DEFAULT NULL COMMENT 'Unidad a la que pertenecía el soldado durante esta batalla específica (FK a Unidad_Militar.ID_Unidad).',
  `Rol_O_Acciones_En_Batalla` varchar(255) DEFAULT NULL COMMENT 'Descripción del rol o acciones destacadas del soldado en la batalla.',
  `Estado_Soldado_Post_Batalla` enum('Ileso','Herido Leve','Herido Grave','Caído en Combate (KIA)','Prisionero de Guerra (POW)','Desaparecido en Acción (MIA)','Evacuado por Heridas','Otro') DEFAULT NULL COMMENT 'Estado del soldado al finalizar su participación en la batalla.',
  `Fecha_Inicio_Participacion_Batalla` date DEFAULT NULL COMMENT 'Fecha de inicio de participación del soldado en la batalla (si difiere del inicio general de la batalla).',
  `Fecha_Fin_Participacion_Batalla` date DEFAULT NULL COMMENT 'Fecha de fin de participación del soldado en la batalla (si difiere del fin general de la batalla).',
  `Notas_Participacion_Batalla` text DEFAULT NULL,
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Participacion_Batalla`),
  UNIQUE KEY `UQ_Soldado_Batalla_ParticipacionUnica` (`ID_Soldado`,`ID_Batalla`),
  KEY `FK_SoldadoParticipacionBatalla_RefBatalla` (`ID_Batalla`),
  KEY `FK_SoldadoParticipacionBatalla_RefUnidad` (`ID_Unidad_Militar_En_Batalla`),
  CONSTRAINT `FK_SoldadoParticipacionBatalla_RefBatalla` FOREIGN KEY (`ID_Batalla`) REFERENCES `batalla` (`ID_Batalla`) ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoParticipacionBatalla_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoParticipacionBatalla_RefUnidad` FOREIGN KEY (`ID_Unidad_Militar_En_Batalla`) REFERENCES `unidad_militar` (`ID_Unidad`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de la participación de los soldados en batallas específicas, incluyendo su unidad y estado.';

/*Table structure for table `soldado_pertenencia_unidad` */

DROP TABLE IF EXISTS `soldado_pertenencia_unidad`;

CREATE TABLE `soldado_pertenencia_unidad` (
  `ID_Pertenencia` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Soldado` int(11) NOT NULL COMMENT 'Identificador del soldado (FK a Soldado.ID_Soldado).',
  `ID_Unidad` int(11) NOT NULL COMMENT 'Identificador de la unidad militar a la que perteneció (FK a Unidad_Militar.ID_Unidad).',
  `Fecha_Inicio_Pertenencia_Unidad` date NOT NULL COMMENT 'Fecha en que el soldado se unió o fue asignado a esta unidad.',
  `Fecha_Fin_Pertenencia_Unidad` date DEFAULT NULL COMMENT 'Fecha en que el soldado dejó la unidad (nulo si perteneció hasta su muerte/fin de servicio en la unidad).',
  `Rol_Desempenado_En_Unidad` varchar(100) DEFAULT NULL COMMENT 'Rol o cargo desempeñado por el soldado en la unidad (Ej: Fusilero, Jefe de Pelotón, Operador de Radio).',
  `Notas_Sobre_Pertenencia` text DEFAULT NULL COMMENT 'Notas adicionales sobre la pertenencia del soldado a esta unidad (Ej: Transferido, Herido en servicio con esta unidad).',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Pertenencia`),
  UNIQUE KEY `UQ_Soldado_Unidad_FechaInicioP` (`ID_Soldado`,`ID_Unidad`,`Fecha_Inicio_Pertenencia_Unidad`),
  KEY `FK_SoldadoPertenencia_RefUnidad` (`ID_Unidad`),
  CONSTRAINT `FK_SoldadoPertenencia_RefSoldado` FOREIGN KEY (`ID_Soldado`) REFERENCES `soldado` (`ID_Soldado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SoldadoPertenencia_RefUnidad` FOREIGN KEY (`ID_Unidad`) REFERENCES `unidad_militar` (`ID_Unidad`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de las unidades a las que perteneció un soldado y los periodos correspondientes.';

/*Table structure for table `unidad_militar` */

DROP TABLE IF EXISTS `unidad_militar`;

CREATE TABLE `unidad_militar` (
  `ID_Unidad` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre_Unidad` varchar(255) NOT NULL COMMENT 'Nombre oficial o designación de la unidad militar.',
  `Tipo_Unidad` enum('Grupo de Ejércitos','Ejército','Cuerpo de Ejército','División','Brigada','Regimiento','Batallón','Compañía','Batería','Pelotón','Escuadrón (Tierra)','Flota','Flotilla','Escuadrón (Naval)','Ala (Aérea)','Grupo (Aéreo)','Escuadrilla (Aérea)','Fuerza de Tarea','Destacamento','Otro') NOT NULL COMMENT 'Tipo o nivel orgánico de la unidad militar.',
  `ID_Pais_Afiliacion_Unidad` int(11) DEFAULT NULL COMMENT 'País al que pertenece o está afiliada la unidad militar (FK a Pais.ID_Pais).',
  `ID_Rama_Ejercito_Unidad` int(11) DEFAULT NULL COMMENT 'Rama del ejército a la que pertenece la unidad (FK a Rama_Ejercito.ID_Rama_Ejercito).',
  `ID_Unidad_Superior_Directa` int(11) DEFAULT NULL COMMENT 'Identificador de la unidad militar inmediatamente superior en la jerarquía (FK a Unidad_Militar.ID_Unidad).',
  `Fecha_Activacion_Unidad` date DEFAULT NULL COMMENT 'Fecha de creación o activación de la unidad.',
  `Fecha_Desactivacion_Unidad` date DEFAULT NULL COMMENT 'Fecha de disolución o desactivación de la unidad.',
  `Insignia_Unidad_URL` varchar(2048) DEFAULT NULL COMMENT 'URL a una imagen de la insignia o emblema de la unidad.',
  `Historia_Resumida_Unidad` text DEFAULT NULL COMMENT 'Breve historia, acciones notables o reseña de la unidad militar.',
  `Lema_O_Grito_Unidad` varchar(255) DEFAULT NULL COMMENT 'Lema, lema o grito de guerra característico de la unidad.',
  `Especializacion_Unidad` varchar(150) DEFAULT NULL COMMENT 'Ej: Infantería, Blindada, Artillería, Paracaidista, Logística.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Unidad`),
  UNIQUE KEY `UQ_Unidad_Nombre_Pais_Tipo` (`Nombre_Unidad`,`ID_Pais_Afiliacion_Unidad`,`Tipo_Unidad`),
  KEY `FK_UnidadMilitar_RefRamaEjercito` (`ID_Rama_Ejercito_Unidad`),
  KEY `FK_UnidadMilitar_RefUnidadSuperior` (`ID_Unidad_Superior_Directa`),
  KEY `IDX_UnidadMilitar_NombreUnidad` (`Nombre_Unidad`),
  KEY `IDX_UnidadMilitar_TipoUnidad` (`Tipo_Unidad`),
  KEY `IDX_UnidadMilitar_PaisAfil` (`ID_Pais_Afiliacion_Unidad`),
  CONSTRAINT `FK_UnidadMilitar_RefPaisAfiliacion` FOREIGN KEY (`ID_Pais_Afiliacion_Unidad`) REFERENCES `pais` (`ID_Pais`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_UnidadMilitar_RefRamaEjercito` FOREIGN KEY (`ID_Rama_Ejercito_Unidad`) REFERENCES `rama_ejercito` (`ID_Rama_Ejercito`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_UnidadMilitar_RefUnidadSuperior` FOREIGN KEY (`ID_Unidad_Superior_Directa`) REFERENCES `unidad_militar` (`ID_Unidad`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de unidades militares, su tipo, afiliación y estructura jerárquica.';

/*Table structure for table `unidad_militar_comandante` */

DROP TABLE IF EXISTS `unidad_militar_comandante`;

CREATE TABLE `unidad_militar_comandante` (
  `ID_Comandancia` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Unidad_Comandada` int(11) NOT NULL COMMENT 'Identificador de la unidad militar comandada (FK a Unidad_Militar.ID_Unidad).',
  `ID_Soldado_Comandante` int(11) NOT NULL COMMENT 'Identificador del soldado que ejerció como comandante (FK a Soldado.ID_Soldado).',
  `ID_Rango_Comandante_Al_Asumir_Mando` int(11) DEFAULT NULL COMMENT 'Rango del comandante al momento de asumir esta posición específica (FK a Rango.ID_Rango).',
  `Fecha_Inicio_Comando_Unidad` date NOT NULL COMMENT 'Fecha en que el soldado asumió el comando de la unidad.',
  `Fecha_Fin_Comando_Unidad` date DEFAULT NULL COMMENT 'Fecha en que el soldado dejó el comando (nulo si comandó hasta disolución de unidad, su muerte o relevo).',
  `Tipo_Liderazgo_Comando` varchar(100) DEFAULT NULL COMMENT 'Tipo de comando (Ej: Interino, Oficial al Mando, Designado, En Funciones).',
  `Notas_Sobre_Comando` text DEFAULT NULL COMMENT 'Notas adicionales sobre el periodo de comando.',
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID_Comandancia`),
  UNIQUE KEY `UQ_Unidad_Comandante_FechaInicioC` (`ID_Unidad_Comandada`,`ID_Soldado_Comandante`,`Fecha_Inicio_Comando_Unidad`),
  KEY `FK_UnidadComandante_RefSoldado` (`ID_Soldado_Comandante`),
  KEY `FK_UnidadComandante_RefRango` (`ID_Rango_Comandante_Al_Asumir_Mando`),
  CONSTRAINT `FK_UnidadComandante_RefRango` FOREIGN KEY (`ID_Rango_Comandante_Al_Asumir_Mando`) REFERENCES `rango` (`ID_Rango`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_UnidadComandante_RefSoldado` FOREIGN KEY (`ID_Soldado_Comandante`) REFERENCES `soldado` (`ID_Soldado`) ON UPDATE CASCADE,
  CONSTRAINT `FK_UnidadComandante_RefUnidad` FOREIGN KEY (`ID_Unidad_Comandada`) REFERENCES `unidad_militar` (`ID_Unidad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registra los comandantes de las unidades militares y los periodos de su comando.';

/*Table structure for table `usuario_sistema` */

DROP TABLE IF EXISTS `usuario_sistema`;

CREATE TABLE `usuario_sistema` (
  `Correo_Electronico` varchar(255) NOT NULL COMMENT 'Correo electrónico del usuario, usado como identificador único y para login.',
  `Nombres_Usuario` varchar(150) NOT NULL,
  `Apellidos_Usuario` varchar(150) NOT NULL,
  `ID_Pais_Origen_Usuario` int(11) NOT NULL COMMENT 'País de origen del usuario (FK a Pais.ID_Pais).',
  `Password_Hash_Usuario` varchar(255) NOT NULL COMMENT 'Hash de la contraseña del usuario (NUNCA almacenar contraseñas en texto plano). Se recomienda Argon2 o bcrypt.',
  `Rol_Usuario_Sistema` enum('Administrador Global','Administrador Contenido','Investigador Senior','Colaborador Verificado','Consultor Registrado','Consultor Anónimo') NOT NULL DEFAULT 'Consultor Registrado' COMMENT 'Rol del usuario en el sistema, define niveles de acceso y permisos.',
  `Fecha_Registro_Usuario` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora en que se registró el usuario.',
  `Fecha_Ultimo_Acceso_Usuario` datetime DEFAULT NULL COMMENT 'Fecha y hora del último acceso del usuario al sistema.',
  `Estado_Cuenta_Usuario` enum('Activo','Inactivo','Suspendido','Pendiente Verificacion Email','Bloqueado') NOT NULL DEFAULT 'Pendiente Verificacion Email' COMMENT 'Estado actual de la cuenta del usuario.',
  `Token_Verificacion_Email` varchar(100) DEFAULT NULL COMMENT 'Token único para verificación de correo electrónico tras el registro.',
  `Fecha_Expiracion_Token_Verificacion` datetime DEFAULT NULL COMMENT 'Fecha de expiración del token de verificación de email.',
  `Token_Reseteo_Password` varchar(100) DEFAULT NULL COMMENT 'Token único para el proceso de reseteo de contraseña.',
  `Fecha_Expiracion_Token_Reseteo` datetime DEFAULT NULL COMMENT 'Fecha de expiración del token de reseteo de contraseña.',
  `Numero_Intentos_Fallidos_Login` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Fecha_Ultimo_Intento_Fallido` datetime DEFAULT NULL,
  `Fecha_Ultimo_Cambio_Password` datetime DEFAULT NULL,
  `Preferencias_Usuario` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Preferencias del usuario en formato JSON (Ej: idioma, notificaciones).' CHECK (json_valid(`Preferencias_Usuario`)),
  `Fecha_Creacion` timestamp NULL DEFAULT current_timestamp(),
  `Fecha_Actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`Correo_Electronico`),
  UNIQUE KEY `Token_Verificacion_Email` (`Token_Verificacion_Email`),
  UNIQUE KEY `Token_Reseteo_Password` (`Token_Reseteo_Password`),
  KEY `FK_UsuarioSistema_RefPaisOrigen` (`ID_Pais_Origen_Usuario`),
  CONSTRAINT `FK_UsuarioSistema_RefPaisOrigen` FOREIGN KEY (`ID_Pais_Origen_Usuario`) REFERENCES `pais` (`ID_Pais`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios registrados para acceder, consultar y/o contribuir al sistema de memoria histórica.';

/* Trigger structure for table `batalla` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Batalla_Fechas_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Batalla_Fechas_BI` BEFORE INSERT ON `batalla` FOR EACH ROW 
BEGIN
    DECLARE v_campana_inicio DATE;
    DECLARE v_campana_fin DATE;

    IF NEW.Fecha_Fin_Batalla IS NOT NULL AND NEW.Fecha_Fin_Batalla < NEW.Fecha_Inicio_Batalla THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BI]: La fecha de fin de la batalla no puede ser anterior a su fecha de inicio.';
    END IF;

    IF NEW.ID_Campana IS NOT NULL THEN
        SELECT Fecha_Inicio_Campana, Fecha_Fin_Campana INTO v_campana_inicio, v_campana_fin FROM `Campana_Militar` WHERE `ID_Campana` = NEW.ID_Campana;
        IF v_campana_inicio IS NOT NULL AND NEW.Fecha_Inicio_Batalla < v_campana_inicio THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BI]: La fecha de inicio de la batalla no puede ser anterior al inicio de la campaña asociada.';
        END IF;
        IF v_campana_fin IS NOT NULL THEN
            IF NEW.Fecha_Fin_Batalla IS NOT NULL AND NEW.Fecha_Fin_Batalla > v_campana_fin THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BI]: La fecha de fin de la batalla no puede ser posterior al fin de la campaña asociada.';
            END IF;
            IF NEW.Fecha_Inicio_Batalla > v_campana_fin THEN
                 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BI]: La fecha de inicio de la batalla no puede ser posterior al fin de la campaña asociada.';
            END IF;
        END IF;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `batalla` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Batalla_Fechas_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Batalla_Fechas_BU` BEFORE UPDATE ON `batalla` FOR EACH ROW 
BEGIN
    DECLARE v_campana_inicio DATE;
    DECLARE v_campana_fin DATE;

    IF NEW.Fecha_Fin_Batalla IS NOT NULL AND NEW.Fecha_Fin_Batalla < NEW.Fecha_Inicio_Batalla THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BU]: La fecha de fin de la batalla no puede ser anterior a su fecha de inicio.';
    END IF;

    IF NEW.ID_Campana IS NOT NULL THEN
        SELECT Fecha_Inicio_Campana, Fecha_Fin_Campana INTO v_campana_inicio, v_campana_fin FROM `Campana_Militar` WHERE `ID_Campana` = NEW.ID_Campana;
        IF v_campana_inicio IS NOT NULL AND NEW.Fecha_Inicio_Batalla < v_campana_inicio THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BU]: La fecha de inicio de la batalla no puede ser anterior al inicio de la campaña asociada.';
        END IF;
        IF v_campana_fin IS NOT NULL THEN
            IF NEW.Fecha_Fin_Batalla IS NOT NULL AND NEW.Fecha_Fin_Batalla > v_campana_fin THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BU]: La fecha de fin de la batalla no puede ser posterior al fin de la campaña asociada.';
            END IF;
             IF NEW.Fecha_Inicio_Batalla > v_campana_fin THEN
                 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Batalla BU]: La fecha de inicio de la batalla no puede ser posterior al fin de la campaña asociada.';
            END IF;
        END IF;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `lugar_inhumacion` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Lugar_Inhumacion_Desconocida_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Lugar_Inhumacion_Desconocida_BI` BEFORE INSERT ON `lugar_inhumacion` FOR EACH ROW 
BEGIN
    IF NEW.Es_Inhumacion_Desconocida_Confirmado = TRUE THEN
        SET NEW.ID_Pais_Inhumacion = NULL;
        SET NEW.ID_Lugar_Inhumacion_Detallado = NULL;
        SET NEW.Lugar_Detallado_Texto_Inhumacion = NULL;
        SET NEW.Nombre_Cementerio_Memorial = 'Desconocido';
        SET NEW.Ubicacion_Exacta_Tumba = NULL;
        SET NEW.Coordenadas_Sitio_Lat = NULL;
        SET NEW.Coordenadas_Sitio_Lon = NULL;
        SET NEW.Tipo_Sitio_Inhumacion = 'Desconocido';
        IF NEW.Anotacion_Lugar_Desconocido IS NULL OR NEW.Anotacion_Lugar_Desconocido = '' THEN
           SET NEW.Anotacion_Lugar_Desconocido = 'Lugar exacto de inhumación desconocido o no confirmado. Se referencia información del lugar de muerte si está disponible en la ficha del soldado.';
        END IF;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `lugar_inhumacion` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Lugar_Inhumacion_Desconocida_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Lugar_Inhumacion_Desconocida_BU` BEFORE UPDATE ON `lugar_inhumacion` FOR EACH ROW 
BEGIN
    IF NEW.Es_Inhumacion_Desconocida_Confirmado = TRUE THEN
        SET NEW.ID_Pais_Inhumacion = NULL;
        SET NEW.ID_Lugar_Inhumacion_Detallado = NULL;
        SET NEW.Lugar_Detallado_Texto_Inhumacion = NULL;
        SET NEW.Nombre_Cementerio_Memorial = IF(OLD.Nombre_Cementerio_Memorial IS NOT NULL AND OLD.Es_Inhumacion_Desconocida_Confirmado = FALSE, OLD.Nombre_Cementerio_Memorial, 'Desconocido');
        SET NEW.Ubicacion_Exacta_Tumba = NULL;
        SET NEW.Coordenadas_Sitio_Lat = NULL;
        SET NEW.Coordenadas_Sitio_Lon = NULL;
        SET NEW.Tipo_Sitio_Inhumacion = 'Desconocido';
        IF (NEW.Anotacion_Lugar_Desconocido IS NULL OR NEW.Anotacion_Lugar_Desconocido = '') AND (OLD.Anotacion_Lugar_Desconocido IS NULL OR OLD.Anotacion_Lugar_Desconocido = '' OR OLD.Anotacion_Lugar_Desconocido != 'Lugar exacto de inhumación desconocido o no confirmado. Se referencia información del lugar de muerte si está disponible en la ficha del soldado.') THEN
           SET NEW.Anotacion_Lugar_Desconocido = 'Lugar exacto de inhumación desconocido o no confirmado. Se referencia información del lugar de muerte si está disponible en la ficha del soldado.';
        END IF;
    ELSEIF OLD.Es_Inhumacion_Desconocida_Confirmado = TRUE AND NEW.Es_Inhumacion_Desconocida_Confirmado = FALSE THEN
        IF NEW.Anotacion_Lugar_Desconocido = 'Lugar exacto de inhumación desconocido o no confirmado. Se referencia información del lugar de muerte si está disponible en la ficha del soldado.' THEN
            SET NEW.Anotacion_Lugar_Desconocido = NULL;
        END IF;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Soldado_Validacion_Fechas_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Soldado_Validacion_Fechas_BI` BEFORE INSERT ON `soldado` FOR EACH ROW 
BEGIN
    IF NEW.Fecha_Muerte IS NOT NULL AND NEW.Fecha_Nacimiento IS NOT NULL AND NEW.Fecha_Muerte < NEW.Fecha_Nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Soldado BI]: La fecha de muerte no puede ser anterior a la fecha de nacimiento.';
    END IF;
    IF NEW.Fecha_Nacimiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Soldado BI]: La fecha de nacimiento no puede ser en el futuro.';
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Auditoria_Soldado_AI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Auditoria_Soldado_AI` AFTER INSERT ON `soldado` FOR EACH ROW 
BEGIN
    INSERT INTO `Auditoria_Cambios` (`Nombre_Tabla_Afectada`, `ID_Registro_Afectado_PK1`, `Correo_Usuario_Responsable`, `Tipo_Operacion_Realizada`, `Valores_Nuevos_Registro`, `Descripcion_Adicional_Cambio`)
    VALUES ('Soldado', CAST(NEW.ID_Soldado AS CHAR), COALESCE(@current_user_email, SUBSTRING_INDEX(USER(),'@',1)), 'INSERT',
            JSON_OBJECT('ID_Soldado',NEW.ID_Soldado,'Nombre_Completo_Busqueda',NEW.Nombre_Completo_Busqueda,'Fecha_Nacimiento',NEW.Fecha_Nacimiento,'ID_Pais_Origen',NEW.ID_Pais_Origen),
            CONCAT('Nuevo soldado registrado: ', NEW.Nombre_Completo_Busqueda));
END */$$


DELIMITER ;

/* Trigger structure for table `soldado` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Soldado_Validacion_Fechas_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Soldado_Validacion_Fechas_BU` BEFORE UPDATE ON `soldado` FOR EACH ROW 
BEGIN
    IF NEW.Fecha_Muerte IS NOT NULL AND NEW.Fecha_Nacimiento IS NOT NULL AND NEW.Fecha_Muerte < NEW.Fecha_Nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Soldado BU]: La fecha de muerte no puede ser anterior a la fecha de nacimiento.';
    END IF;
    IF NEW.Fecha_Nacimiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Soldado BU]: La fecha de nacimiento no puede ser en el futuro.';
    END IF;
    IF NEW.Fecha_Muerte IS NOT NULL AND NEW.Fecha_Muerte > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Soldado BU]: La fecha de muerte no puede ser en el futuro.';
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Auditoria_Soldado_AU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Auditoria_Soldado_AU` AFTER UPDATE ON `soldado` FOR EACH ROW 
BEGIN
    IF OLD.Nombres != NEW.Nombres OR OLD.Apellidos != NEW.Apellidos OR OLD.Fecha_Nacimiento != NEW.Fecha_Nacimiento OR OLD.Fecha_Muerte <=> NEW.Fecha_Muerte OR OLD.ID_Causa_Muerte <=> NEW.ID_Causa_Muerte THEN
        INSERT INTO `Auditoria_Cambios` (`Nombre_Tabla_Afectada`, `ID_Registro_Afectado_PK1`, `Correo_Usuario_Responsable`, `Tipo_Operacion_Realizada`, `Valores_Originales_Registro`, `Valores_Nuevos_Registro`, `Descripcion_Adicional_Cambio`)
        VALUES ('Soldado', CAST(OLD.ID_Soldado AS CHAR), COALESCE(@current_user_email, SUBSTRING_INDEX(USER(),'@',1)), 'UPDATE',
                JSON_OBJECT('Nombres',OLD.Nombres,'Apellidos',OLD.Apellidos,'Fecha_Nacimiento',OLD.Fecha_Nacimiento,'Fecha_Muerte',OLD.Fecha_Muerte,'ID_Causa_Muerte',OLD.ID_Causa_Muerte),
                JSON_OBJECT('Nombres',NEW.Nombres,'Apellidos',NEW.Apellidos,'Fecha_Nacimiento',NEW.Fecha_Nacimiento,'Fecha_Muerte',NEW.Fecha_Muerte,'ID_Causa_Muerte',NEW.ID_Causa_Muerte),
                CONCAT('Actualización datos soldado: ', NEW.Nombre_Completo_Busqueda));
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Auditoria_Soldado_AD` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Auditoria_Soldado_AD` AFTER DELETE ON `soldado` FOR EACH ROW 
BEGIN
    INSERT INTO `Auditoria_Cambios` (`Nombre_Tabla_Afectada`, `ID_Registro_Afectado_PK1`, `Correo_Usuario_Responsable`, `Tipo_Operacion_Realizada`, `Valores_Originales_Registro`, `Descripcion_Adicional_Cambio`)
    VALUES ('Soldado', CAST(OLD.ID_Soldado AS CHAR), COALESCE(@current_user_email, SUBSTRING_INDEX(USER(),'@',1)), 'DELETE',
            JSON_OBJECT('ID_Soldado',OLD.ID_Soldado,'Nombre_Completo_Busqueda',OLD.Nombre_Completo_Busqueda,'Fecha_Nacimiento',OLD.Fecha_Nacimiento),
            CONCAT('Soldado eliminado: ', OLD.Nombre_Completo_Busqueda));
END */$$


DELIMITER ;

/* Trigger structure for table `soldado_ascenso` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Gestion_Periodo_Ascenso_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Gestion_Periodo_Ascenso_BI` BEFORE INSERT ON `soldado_ascenso` FOR EACH ROW 
BEGIN
    DECLARE v_fecha_nacimiento DATE;
    DECLARE v_fecha_muerte DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_fecha_nacimiento, v_fecha_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado;

    IF NEW.Fecha_Inicio_Rango < v_fecha_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BI]: La fecha de inicio del rango no puede ser anterior a la fecha de nacimiento del soldado.';
    END IF;
    IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Inicio_Rango > v_fecha_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BI]: La fecha de inicio del rango no puede ser posterior a la fecha de muerte del soldado.';
    END IF;
    IF NEW.Fecha_Fin_Rango IS NOT NULL THEN
        IF NEW.Fecha_Fin_Rango < NEW.Fecha_Inicio_Rango THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BI]: La fecha de fin de rango no puede ser anterior a la fecha de inicio del rango.';
        END IF;
        IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Fin_Rango > v_fecha_muerte THEN
            SET NEW.Fecha_Fin_Rango = v_fecha_muerte; 
        END IF;
    END IF;

    IF NEW.Fecha_Fin_Rango IS NULL THEN
        UPDATE `Soldado_Ascenso`
        SET `Fecha_Fin_Rango` = DATE_SUB(NEW.Fecha_Inicio_Rango, INTERVAL 1 DAY)
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `Fecha_Fin_Rango` IS NULL
          AND `ID_Rango` != NEW.ID_Rango 
          AND `Fecha_Inicio_Rango` < NEW.Fecha_Inicio_Rango;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado_ascenso` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Gestion_Periodo_Ascenso_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Gestion_Periodo_Ascenso_BU` BEFORE UPDATE ON `soldado_ascenso` FOR EACH ROW 
BEGIN
    DECLARE v_fecha_nacimiento DATE;
    DECLARE v_fecha_muerte DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_fecha_nacimiento, v_fecha_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado;

    IF NEW.Fecha_Inicio_Rango < v_fecha_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BU]: La fecha de inicio del rango no puede ser anterior a la fecha de nacimiento.';
    END IF;
    IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Inicio_Rango > v_fecha_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BU]: La fecha de inicio del rango no puede ser posterior a la fecha de muerte.';
    END IF;
    IF NEW.Fecha_Fin_Rango IS NOT NULL THEN
        IF NEW.Fecha_Fin_Rango < NEW.Fecha_Inicio_Rango THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BU]: La fecha de fin de rango no puede ser anterior a la fecha de inicio.';
        END IF;
        IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Fin_Rango > v_fecha_muerte THEN
            SET NEW.Fecha_Fin_Rango = v_fecha_muerte;
        END IF;
    END IF;

    IF NEW.Fecha_Fin_Rango IS NULL AND OLD.Fecha_Fin_Rango IS NOT NULL THEN
        UPDATE `Soldado_Ascenso`
        SET `Fecha_Fin_Rango` = DATE_SUB(NEW.Fecha_Inicio_Rango, INTERVAL 1 DAY)
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `Fecha_Fin_Rango` IS NULL
          AND `ID_Soldado_Ascenso` != NEW.ID_Soldado_Ascenso
          AND `Fecha_Inicio_Rango` < NEW.Fecha_Inicio_Rango;
    END IF;
    
    -- Prevenir solapamientos con otros registros para el mismo soldado
    IF EXISTS (
        SELECT 1 FROM `Soldado_Ascenso`
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `ID_Soldado_Ascenso` != NEW.ID_Soldado_Ascenso -- Excluir el registro actual
          AND NEW.Fecha_Inicio_Rango < COALESCE(`Fecha_Fin_Rango`, '9999-12-31')
          AND COALESCE(NEW.Fecha_Fin_Rango, '9999-12-31') > `Fecha_Inicio_Rango`
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Ascenso BU]: El periodo del rango se solapa con otro rango existente para este soldado.';
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado_pertenencia_unidad` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Gestion_Periodo_Pertenencia_Unidad_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Gestion_Periodo_Pertenencia_Unidad_BI` BEFORE INSERT ON `soldado_pertenencia_unidad` FOR EACH ROW 
BEGIN
    DECLARE v_fecha_nacimiento DATE;
    DECLARE v_fecha_muerte DATE;
    DECLARE v_unidad_creacion DATE;
    DECLARE v_unidad_disolucion DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_fecha_nacimiento, v_fecha_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado;
    SELECT Fecha_Activacion_Unidad, Fecha_Desactivacion_Unidad INTO v_unidad_creacion, v_unidad_disolucion FROM `Unidad_Militar` WHERE `ID_Unidad` = NEW.ID_Unidad;

    IF NEW.Fecha_Inicio_Pertenencia_Unidad < v_fecha_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BI]: Fecha de inicio de pertenencia no puede ser anterior al nacimiento del soldado.';
    END IF;
    IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Inicio_Pertenencia_Unidad > v_fecha_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BI]: Fecha de inicio de pertenencia no puede ser posterior a la muerte del soldado.';
    END IF;
    IF v_unidad_creacion IS NOT NULL AND NEW.Fecha_Inicio_Pertenencia_Unidad < v_unidad_creacion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BI]: Fecha de inicio de pertenencia no puede ser anterior a la activación de la unidad.';
    END IF;

    IF NEW.Fecha_Fin_Pertenencia_Unidad IS NOT NULL THEN
        IF NEW.Fecha_Fin_Pertenencia_Unidad < NEW.Fecha_Inicio_Pertenencia_Unidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BI]: Fecha fin de pertenencia no puede ser anterior a fecha inicio.';
        END IF;
        IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Fin_Pertenencia_Unidad > v_fecha_muerte THEN
            SET NEW.Fecha_Fin_Pertenencia_Unidad = v_fecha_muerte;
        END IF;
        IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Fin_Pertenencia_Unidad > v_unidad_disolucion THEN
             SET NEW.Fecha_Fin_Pertenencia_Unidad = v_unidad_disolucion;
        END IF;
    END IF;

    IF NEW.Fecha_Fin_Pertenencia_Unidad IS NULL THEN
        UPDATE `Soldado_Pertenencia_Unidad`
        SET `Fecha_Fin_Pertenencia_Unidad` = DATE_SUB(NEW.Fecha_Inicio_Pertenencia_Unidad, INTERVAL 1 DAY)
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `Fecha_Fin_Pertenencia_Unidad` IS NULL
          AND `ID_Unidad` != NEW.ID_Unidad 
          AND `Fecha_Inicio_Pertenencia_Unidad` < NEW.Fecha_Inicio_Pertenencia_Unidad;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `soldado_pertenencia_unidad` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Gestion_Periodo_Pertenencia_Unidad_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Gestion_Periodo_Pertenencia_Unidad_BU` BEFORE UPDATE ON `soldado_pertenencia_unidad` FOR EACH ROW 
BEGIN
    DECLARE v_fecha_nacimiento DATE;
    DECLARE v_fecha_muerte DATE;
    DECLARE v_unidad_creacion DATE;
    DECLARE v_unidad_disolucion DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_fecha_nacimiento, v_fecha_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado;
    SELECT Fecha_Activacion_Unidad, Fecha_Desactivacion_Unidad INTO v_unidad_creacion, v_unidad_disolucion FROM `Unidad_Militar` WHERE `ID_Unidad` = NEW.ID_Unidad;

    IF NEW.Fecha_Inicio_Pertenencia_Unidad < v_fecha_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BU]: Fecha de inicio no puede ser anterior al nacimiento.';
    END IF;
    IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Inicio_Pertenencia_Unidad > v_fecha_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BU]: Fecha de inicio no puede ser posterior a la muerte.';
    END IF;
    IF v_unidad_creacion IS NOT NULL AND NEW.Fecha_Inicio_Pertenencia_Unidad < v_unidad_creacion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BU]: Fecha de inicio no puede ser anterior a la activación de la unidad.';
    END IF;

    IF NEW.Fecha_Fin_Pertenencia_Unidad IS NOT NULL THEN
        IF NEW.Fecha_Fin_Pertenencia_Unidad < NEW.Fecha_Inicio_Pertenencia_Unidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BU]: Fecha fin no puede ser anterior a fecha inicio.';
        END IF;
        IF v_fecha_muerte IS NOT NULL AND NEW.Fecha_Fin_Pertenencia_Unidad > v_fecha_muerte THEN
            SET NEW.Fecha_Fin_Pertenencia_Unidad = v_fecha_muerte;
        END IF;
        IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Fin_Pertenencia_Unidad > v_unidad_disolucion THEN
             SET NEW.Fecha_Fin_Pertenencia_Unidad = v_unidad_disolucion;
        END IF;
    END IF;

    IF NEW.Fecha_Fin_Pertenencia_Unidad IS NULL AND OLD.Fecha_Fin_Pertenencia_Unidad IS NOT NULL THEN
        UPDATE `Soldado_Pertenencia_Unidad`
        SET `Fecha_Fin_Pertenencia_Unidad` = DATE_SUB(NEW.Fecha_Inicio_Pertenencia_Unidad, INTERVAL 1 DAY)
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `Fecha_Fin_Pertenencia_Unidad` IS NULL
          AND `ID_Pertenencia` != NEW.ID_Pertenencia
          AND `Fecha_Inicio_Pertenencia_Unidad` < NEW.Fecha_Inicio_Pertenencia_Unidad;
    END IF;

    IF EXISTS (
        SELECT 1 FROM `Soldado_Pertenencia_Unidad`
        WHERE `ID_Soldado` = NEW.ID_Soldado
          AND `ID_Pertenencia` != NEW.ID_Pertenencia
          AND NEW.Fecha_Inicio_Pertenencia_Unidad < COALESCE(`Fecha_Fin_Pertenencia_Unidad`, '9999-12-31')
          AND COALESCE(NEW.Fecha_Fin_Pertenencia_Unidad, '9999-12-31') > `Fecha_Inicio_Pertenencia_Unidad`
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Pertenencia BU]: El periodo de pertenencia se solapa con otro existente para este soldado.';
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `unidad_militar` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Unidad_Militar_No_Auto_Superior_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Unidad_Militar_No_Auto_Superior_BU` BEFORE UPDATE ON `unidad_militar` FOR EACH ROW 
BEGIN
    IF NEW.ID_Unidad_Superior_Directa IS NOT NULL AND NEW.ID_Unidad_Superior_Directa = NEW.ID_Unidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Unidad Militar BU]: Una unidad militar no puede ser su propia unidad superior directa.';
    END IF;
    -- Prevenir ciclos (A->B y B->A) es más complejo. Se puede hacer con un SP o en la aplicación.
    -- Una forma básica sería chequear si NEW.ID_Unidad es superior de NEW.ID_Unidad_Superior_Directa.
    -- DECLARE v_es_superior_de_su_superior INT DEFAULT 0;
    -- IF NEW.ID_Unidad_Superior_Directa IS NOT NULL THEN
    --    SELECT 1 INTO v_es_superior_de_su_superior FROM `Unidad_Militar` WHERE `ID_Unidad` = NEW.ID_Unidad_Superior_Directa AND `ID_Unidad_Superior_Directa` = NEW.ID_Unidad;
    --    IF v_es_superior_de_su_superior = 1 THEN
    --        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Unidad Militar BU]: Ciclo detectado en la jerarquía de unidades.';
    --    END IF;
    -- END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `unidad_militar_comandante` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Unidad_Militar_Comandante_Fechas_BI` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Unidad_Militar_Comandante_Fechas_BI` BEFORE INSERT ON `unidad_militar_comandante` FOR EACH ROW 
BEGIN
    DECLARE v_soldado_nacimiento DATE;
    DECLARE v_soldado_muerte DATE;
    DECLARE v_unidad_creacion DATE;
    DECLARE v_unidad_disolucion DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_soldado_nacimiento, v_soldado_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado_Comandante;
    SELECT Fecha_Activacion_Unidad, Fecha_Desactivacion_Unidad INTO v_unidad_creacion, v_unidad_disolucion FROM `Unidad_Militar` WHERE `ID_Unidad` = NEW.ID_Unidad_Comandada;

    IF NEW.Fecha_Inicio_Comando_Unidad < v_soldado_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BI]: Fecha de inicio de comando no puede ser anterior al nacimiento del comandante.';
    END IF;
    IF v_soldado_muerte IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad > v_soldado_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BI]: Fecha de inicio de comando no puede ser posterior a la muerte del comandante.';
    END IF;
    IF v_unidad_creacion IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad < v_unidad_creacion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BI]: Fecha de inicio de comando no puede ser anterior a la activación de la unidad.';
    END IF;
    
    IF NEW.Fecha_Fin_Comando_Unidad IS NOT NULL THEN
        IF NEW.Fecha_Fin_Comando_Unidad < NEW.Fecha_Inicio_Comando_Unidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BI]: Fecha fin de comando no puede ser anterior a fecha inicio.';
        END IF;
        IF v_soldado_muerte IS NOT NULL AND NEW.Fecha_Fin_Comando_Unidad > v_soldado_muerte THEN
            SET NEW.Fecha_Fin_Comando_Unidad = v_soldado_muerte;
        END IF;
        IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Fin_Comando_Unidad > v_unidad_disolucion THEN
            SET NEW.Fecha_Fin_Comando_Unidad = v_unidad_disolucion;
        END IF;
    ELSE 
        IF v_soldado_muerte IS NOT NULL THEN 
             SET NEW.Fecha_Fin_Comando_Unidad = v_soldado_muerte;
        ELSEIF v_unidad_disolucion IS NOT NULL THEN 
             SET NEW.Fecha_Fin_Comando_Unidad = v_unidad_disolucion;
        END IF;
    END IF;
    
    IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad > v_unidad_disolucion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BI]: Fecha de inicio de comando no puede ser posterior a la desactivación de la unidad.';
    END IF;

    IF NEW.Fecha_Fin_Comando_Unidad IS NULL THEN
        UPDATE `Unidad_Militar_Comandante`
        SET `Fecha_Fin_Comando_Unidad` = DATE_SUB(NEW.Fecha_Inicio_Comando_Unidad, INTERVAL 1 DAY)
        WHERE `ID_Unidad_Comandada` = NEW.ID_Unidad_Comandada
          AND `Fecha_Fin_Comando_Unidad` IS NULL
          AND `ID_Soldado_Comandante` != NEW.ID_Soldado_Comandante
          AND `Fecha_Inicio_Comando_Unidad` < NEW.Fecha_Inicio_Comando_Unidad;
    END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `unidad_militar_comandante` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `TRG_Unidad_Militar_Comandante_Fechas_BU` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `TRG_Unidad_Militar_Comandante_Fechas_BU` BEFORE UPDATE ON `unidad_militar_comandante` FOR EACH ROW 
BEGIN
    DECLARE v_soldado_nacimiento DATE;
    DECLARE v_soldado_muerte DATE;
    DECLARE v_unidad_creacion DATE;
    DECLARE v_unidad_disolucion DATE;

    SELECT Fecha_Nacimiento, Fecha_Muerte INTO v_soldado_nacimiento, v_soldado_muerte FROM `Soldado` WHERE `ID_Soldado` = NEW.ID_Soldado_Comandante;
    SELECT Fecha_Activacion_Unidad, Fecha_Desactivacion_Unidad INTO v_unidad_creacion, v_unidad_disolucion FROM `Unidad_Militar` WHERE `ID_Unidad` = NEW.ID_Unidad_Comandada;

    IF NEW.Fecha_Inicio_Comando_Unidad < v_soldado_nacimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: Fecha de inicio de comando no puede ser anterior al nacimiento del comandante.';
    END IF;
    IF v_soldado_muerte IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad > v_soldado_muerte THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: Fecha de inicio de comando no puede ser posterior a la muerte del comandante.';
    END IF;
    IF v_unidad_creacion IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad < v_unidad_creacion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: Fecha de inicio de comando no puede ser anterior a la activación de la unidad.';
    END IF;
    
    IF NEW.Fecha_Fin_Comando_Unidad IS NOT NULL THEN
        IF NEW.Fecha_Fin_Comando_Unidad < NEW.Fecha_Inicio_Comando_Unidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: Fecha fin de comando no puede ser anterior a fecha inicio.';
        END IF;
        IF v_soldado_muerte IS NOT NULL AND NEW.Fecha_Fin_Comando_Unidad > v_soldado_muerte THEN
            SET NEW.Fecha_Fin_Comando_Unidad = v_soldado_muerte;
        END IF;
        IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Fin_Comando_Unidad > v_unidad_disolucion THEN
            SET NEW.Fecha_Fin_Comando_Unidad = v_unidad_disolucion;
        END IF;
    ELSE 
        IF v_soldado_muerte IS NOT NULL THEN 
             SET NEW.Fecha_Fin_Comando_Unidad = v_soldado_muerte;
        ELSEIF v_unidad_disolucion IS NOT NULL THEN 
             SET NEW.Fecha_Fin_Comando_Unidad = v_unidad_disolucion;
        END IF;
    END IF;
    
    IF v_unidad_disolucion IS NOT NULL AND NEW.Fecha_Inicio_Comando_Unidad > v_unidad_disolucion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: Fecha de inicio de comando no puede ser posterior a la desactivación de la unidad.';
    END IF;

    IF NEW.Fecha_Fin_Comando_Unidad IS NULL AND OLD.Fecha_Fin_Comando_Unidad IS NOT NULL THEN
        UPDATE `Unidad_Militar_Comandante`
        SET `Fecha_Fin_Comando_Unidad` = DATE_SUB(NEW.Fecha_Inicio_Comando_Unidad, INTERVAL 1 DAY)
        WHERE `ID_Unidad_Comandada` = NEW.ID_Unidad_Comandada
          AND `Fecha_Fin_Comando_Unidad` IS NULL
          AND `ID_Comandancia` != NEW.ID_Comandancia
          AND `Fecha_Inicio_Comando_Unidad` < NEW.Fecha_Inicio_Comando_Unidad;
    END IF;

    IF EXISTS (
        SELECT 1 FROM `Unidad_Militar_Comandante`
        WHERE `ID_Unidad_Comandada` = NEW.ID_Unidad_Comandada
          AND `ID_Comandancia` != NEW.ID_Comandancia
          AND NEW.Fecha_Inicio_Comando_Unidad < COALESCE(`Fecha_Fin_Comando_Unidad`, '9999-12-31')
          AND COALESCE(NEW.Fecha_Fin_Comando_Unidad, '9999-12-31') > `Fecha_Inicio_Comando_Unidad`
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error [Comandante BU]: El periodo de comando se solapa con otro existente para esta unidad.';
    END IF;
END */$$


DELIMITER ;

/* Procedure structure for procedure `SP_Buscar_Soldados_Avanzado` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_Buscar_Soldados_Avanzado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Buscar_Soldados_Avanzado`(
    IN p_Termino_Nombre VARCHAR(255), IN p_ID_Pais_Origen INT, IN p_ID_Rama_Ejercito INT, IN p_ID_Rango_Ostentado INT,
    IN p_ID_Unidad_Pertenecio INT, IN p_Anio_Nacimiento_Desde INT, IN p_Anio_Nacimiento_Hasta INT,
    IN p_Anio_Muerte_Desde INT, IN p_Anio_Muerte_Hasta INT, IN p_ID_Batalla_Participo INT, IN p_ID_Medalla_Obtenida INT,
    IN p_Limit INT, IN p_Offset INT
)
BEGIN
    SET @sql_query = 'SELECT DISTINCT S.* FROM `V_Soldado_Informacion_Completa` S ';
    SET @joins = '';
    SET @conditions = 'WHERE 1=1 ';

    IF p_ID_Rango_Ostentado IS NOT NULL THEN
        SET @joins = CONCAT(@joins, 'LEFT JOIN `Soldado_Ascenso` SA ON S.ID_Soldado = SA.ID_Soldado ');
        SET @conditions = CONCAT(@conditions, 'AND SA.ID_Rango = ', p_ID_Rango_Ostentado, ' ');
    END IF;
    IF p_ID_Unidad_Pertenecio IS NOT NULL THEN
        SET @joins = CONCAT(@joins, 'LEFT JOIN `Soldado_Pertenencia_Unidad` SPU ON S.ID_Soldado = SPU.ID_Soldado ');
        SET @conditions = CONCAT(@conditions, 'AND SPU.ID_Unidad = ', p_ID_Unidad_Pertenecio, ' ');
    END IF;
    IF p_ID_Batalla_Participo IS NOT NULL THEN
        SET @joins = CONCAT(@joins, 'LEFT JOIN `Soldado_Participacion_Batalla` SPB ON S.ID_Soldado = SPB.ID_Soldado ');
        SET @conditions = CONCAT(@conditions, 'AND SPB.ID_Batalla = ', p_ID_Batalla_Participo, ' ');
    END IF;
    IF p_ID_Medalla_Obtenida IS NOT NULL THEN
        SET @joins = CONCAT(@joins, 'LEFT JOIN `Soldado_Medalla` SM ON S.ID_Soldado = SM.ID_Soldado ');
        SET @conditions = CONCAT(@conditions, 'AND SM.ID_Medalla = ', p_ID_Medalla_Obtenida, ' ');
    END IF;

    IF p_Termino_Nombre IS NOT NULL AND p_Termino_Nombre != '' THEN
        SET @conditions = CONCAT(@conditions, 'AND S.Nombre_Completo_Busqueda LIKE ''%', p_Termino_Nombre, '%'' '); END IF;
    IF p_ID_Pais_Origen IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND S.Pais_Origen_Nombre = (SELECT Nombre_Pais FROM `Pais` WHERE `ID_Pais` = ', p_ID_Pais_Origen, ') '); END IF;
    IF p_ID_Rama_Ejercito IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND S.Rama_Ejercito_Nombre = (SELECT Nombre_Rama FROM `Rama_Ejercito` WHERE `ID_Rama_Ejercito` = ', p_ID_Rama_Ejercito, ') '); END IF;
    IF p_Anio_Nacimiento_Desde IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND YEAR(S.Fecha_Nacimiento) >= ', p_Anio_Nacimiento_Desde, ' '); END IF;
    IF p_Anio_Nacimiento_Hasta IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND YEAR(S.Fecha_Nacimiento) <= ', p_Anio_Nacimiento_Hasta, ' '); END IF;
    IF p_Anio_Muerte_Desde IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND (S.Fecha_Muerte IS NULL OR YEAR(S.Fecha_Muerte) >= ', p_Anio_Muerte_Desde, ') '); END IF;
    IF p_Anio_Muerte_Hasta IS NOT NULL THEN
        SET @conditions = CONCAT(@conditions, 'AND (S.Fecha_Muerte IS NULL OR YEAR(S.Fecha_Muerte) <= ', p_Anio_Muerte_Hasta, ') '); END IF;

    SET @sql_query = CONCAT(@sql_query, @joins, @conditions, 'ORDER BY S.Apellidos, S.Nombres ');
    IF p_Limit IS NOT NULL AND p_Offset IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, 'LIMIT ', p_Offset, ', ', p_Limit);
    ELSEIF p_Limit IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, 'LIMIT ', p_Limit);
    END IF;
    
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_Gestionar_Usuario_Sistema` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_Gestionar_Usuario_Sistema` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Gestionar_Usuario_Sistema`(
    IN p_Accion ENUM('REGISTRAR', 'ACTUALIZAR_PERFIL', 'CAMBIAR_PASSWORD', 'VERIFICAR_EMAIL', 'SOLICITAR_RESETEO', 'RESETEAR_PASSWORD', 'ACTUALIZAR_ESTADO'),
    IN p_Correo_Electronico VARCHAR(255),
    IN p_Nombres_Usuario VARCHAR(150),
    IN p_Apellidos_Usuario VARCHAR(150),
    IN p_ID_Pais_Origen_Usuario INT,
    IN p_Password_Actual VARCHAR(255), -- Usado para CAMBIAR_PASSWORD
    IN p_Password_Nuevo VARCHAR(255),  -- Usado para REGISTRAR, CAMBIAR_PASSWORD, RESETEAR_PASSWORD
    IN p_Rol_Usuario_Sistema ENUM('Administrador Global', 'Administrador Contenido', 'Investigador Senior', 'Colaborador Verificado', 'Consultor Registrado', 'Consultor Anónimo'),
    IN p_Estado_Cuenta_Usuario ENUM('Activo', 'Inactivo', 'Suspendido', 'Pendiente Verificacion Email', 'Bloqueado'),
    IN p_Token VARCHAR(100), -- Usado para VERIFICAR_EMAIL, RESETEAR_PASSWORD
    OUT p_Mensaje_Resultado VARCHAR(512),
    OUT p_Exito BOOLEAN
)
BEGIN
    DECLARE v_Password_Hash VARCHAR(255);
    DECLARE v_Usuario_Existe BOOLEAN DEFAULT FALSE;
    DECLARE v_Token_Valido BOOLEAN DEFAULT FALSE;
    DECLARE v_Correo_Verificado VARCHAR(255);

    SET p_Exito = FALSE;

    SELECT TRUE INTO v_Usuario_Existe FROM `Usuario_Sistema` WHERE `Correo_Electronico` = p_Correo_Electronico;

    CASE p_Accion
        WHEN 'REGISTRAR' THEN
            IF v_Usuario_Existe THEN
                SET p_Mensaje_Resultado = 'Error: El correo electrónico ya está registrado.';
            ELSEIF p_Password_Nuevo IS NULL OR LENGTH(p_Password_Nuevo) < 8 THEN
                 SET p_Mensaje_Resultado = 'Error: La contraseña debe tener al menos 8 caracteres.';
            ELSE
                -- En una aplicación real, aquí se generaría un hash seguro para p_Password_Nuevo
                SET v_Password_Hash = PASSWORD(p_Password_Nuevo); -- Placeholder, usar bcrypt o Argon2
                SET @v_Token_Verificacion = UUID();
                INSERT INTO `Usuario_Sistema` (`Correo_Electronico`, `Nombres_Usuario`, `Apellidos_Usuario`, `ID_Pais_Origen_Usuario`, `Password_Hash_Usuario`, `Rol_Usuario_Sistema`, `Estado_Cuenta_Usuario`, `Token_Verificacion_Email`, `Fecha_Expiracion_Token_Verificacion`)
                VALUES (p_Correo_Electronico, p_Nombres_Usuario, p_Apellidos_Usuario, p_ID_Pais_Origen_Usuario, v_Password_Hash, COALESCE(p_Rol_Usuario_Sistema, 'Consultor Registrado'), 'Pendiente Verificacion Email', @v_Token_Verificacion, NOW() + INTERVAL 1 DAY);
                SET p_Mensaje_Resultado = CONCAT('Usuario registrado. Se ha enviado un correo de verificación a ', p_Correo_Electronico, '. Token: ', @v_Token_Verificacion);
                SET p_Exito = TRUE;
                -- Aquí se enviaría el email con el token de verificación.
            END IF;

        WHEN 'VERIFICAR_EMAIL' THEN
            SELECT `Correo_Electronico` INTO v_Correo_Verificado FROM `Usuario_Sistema`
            WHERE `Token_Verificacion_Email` = p_Token AND `Fecha_Expiracion_Token_Verificacion` > NOW() AND `Estado_Cuenta_Usuario` = 'Pendiente Verificacion Email';
            IF v_Correo_Verificado IS NOT NULL THEN
                UPDATE `Usuario_Sistema` SET `Estado_Cuenta_Usuario` = 'Activo', `Token_Verificacion_Email` = NULL, `Fecha_Expiracion_Token_Verificacion` = NULL
                WHERE `Correo_Electronico` = v_Correo_Verificado;
                SET p_Mensaje_Resultado = 'Correo electrónico verificado exitosamente. Ya puede iniciar sesión.';
                SET p_Exito = TRUE;
            ELSE
                SET p_Mensaje_Resultado = 'Error: Token de verificación inválido o expirado.';
            END IF;
        
        -- Otros casos como ACTUALIZAR_PERFIL, CAMBIAR_PASSWORD, etc. seguirían una lógica similar.
        -- Por brevedad, no se implementan todos aquí.
        ELSE
            SET p_Mensaje_Resultado = 'Acción no reconocida.';
    END CASE;
END */$$
DELIMITER ;

/* Procedure structure for procedure `SP_Obtener_Linea_Tiempo_Soldado` */

/*!50003 DROP PROCEDURE IF EXISTS  `SP_Obtener_Linea_Tiempo_Soldado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Obtener_Linea_Tiempo_Soldado`(IN p_ID_Soldado INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM `Soldado` WHERE `ID_Soldado` = p_ID_Soldado) THEN
        SELECT 'Error: El soldado especificado no existe.' AS Mensaje_Error;
    ELSE
        SELECT VLT.Fecha_Evento, VLT.Tipo_Evento, VLT.Descripcion_Detallada_Evento, VLT.ID_Registro_Relacionado,
               L.Nombre_Lugar AS Nombre_Lugar_Evento, P.Nombre_Pais AS Nombre_Pais_Evento
        FROM `V_Linea_Tiempo_Eventos_Soldado` VLT
        LEFT JOIN `Lugar` L ON VLT.ID_Lugar_Evento = L.ID_Lugar
        LEFT JOIN `Pais` P ON L.ID_Pais = P.ID_Pais
        WHERE VLT.ID_Soldado = p_ID_Soldado
        ORDER BY VLT.Fecha_Evento ASC, VLT.Orden_Tipo_Evento ASC;
    END IF;
END */$$
DELIMITER ;

/*Table structure for table `v_estadisticas_bajas_por_batalla` */

DROP TABLE IF EXISTS `v_estadisticas_bajas_por_batalla`;

/*!50001 DROP VIEW IF EXISTS `v_estadisticas_bajas_por_batalla` */;
/*!50001 DROP TABLE IF EXISTS `v_estadisticas_bajas_por_batalla` */;

/*!50001 CREATE TABLE  `v_estadisticas_bajas_por_batalla`(
 `ID_Batalla` int(11) ,
 `Nombre_Batalla` varchar(255) ,
 `Pais_Donde_Ocurrio_Batalla` varchar(100) ,
 `Fecha_Inicio_Batalla` date ,
 `Fecha_Fin_Batalla` date ,
 `Numero_Participantes_Registrados_Sistema` bigint(21) ,
 `Bajas_En_Combate_Registradas_Sistema` decimal(22,0) ,
 `Heridos_Registrados_Sistema` decimal(22,0) ,
 `Prisioneros_Registrados_Sistema` decimal(22,0) ,
 `Desaparecidos_Registrados_Sistema` decimal(22,0) ,
 `Bajas_Totales_Estimadas_Eje_Historicas` int(11) ,
 `Bajas_Totales_Estimadas_Aliados_Historicas` int(11) 
)*/;

/*Table structure for table `v_estadisticas_soldados_por_pais_origen` */

DROP TABLE IF EXISTS `v_estadisticas_soldados_por_pais_origen`;

/*!50001 DROP VIEW IF EXISTS `v_estadisticas_soldados_por_pais_origen` */;
/*!50001 DROP TABLE IF EXISTS `v_estadisticas_soldados_por_pais_origen` */;

/*!50001 CREATE TABLE  `v_estadisticas_soldados_por_pais_origen`(
 `Pais_Origen` varchar(100) ,
 `Codigo_Pais_ISO2` char(2) ,
 `Numero_Total_Soldados_Registrados` bigint(21) ,
 `Numero_Soldados_Caidos_Confirmados` decimal(22,0) ,
 `Edad_Promedio_Al_Morir_Anios` decimal(22,1) 
)*/;

/*Table structure for table `v_informacion_inhumacion_presentacion` */

DROP TABLE IF EXISTS `v_informacion_inhumacion_presentacion`;

/*!50001 DROP VIEW IF EXISTS `v_informacion_inhumacion_presentacion` */;
/*!50001 DROP TABLE IF EXISTS `v_informacion_inhumacion_presentacion` */;

/*!50001 CREATE TABLE  `v_informacion_inhumacion_presentacion`(
 `ID_Soldado` int(11) ,
 `Nombre_Soldado` varchar(402) ,
 `Inhumacion_Es_Desconocida_Flag` int(4) ,
 `Tipo_Sitio_Inhumacion` enum('Tumba Individual','Fosa Común','Memorial (Sin Restos)','Cenotafio','Desconocido','Perdido en Mar/Aire') ,
 `Pais_Referencia_Inhumacion_Nombre` varchar(100) ,
 `Lugar_Referencia_Inhumacion_Nombre` varchar(255) ,
 `Nombre_Cementerio_O_Memorial` varchar(255) ,
 `Ubicacion_Exacta_Tumba_En_Sitio` varchar(255) ,
 `Anotacion_Sobre_Inhumacion` mediumtext ,
 `Coordenadas_Sitio_Lat` decimal(10,8) ,
 `Coordenadas_Sitio_Lon` decimal(11,8) ,
 `Fotografia_Tumba_URL` varchar(2048) ,
 `Fecha_Muerte_Soldado_Contexto` date ,
 `Lugar_Muerte_Si_Inhumacion_Desconocida_Contexto` varchar(255) 
)*/;

/*Table structure for table `v_linea_tiempo_eventos_soldado` */

DROP TABLE IF EXISTS `v_linea_tiempo_eventos_soldado`;

/*!50001 DROP VIEW IF EXISTS `v_linea_tiempo_eventos_soldado` */;
/*!50001 DROP TABLE IF EXISTS `v_linea_tiempo_eventos_soldado` */;

/*!50001 CREATE TABLE  `v_linea_tiempo_eventos_soldado`(
 `ID_Soldado` int(11) ,
 `Nombre_Soldado` varchar(402) ,
 `Fecha_Evento` date ,
 `Orden_Tipo_Evento` int(1) ,
 `Tipo_Evento` varchar(27) ,
 `Descripcion_Detallada_Evento` mediumtext ,
 `ID_Registro_Relacionado` int(11) ,
 `ID_Lugar_Evento` int(11) 
)*/;

/*Table structure for table `v_soldado_informacion_completa` */

DROP TABLE IF EXISTS `v_soldado_informacion_completa`;

/*!50001 DROP VIEW IF EXISTS `v_soldado_informacion_completa` */;
/*!50001 DROP TABLE IF EXISTS `v_soldado_informacion_completa` */;

/*!50001 CREATE TABLE  `v_soldado_informacion_completa`(
 `ID_Soldado` int(11) ,
 `Nombres` varchar(150) ,
 `Patronimico` varchar(100) ,
 `Apellidos` varchar(150) ,
 `Nombre_Completo_Busqueda` varchar(402) ,
 `Sexo` enum('Masculino','Femenino','Desconocido') ,
 `Fecha_Nacimiento` date ,
 `Fecha_Nacimiento_Precision` enum('Exacta','Mes y Año','Solo Año','Aproximada') ,
 `Pais_Origen_Nombre` varchar(100) ,
 `Pais_Origen_ISO2` char(2) ,
 `Lugar_Nacimiento_Nombre` varchar(255) ,
 `Pais_Lugar_Nacimiento_Nombre` varchar(100) ,
 `Tipo_Lugar_Nacimiento` varchar(50) ,
 `Fecha_Muerte` date ,
 `Fecha_Muerte_Precision` enum('Exacta','Mes y Año','Solo Año','Aproximada','Declarado Muerto') ,
 `Lugar_Muerte_Nombre` varchar(255) ,
 `Pais_Lugar_Muerte_Nombre` varchar(100) ,
 `Tipo_Lugar_Muerte` varchar(50) ,
 `Causa_Muerte_Descripcion` varchar(255) ,
 `Categoria_Causa_Muerte` enum('Combate Directo','Consecuencia de Combate','Enfermedad','Accidente','Cautiverio/Prisión','Suicidio','Ejecución','Desconocida','Otra') ,
 `Rama_Ejercito_Nombre` varchar(100) ,
 `Rama_Ejercito_Siglas` varchar(20) ,
 `Numero_Identificacion_Militar` varchar(50) ,
 `Notas_Adicionales_Soldado` text ,
 `Fotografia_URL` varchar(2048) ,
 `Estado_Registro` enum('Verificado','Pendiente Verificacion','Incompleto','Disputado') ,
 `Fuente_Informacion_Principal` text ,
 `Fecha_Registro_Soldado_DB` timestamp ,
 `Ultima_Actualizacion_Soldado_DB` timestamp 
)*/;

/*Table structure for table `v_soldado_participacion_batallas_detallada` */

DROP TABLE IF EXISTS `v_soldado_participacion_batallas_detallada`;

/*!50001 DROP VIEW IF EXISTS `v_soldado_participacion_batallas_detallada` */;
/*!50001 DROP TABLE IF EXISTS `v_soldado_participacion_batallas_detallada` */;

/*!50001 CREATE TABLE  `v_soldado_participacion_batallas_detallada`(
 `ID_Participacion_Batalla` int(11) ,
 `ID_Soldado` int(11) ,
 `Nombre_Soldado` varchar(402) ,
 `ID_Batalla` int(11) ,
 `Nombre_Batalla` varchar(255) ,
 `Pais_Batalla` varchar(100) ,
 `Lugar_Especifico_Batalla_Nombre` varchar(255) ,
 `Fecha_Inicio_Batalla` date ,
 `Fecha_Fin_Batalla` date ,
 `Duracion_Total_Batalla_Dias` bigint(22) ,
 `Nombre_Oficial_Campana` varchar(255) ,
 `Nombre_Codigo_Operacion` varchar(255) ,
 `Unidad_Militar_En_Batalla_Nombre` varchar(255) ,
 `Tipo_Unidad_Militar_En_Batalla` enum('Grupo de Ejércitos','Ejército','Cuerpo de Ejército','División','Brigada','Regimiento','Batallón','Compañía','Batería','Pelotón','Escuadrón (Tierra)','Flota','Flotilla','Escuadrón (Naval)','Ala (Aérea)','Grupo (Aéreo)','Escuadrilla (Aérea)','Fuerza de Tarea','Destacamento','Otro') ,
 `Rol_O_Acciones_En_Batalla` varchar(255) ,
 `Estado_Soldado_Post_Batalla` enum('Ileso','Herido Leve','Herido Grave','Caído en Combate (KIA)','Prisionero de Guerra (POW)','Desaparecido en Acción (MIA)','Evacuado por Heridas','Otro') ,
 `Fecha_Inicio_Participacion_Batalla` date ,
 `Fecha_Fin_Participacion_Batalla` date ,
 `Notas_Participacion_Batalla` text 
)*/;

/*Table structure for table `v_soldado_rangos_actual_historial` */

DROP TABLE IF EXISTS `v_soldado_rangos_actual_historial`;

/*!50001 DROP VIEW IF EXISTS `v_soldado_rangos_actual_historial` */;
/*!50001 DROP TABLE IF EXISTS `v_soldado_rangos_actual_historial` */;

/*!50001 CREATE TABLE  `v_soldado_rangos_actual_historial`(
 `ID_Soldado_Ascenso` int(11) ,
 `ID_Soldado` int(11) ,
 `Nombre_Soldado` varchar(402) ,
 `Nombre_Rango` varchar(100) ,
 `Abreviatura_Rango` varchar(30) ,
 `Orden_Jerarquico` int(11) ,
 `Fecha_Inicio_Rango` date ,
 `Fecha_Fin_Rango` date ,
 `Estado_Rango_Interpretado` varchar(19) ,
 `Documento_Referencia_Ascenso` varchar(255) ,
 `Notas_Adicionales_Ascenso` text 
)*/;

/*Table structure for table `v_soldado_unidades_actual_historial` */

DROP TABLE IF EXISTS `v_soldado_unidades_actual_historial`;

/*!50001 DROP VIEW IF EXISTS `v_soldado_unidades_actual_historial` */;
/*!50001 DROP TABLE IF EXISTS `v_soldado_unidades_actual_historial` */;

/*!50001 CREATE TABLE  `v_soldado_unidades_actual_historial`(
 `ID_Pertenencia` int(11) ,
 `ID_Soldado` int(11) ,
 `Nombre_Soldado` varchar(402) ,
 `ID_Unidad` int(11) ,
 `Nombre_Unidad` varchar(255) ,
 `Tipo_Unidad` enum('Grupo de Ejércitos','Ejército','Cuerpo de Ejército','División','Brigada','Regimiento','Batallón','Compañía','Batería','Pelotón','Escuadrón (Tierra)','Flota','Flotilla','Escuadrón (Naval)','Ala (Aérea)','Grupo (Aéreo)','Escuadrilla (Aérea)','Fuerza de Tarea','Destacamento','Otro') ,
 `Pais_Afiliacion_Unidad` varchar(100) ,
 `Fecha_Inicio_Pertenencia_Unidad` date ,
 `Fecha_Fin_Pertenencia_Unidad` date ,
 `Estado_Pertenencia_Interpretado` varchar(20) ,
 `Rol_Desempenado_En_Unidad` varchar(100) ,
 `Notas_Sobre_Pertenencia` text 
)*/;

/*Table structure for table `v_unidad_militar_jerarquia_completa` */

DROP TABLE IF EXISTS `v_unidad_militar_jerarquia_completa`;

/*!50001 DROP VIEW IF EXISTS `v_unidad_militar_jerarquia_completa` */;
/*!50001 DROP TABLE IF EXISTS `v_unidad_militar_jerarquia_completa` */;

/*!50001 CREATE TABLE  `v_unidad_militar_jerarquia_completa`(
 `ID_Unidad` int(11) ,
 `Nombre_Unidad` varchar(255) ,
 `Tipo_Unidad` enum('Grupo de Ejércitos','Ejército','Cuerpo de Ejército','División','Brigada','Regimiento','Batallón','Compañía','Batería','Pelotón','Escuadrón (Tierra)','Flota','Flotilla','Escuadrón (Naval)','Ala (Aérea)','Grupo (Aéreo)','Escuadrilla (Aérea)','Fuerza de Tarea','Destacamento','Otro') ,
 `ID_Unidad_Superior` int(11) ,
 `Nombre_Unidad_Superior_Directa` varchar(255) ,
 `Nivel_Jerarquia` int(1) ,
 `Ruta_Jerarquia_Nombres` varchar(2000) ,
 `Ruta_Jerarquia_IDs` varchar(2000) ,
 `ID_Pais_Afiliacion_Unidad` int(11) ,
 `Pais_Afiliacion_Unidad_Nombre` varchar(100) ,
 `Fecha_Activacion_Unidad` date ,
 `Fecha_Desactivacion_Unidad` date ,
 `Especializacion_Unidad` varchar(150) 
)*/;

/*View structure for view v_estadisticas_bajas_por_batalla */

/*!50001 DROP TABLE IF EXISTS `v_estadisticas_bajas_por_batalla` */;
/*!50001 DROP VIEW IF EXISTS `v_estadisticas_bajas_por_batalla` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_estadisticas_bajas_por_batalla` AS select `b`.`ID_Batalla` AS `ID_Batalla`,`b`.`Nombre_Batalla` AS `Nombre_Batalla`,`p`.`Nombre_Pais` AS `Pais_Donde_Ocurrio_Batalla`,`b`.`Fecha_Inicio_Batalla` AS `Fecha_Inicio_Batalla`,`b`.`Fecha_Fin_Batalla` AS `Fecha_Fin_Batalla`,count(distinct `spb`.`ID_Soldado`) AS `Numero_Participantes_Registrados_Sistema`,sum(case when `spb`.`Estado_Soldado_Post_Batalla` = 'Caído en Combate (KIA)' then 1 else 0 end) AS `Bajas_En_Combate_Registradas_Sistema`,sum(case when `spb`.`Estado_Soldado_Post_Batalla` like 'Herido%' then 1 else 0 end) AS `Heridos_Registrados_Sistema`,sum(case when `spb`.`Estado_Soldado_Post_Batalla` = 'Prisionero de Guerra (POW)' then 1 else 0 end) AS `Prisioneros_Registrados_Sistema`,sum(case when `spb`.`Estado_Soldado_Post_Batalla` = 'Desaparecido en Acción (MIA)' then 1 else 0 end) AS `Desaparecidos_Registrados_Sistema`,`b`.`Bajas_Estimadas_Eje` AS `Bajas_Totales_Estimadas_Eje_Historicas`,`b`.`Bajas_Estimadas_Aliados` AS `Bajas_Totales_Estimadas_Aliados_Historicas` from ((`batalla` `b` join `pais` `p` on(`b`.`ID_Pais_Batalla` = `p`.`ID_Pais`)) left join `soldado_participacion_batalla` `spb` on(`b`.`ID_Batalla` = `spb`.`ID_Batalla`)) group by `b`.`ID_Batalla`,`b`.`Nombre_Batalla`,`p`.`Nombre_Pais`,`b`.`Fecha_Inicio_Batalla`,`b`.`Fecha_Fin_Batalla`,`b`.`Bajas_Estimadas_Eje`,`b`.`Bajas_Estimadas_Aliados` order by `b`.`Fecha_Inicio_Batalla`,`b`.`Nombre_Batalla` */;

/*View structure for view v_estadisticas_soldados_por_pais_origen */

/*!50001 DROP TABLE IF EXISTS `v_estadisticas_soldados_por_pais_origen` */;
/*!50001 DROP VIEW IF EXISTS `v_estadisticas_soldados_por_pais_origen` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_estadisticas_soldados_por_pais_origen` AS select `p`.`Nombre_Pais` AS `Pais_Origen`,`p`.`Codigo_ISO_Alfa2` AS `Codigo_Pais_ISO2`,count(`s`.`ID_Soldado`) AS `Numero_Total_Soldados_Registrados`,sum(case when `s`.`Fecha_Muerte` is not null then 1 else 0 end) AS `Numero_Soldados_Caidos_Confirmados`,round(avg(timestampdiff(YEAR,`s`.`Fecha_Nacimiento`,`s`.`Fecha_Muerte`)),1) AS `Edad_Promedio_Al_Morir_Anios` from (`soldado` `s` join `pais` `p` on(`s`.`ID_Pais_Origen` = `p`.`ID_Pais`)) group by `p`.`ID_Pais`,`p`.`Nombre_Pais`,`p`.`Codigo_ISO_Alfa2` order by count(`s`.`ID_Soldado`) desc */;

/*View structure for view v_informacion_inhumacion_presentacion */

/*!50001 DROP TABLE IF EXISTS `v_informacion_inhumacion_presentacion` */;
/*!50001 DROP VIEW IF EXISTS `v_informacion_inhumacion_presentacion` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_informacion_inhumacion_presentacion` AS select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Soldado`,coalesce(`li`.`Es_Inhumacion_Desconocida_Confirmado`,1) AS `Inhumacion_Es_Desconocida_Flag`,`li`.`Tipo_Sitio_Inhumacion` AS `Tipo_Sitio_Inhumacion`,case when `li`.`ID_Soldado` is null or `li`.`Es_Inhumacion_Desconocida_Confirmado` = 1 then `pmuer`.`Nombre_Pais` else `pinhu`.`Nombre_Pais` end AS `Pais_Referencia_Inhumacion_Nombre`,case when `li`.`ID_Soldado` is null or `li`.`Es_Inhumacion_Desconocida_Confirmado` = 1 then `lmuer`.`Nombre_Lugar` when `li`.`ID_Lugar_Inhumacion_Detallado` is not null then `linhudet`.`Nombre_Lugar` else `li`.`Lugar_Detallado_Texto_Inhumacion` end AS `Lugar_Referencia_Inhumacion_Nombre`,case when `li`.`ID_Soldado` is null or `li`.`Es_Inhumacion_Desconocida_Confirmado` = 1 then NULL else `li`.`Nombre_Cementerio_Memorial` end AS `Nombre_Cementerio_O_Memorial`,case when `li`.`ID_Soldado` is null or `li`.`Es_Inhumacion_Desconocida_Confirmado` = 1 then NULL else `li`.`Ubicacion_Exacta_Tumba` end AS `Ubicacion_Exacta_Tumba_En_Sitio`,case when `li`.`ID_Soldado` is null then 'No hay datos de inhumación registrados para este soldado.' when `li`.`Es_Inhumacion_Desconocida_Confirmado` = 1 then `li`.`Anotacion_Lugar_Desconocido` else 'Información de inhumación conocida y registrada.' end AS `Anotacion_Sobre_Inhumacion`,`li`.`Coordenadas_Sitio_Lat` AS `Coordenadas_Sitio_Lat`,`li`.`Coordenadas_Sitio_Lon` AS `Coordenadas_Sitio_Lon`,`li`.`Fotografia_Tumba_URL` AS `Fotografia_Tumba_URL`,`s`.`Fecha_Muerte` AS `Fecha_Muerte_Soldado_Contexto`,`lmuer`.`Nombre_Lugar` AS `Lugar_Muerte_Si_Inhumacion_Desconocida_Contexto` from (((((`soldado` `s` left join `lugar_inhumacion` `li` on(`s`.`ID_Soldado` = `li`.`ID_Soldado`)) left join `pais` `pinhu` on(`li`.`ID_Pais_Inhumacion` = `pinhu`.`ID_Pais`)) left join `lugar` `linhudet` on(`li`.`ID_Lugar_Inhumacion_Detallado` = `linhudet`.`ID_Lugar`)) left join `lugar` `lmuer` on(`s`.`ID_Lugar_Muerte` = `lmuer`.`ID_Lugar`)) left join `pais` `pmuer` on(`lmuer`.`ID_Pais` = `pmuer`.`ID_Pais`)) */;

/*View structure for view v_linea_tiempo_eventos_soldado */

/*!50001 DROP TABLE IF EXISTS `v_linea_tiempo_eventos_soldado` */;
/*!50001 DROP VIEW IF EXISTS `v_linea_tiempo_eventos_soldado` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_linea_tiempo_eventos_soldado` AS select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Soldado`,`s`.`Fecha_Nacimiento` AS `Fecha_Evento`,1 AS `Orden_Tipo_Evento`,'Nacimiento' AS `Tipo_Evento`,concat('Nació en ',`lnac`.`Nombre_Lugar`,', ',`pnac`.`Nombre_Pais`,'. Precisión fecha: ',`s`.`Fecha_Nacimiento_Precision`) AS `Descripcion_Detallada_Evento`,NULL AS `ID_Registro_Relacionado`,`lnac`.`ID_Lugar` AS `ID_Lugar_Evento` from ((`soldado` `s` join `lugar` `lnac` on(`s`.`ID_Lugar_Nacimiento` = `lnac`.`ID_Lugar`)) join `pais` `pnac` on(`lnac`.`ID_Pais` = `pnac`.`ID_Pais`)) union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`sa`.`Fecha_Inicio_Rango` AS `Fecha_Inicio_Rango`,2 AS `2`,'Ascenso Militar' AS `Ascenso Militar`,concat('Ascendido al rango de: ',`r`.`Nombre_Rango`,coalesce(concat('. Documento: ',`sa`.`Documento_Referencia_Ascenso`),''),coalesce(concat('. Notas: ',`sa`.`Notas_Adicionales_Ascenso`),'')) AS `Name_exp_6`,`sa`.`ID_Soldado_Ascenso` AS `ID_Soldado_Ascenso`,NULL AS `NULL` from ((`soldado_ascenso` `sa` join `soldado` `s` on(`sa`.`ID_Soldado` = `s`.`ID_Soldado`)) join `rango` `r` on(`sa`.`ID_Rango` = `r`.`ID_Rango`)) union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`spu`.`Fecha_Inicio_Pertenencia_Unidad` AS `Fecha_Inicio_Pertenencia_Unidad`,3 AS `3`,'Inicio Pertenencia a Unidad' AS `Inicio Pertenencia a Unidad`,concat('Se unió a la unidad: ',`um`.`Nombre_Unidad`,' (',`um`.`Tipo_Unidad`,')',coalesce(concat(' como ',`spu`.`Rol_Desempenado_En_Unidad`),''),coalesce(concat('. Notas: ',`spu`.`Notas_Sobre_Pertenencia`),'')) AS `Name_exp_6`,`spu`.`ID_Pertenencia` AS `ID_Pertenencia`,NULL AS `NULL` from ((`soldado_pertenencia_unidad` `spu` join `soldado` `s` on(`spu`.`ID_Soldado` = `s`.`ID_Soldado`)) join `unidad_militar` `um` on(`spu`.`ID_Unidad` = `um`.`ID_Unidad`)) union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`spu`.`Fecha_Fin_Pertenencia_Unidad` AS `Fecha_Fin_Pertenencia_Unidad`,6 AS `6`,'Fin Pertenencia a Unidad' AS `Fin Pertenencia a Unidad`,concat('Dejó la unidad: ',`um`.`Nombre_Unidad`,coalesce(concat('. Notas: ',`spu`.`Notas_Sobre_Pertenencia`),'')) AS `Name_exp_6`,`spu`.`ID_Pertenencia` AS `ID_Pertenencia`,NULL AS `NULL` from ((`soldado_pertenencia_unidad` `spu` join `soldado` `s` on(`spu`.`ID_Soldado` = `s`.`ID_Soldado`)) join `unidad_militar` `um` on(`spu`.`ID_Unidad` = `um`.`ID_Unidad`)) where `spu`.`Fecha_Fin_Pertenencia_Unidad` is not null union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,coalesce(`spb`.`Fecha_Inicio_Participacion_Batalla`,`b`.`Fecha_Inicio_Batalla`) AS `Fecha_Evento`,4 AS `4`,'Participación en Batalla' AS `Participación en Batalla`,concat('Participó en la Batalla de: ',`b`.`Nombre_Batalla`,case when `spb`.`Rol_O_Acciones_En_Batalla` is not null then concat(' (Rol: ',`spb`.`Rol_O_Acciones_En_Batalla`,')') else '' end,case when `spb`.`Estado_Soldado_Post_Batalla` is not null then concat(' [Estado final: ',`spb`.`Estado_Soldado_Post_Batalla`,']') else '' end,coalesce(concat('. Notas: ',`spb`.`Notas_Participacion_Batalla`),'')) AS `Name_exp_6`,`spb`.`ID_Participacion_Batalla` AS `ID_Participacion_Batalla`,`b`.`ID_Lugar_Batalla` AS `ID_Lugar_Batalla` from ((`soldado_participacion_batalla` `spb` join `soldado` `s` on(`spb`.`ID_Soldado` = `s`.`ID_Soldado`)) join `batalla` `b` on(`spb`.`ID_Batalla` = `b`.`ID_Batalla`)) union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`sm`.`Fecha_Obtencion_Medalla` AS `Fecha_Obtencion_Medalla`,5 AS `5`,'Condecoración Recibida' AS `Condecoración Recibida`,concat('Recibió la medalla: ',`m`.`Nombre_Medalla`,case when `sm`.`Motivo_Condecoracion_Especifico` is not null then concat('. Motivo: ',`sm`.`Motivo_Condecoracion_Especifico`) else '' end,if(`sm`.`Otorgada_Postumamente`,' (Póstuma)','')) AS `Name_exp_6`,`sm`.`ID_Soldado_Medalla` AS `ID_Soldado_Medalla`,NULL AS `NULL` from ((`soldado_medalla` `sm` join `soldado` `s` on(`sm`.`ID_Soldado` = `s`.`ID_Soldado`)) join `medalla` `m` on(`sm`.`ID_Medalla` = `m`.`ID_Medalla`)) where `sm`.`Fecha_Obtencion_Medalla` is not null union all select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`s`.`Fecha_Muerte` AS `Fecha_Muerte`,7 AS `7`,'Fallecimiento' AS `Fallecimiento`,concat('Falleció en: ',`lmuer`.`Nombre_Lugar`,', ',`pmuer`.`Nombre_Pais`,'. Causa: ',coalesce(`cm`.`Descripcion_Causa`,'Desconocida'),'. Precisión fecha: ',`s`.`Fecha_Muerte_Precision`) AS `Name_exp_6`,NULL AS `NULL`,`s`.`ID_Lugar_Muerte` AS `ID_Lugar_Muerte` from (((`soldado` `s` left join `lugar` `lmuer` on(`s`.`ID_Lugar_Muerte` = `lmuer`.`ID_Lugar`)) left join `pais` `pmuer` on(`lmuer`.`ID_Pais` = `pmuer`.`ID_Pais`)) left join `causa_muerte` `cm` on(`s`.`ID_Causa_Muerte` = `cm`.`ID_Causa_Muerte`)) where `s`.`Fecha_Muerte` is not null */;

/*View structure for view v_soldado_informacion_completa */

/*!50001 DROP TABLE IF EXISTS `v_soldado_informacion_completa` */;
/*!50001 DROP VIEW IF EXISTS `v_soldado_informacion_completa` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soldado_informacion_completa` AS select `s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombres` AS `Nombres`,`s`.`Patronimico` AS `Patronimico`,`s`.`Apellidos` AS `Apellidos`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Completo_Busqueda`,`s`.`Sexo` AS `Sexo`,`s`.`Fecha_Nacimiento` AS `Fecha_Nacimiento`,`s`.`Fecha_Nacimiento_Precision` AS `Fecha_Nacimiento_Precision`,`porig`.`Nombre_Pais` AS `Pais_Origen_Nombre`,`porig`.`Codigo_ISO_Alfa2` AS `Pais_Origen_ISO2`,`lnac`.`Nombre_Lugar` AS `Lugar_Nacimiento_Nombre`,`pnac`.`Nombre_Pais` AS `Pais_Lugar_Nacimiento_Nombre`,`lnac`.`Tipo_Lugar` AS `Tipo_Lugar_Nacimiento`,`s`.`Fecha_Muerte` AS `Fecha_Muerte`,`s`.`Fecha_Muerte_Precision` AS `Fecha_Muerte_Precision`,`lmuer`.`Nombre_Lugar` AS `Lugar_Muerte_Nombre`,`pmuer`.`Nombre_Pais` AS `Pais_Lugar_Muerte_Nombre`,`lmuer`.`Tipo_Lugar` AS `Tipo_Lugar_Muerte`,`cm`.`Descripcion_Causa` AS `Causa_Muerte_Descripcion`,`cm`.`Categoria_Causa` AS `Categoria_Causa_Muerte`,`re`.`Nombre_Rama` AS `Rama_Ejercito_Nombre`,`re`.`Siglas_Rama` AS `Rama_Ejercito_Siglas`,`s`.`Numero_Identificacion_Militar` AS `Numero_Identificacion_Militar`,`s`.`Notas_Adicionales_Soldado` AS `Notas_Adicionales_Soldado`,`s`.`Fotografia_URL` AS `Fotografia_URL`,`s`.`Estado_Registro` AS `Estado_Registro`,`s`.`Fuente_Informacion_Principal` AS `Fuente_Informacion_Principal`,`s`.`Fecha_Creacion` AS `Fecha_Registro_Soldado_DB`,`s`.`Fecha_Actualizacion` AS `Ultima_Actualizacion_Soldado_DB` from (((((((`soldado` `s` join `pais` `porig` on(`s`.`ID_Pais_Origen` = `porig`.`ID_Pais`)) join `lugar` `lnac` on(`s`.`ID_Lugar_Nacimiento` = `lnac`.`ID_Lugar`)) join `pais` `pnac` on(`lnac`.`ID_Pais` = `pnac`.`ID_Pais`)) left join `lugar` `lmuer` on(`s`.`ID_Lugar_Muerte` = `lmuer`.`ID_Lugar`)) left join `pais` `pmuer` on(`lmuer`.`ID_Pais` = `pmuer`.`ID_Pais`)) left join `causa_muerte` `cm` on(`s`.`ID_Causa_Muerte` = `cm`.`ID_Causa_Muerte`)) left join `rama_ejercito` `re` on(`s`.`ID_Rama_Ejercito` = `re`.`ID_Rama_Ejercito`)) */;

/*View structure for view v_soldado_participacion_batallas_detallada */

/*!50001 DROP TABLE IF EXISTS `v_soldado_participacion_batallas_detallada` */;
/*!50001 DROP VIEW IF EXISTS `v_soldado_participacion_batallas_detallada` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soldado_participacion_batallas_detallada` AS select `spb`.`ID_Participacion_Batalla` AS `ID_Participacion_Batalla`,`s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Soldado`,`b`.`ID_Batalla` AS `ID_Batalla`,`b`.`Nombre_Batalla` AS `Nombre_Batalla`,`pbat`.`Nombre_Pais` AS `Pais_Batalla`,coalesce(`lb`.`Nombre_Lugar`,`b`.`Lugar_Especifico_Texto`) AS `Lugar_Especifico_Batalla_Nombre`,`b`.`Fecha_Inicio_Batalla` AS `Fecha_Inicio_Batalla`,`b`.`Fecha_Fin_Batalla` AS `Fecha_Fin_Batalla`,timestampdiff(DAY,`b`.`Fecha_Inicio_Batalla`,coalesce(`b`.`Fecha_Fin_Batalla`,`b`.`Fecha_Inicio_Batalla`)) + 1 AS `Duracion_Total_Batalla_Dias`,`cm`.`Nombre_Oficial_Campana` AS `Nombre_Oficial_Campana`,`cm`.`Nombre_Codigo_Operacion` AS `Nombre_Codigo_Operacion`,`umbat`.`Nombre_Unidad` AS `Unidad_Militar_En_Batalla_Nombre`,`umbat`.`Tipo_Unidad` AS `Tipo_Unidad_Militar_En_Batalla`,`spb`.`Rol_O_Acciones_En_Batalla` AS `Rol_O_Acciones_En_Batalla`,`spb`.`Estado_Soldado_Post_Batalla` AS `Estado_Soldado_Post_Batalla`,`spb`.`Fecha_Inicio_Participacion_Batalla` AS `Fecha_Inicio_Participacion_Batalla`,`spb`.`Fecha_Fin_Participacion_Batalla` AS `Fecha_Fin_Participacion_Batalla`,`spb`.`Notas_Participacion_Batalla` AS `Notas_Participacion_Batalla` from ((((((`soldado_participacion_batalla` `spb` join `soldado` `s` on(`spb`.`ID_Soldado` = `s`.`ID_Soldado`)) join `batalla` `b` on(`spb`.`ID_Batalla` = `b`.`ID_Batalla`)) join `pais` `pbat` on(`b`.`ID_Pais_Batalla` = `pbat`.`ID_Pais`)) left join `lugar` `lb` on(`b`.`ID_Lugar_Batalla` = `lb`.`ID_Lugar`)) left join `campana_militar` `cm` on(`b`.`ID_Campana` = `cm`.`ID_Campana`)) left join `unidad_militar` `umbat` on(`spb`.`ID_Unidad_Militar_En_Batalla` = `umbat`.`ID_Unidad`)) order by `s`.`ID_Soldado`,`b`.`Fecha_Inicio_Batalla`,`spb`.`Fecha_Inicio_Participacion_Batalla` */;

/*View structure for view v_soldado_rangos_actual_historial */

/*!50001 DROP TABLE IF EXISTS `v_soldado_rangos_actual_historial` */;
/*!50001 DROP VIEW IF EXISTS `v_soldado_rangos_actual_historial` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soldado_rangos_actual_historial` AS select `sa`.`ID_Soldado_Ascenso` AS `ID_Soldado_Ascenso`,`s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Soldado`,`r`.`Nombre_Rango` AS `Nombre_Rango`,`r`.`Abreviatura_Rango` AS `Abreviatura_Rango`,`r`.`Orden_Jerarquico` AS `Orden_Jerarquico`,`sa`.`Fecha_Inicio_Rango` AS `Fecha_Inicio_Rango`,`sa`.`Fecha_Fin_Rango` AS `Fecha_Fin_Rango`,case when `sa`.`Fecha_Fin_Rango` is null and `s`.`Fecha_Muerte` is null then 'Rango Actual (Vivo)' when `sa`.`Fecha_Fin_Rango` is null and `s`.`Fecha_Muerte` is not null and `sa`.`Fecha_Inicio_Rango` <= `s`.`Fecha_Muerte` then 'Rango al Morir' when `sa`.`Fecha_Fin_Rango` is not null and `s`.`Fecha_Muerte` is not null and `sa`.`Fecha_Fin_Rango` >= `s`.`Fecha_Muerte` and `sa`.`Fecha_Inicio_Rango` <= `s`.`Fecha_Muerte` then 'Rango al Morir' else 'Rango Pasado' end AS `Estado_Rango_Interpretado`,`sa`.`Documento_Referencia_Ascenso` AS `Documento_Referencia_Ascenso`,`sa`.`Notas_Adicionales_Ascenso` AS `Notas_Adicionales_Ascenso` from ((`soldado_ascenso` `sa` join `soldado` `s` on(`sa`.`ID_Soldado` = `s`.`ID_Soldado`)) join `rango` `r` on(`sa`.`ID_Rango` = `r`.`ID_Rango`)) order by `s`.`ID_Soldado`,`sa`.`Fecha_Inicio_Rango` desc */;

/*View structure for view v_soldado_unidades_actual_historial */

/*!50001 DROP TABLE IF EXISTS `v_soldado_unidades_actual_historial` */;
/*!50001 DROP VIEW IF EXISTS `v_soldado_unidades_actual_historial` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soldado_unidades_actual_historial` AS select `spu`.`ID_Pertenencia` AS `ID_Pertenencia`,`s`.`ID_Soldado` AS `ID_Soldado`,`s`.`Nombre_Completo_Busqueda` AS `Nombre_Soldado`,`um`.`ID_Unidad` AS `ID_Unidad`,`um`.`Nombre_Unidad` AS `Nombre_Unidad`,`um`.`Tipo_Unidad` AS `Tipo_Unidad`,`puni`.`Nombre_Pais` AS `Pais_Afiliacion_Unidad`,`spu`.`Fecha_Inicio_Pertenencia_Unidad` AS `Fecha_Inicio_Pertenencia_Unidad`,`spu`.`Fecha_Fin_Pertenencia_Unidad` AS `Fecha_Fin_Pertenencia_Unidad`,case when `spu`.`Fecha_Fin_Pertenencia_Unidad` is null and `s`.`Fecha_Muerte` is null then 'Unidad Actual (Vivo)' when `spu`.`Fecha_Fin_Pertenencia_Unidad` is null and `s`.`Fecha_Muerte` is not null and `spu`.`Fecha_Inicio_Pertenencia_Unidad` <= `s`.`Fecha_Muerte` then 'Unidad al Morir' when `spu`.`Fecha_Fin_Pertenencia_Unidad` is not null and `s`.`Fecha_Muerte` is not null and `spu`.`Fecha_Fin_Pertenencia_Unidad` >= `s`.`Fecha_Muerte` and `spu`.`Fecha_Inicio_Pertenencia_Unidad` <= `s`.`Fecha_Muerte` then 'Unidad al Morir' else 'Pertenencia Pasada' end AS `Estado_Pertenencia_Interpretado`,`spu`.`Rol_Desempenado_En_Unidad` AS `Rol_Desempenado_En_Unidad`,`spu`.`Notas_Sobre_Pertenencia` AS `Notas_Sobre_Pertenencia` from (((`soldado_pertenencia_unidad` `spu` join `soldado` `s` on(`spu`.`ID_Soldado` = `s`.`ID_Soldado`)) join `unidad_militar` `um` on(`spu`.`ID_Unidad` = `um`.`ID_Unidad`)) left join `pais` `puni` on(`um`.`ID_Pais_Afiliacion_Unidad` = `puni`.`ID_Pais`)) order by `s`.`ID_Soldado`,`spu`.`Fecha_Inicio_Pertenencia_Unidad` desc */;

/*View structure for view v_unidad_militar_jerarquia_completa */

/*!50001 DROP TABLE IF EXISTS `v_unidad_militar_jerarquia_completa` */;
/*!50001 DROP VIEW IF EXISTS `v_unidad_militar_jerarquia_completa` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_unidad_militar_jerarquia_completa` AS with recursive UnidadJerarquia(ID_Unidad,Nombre_Unidad,Tipo_Unidad,ID_Unidad_Superior,Nivel_Jerarquia,Ruta_Jerarquia_Nombres,Ruta_Jerarquia_IDs) as (select `um`.`ID_Unidad` AS `ID_Unidad`,`um`.`Nombre_Unidad` AS `Nombre_Unidad`,`um`.`Tipo_Unidad` AS `Tipo_Unidad`,`um`.`ID_Unidad_Superior_Directa` AS `ID_Unidad_Superior`,0 AS `Nivel_Jerarquia`,cast(`um`.`Nombre_Unidad` as char(2000) charset utf8mb4) AS `Ruta_Jerarquia_Nombres`,cast(`um`.`ID_Unidad` as char(2000) charset utf8mb4) AS `Ruta_Jerarquia_IDs` from `unidad_militar` `um` where `um`.`ID_Unidad_Superior_Directa` is null union all select `um_hija`.`ID_Unidad` AS `ID_Unidad`,`um_hija`.`Nombre_Unidad` AS `Nombre_Unidad`,`um_hija`.`Tipo_Unidad` AS `Tipo_Unidad`,`um_hija`.`ID_Unidad_Superior_Directa` AS `ID_Unidad_Superior_Directa`,`uj`.`Nivel_Jerarquia` + 1 AS `uj.Nivel_Jerarquia + 1`,cast(concat(`uj`.`Ruta_Jerarquia_Nombres`,' > ',`um_hija`.`Nombre_Unidad`) as char(2000) charset utf8mb4),cast(concat(`uj`.`Ruta_Jerarquia_IDs`,',',`um_hija`.`ID_Unidad`) as char(2000) charset utf8mb4) from (`unidad_militar` `um_hija` join `unidadjerarquia` `uj` on(`um_hija`.`ID_Unidad_Superior_Directa` = `uj`.`ID_Unidad`)) where `uj`.`Nivel_Jerarquia` < 15)select `uj`.`ID_Unidad` AS `ID_Unidad`,`uj`.`Nombre_Unidad` AS `Nombre_Unidad`,`uj`.`Tipo_Unidad` AS `Tipo_Unidad`,`uj`.`ID_Unidad_Superior` AS `ID_Unidad_Superior`,(select `unidad_militar`.`Nombre_Unidad` from `unidad_militar` where `unidad_militar`.`ID_Unidad` = `uj`.`ID_Unidad_Superior`) AS `Nombre_Unidad_Superior_Directa`,`uj`.`Nivel_Jerarquia` AS `Nivel_Jerarquia`,`uj`.`Ruta_Jerarquia_Nombres` AS `Ruta_Jerarquia_Nombres`,`uj`.`Ruta_Jerarquia_IDs` AS `Ruta_Jerarquia_IDs`,`um_actual`.`ID_Pais_Afiliacion_Unidad` AS `ID_Pais_Afiliacion_Unidad`,`p`.`Nombre_Pais` AS `Pais_Afiliacion_Unidad_Nombre`,`um_actual`.`Fecha_Activacion_Unidad` AS `Fecha_Activacion_Unidad`,`um_actual`.`Fecha_Desactivacion_Unidad` AS `Fecha_Desactivacion_Unidad`,`um_actual`.`Especializacion_Unidad` AS `Especializacion_Unidad` from ((`unidadjerarquia` `uj` join `unidad_militar` `um_actual` on(`uj`.`ID_Unidad` = `um_actual`.`ID_Unidad`)) left join `pais` `p` on(`um_actual`.`ID_Pais_Afiliacion_Unidad` = `p`.`ID_Pais`)) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
