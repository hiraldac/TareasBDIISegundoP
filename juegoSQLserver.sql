USE master;  
GO  

IF EXISTS(select * from sys.databases where name = 'juego')  
BEGIN  
    DROP DATABASE juego;  
END 

create database juego;

USE juego;
GO  
-- Crea la tabla jugadores
CREATE TABLE dbo.jugadores(
    idJugador INT NOT NULL IDENTITY(1,1),
    nombreJugador VARCHAR(45) NOT NULL,
    nivel INT NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT jugadores_pk PRIMARY KEY(idJugador))
GO
-- Crea la tabla campeones
CREATE TABLE dbo.campeones(
    idCampeon INT NOT NULL IDENTITY(1,1),
    nombreCampeon VARCHAR(45) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    precio DECIMAL(8,2) NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT campeones_clave_alt UNIQUE (nombreCampeon),
    CONSTRAINT campeones_pk PRIMARY KEY(idCampeon))
GO
-- Crea la tabla batallas
CREATE TABLE dbo.batallas(
    jugadorId INT NOT NULL,
    campeonId INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT batallas_jugadores FOREIGN KEY (jugadorId)
        REFERENCES jugadores (idJugador)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT batallas_campeones FOREIGN KEY (campeonId)
        REFERENCES campeones (idCampeon)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
        CONSTRAINT batallas_pk PRIMARY KEY  (jugadorId, campeonId))
	GO

-- 1. Proceso almacenado para crear un registro jugador
CREATE PROCEDURE spCrearRegistroJugador (
 @_nombreJugador VARCHAR (45),
    @_nivel INT,
    @_fecha DATE,
    @_edad INT
)
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO jugadores (
		nombreJugador, 
        nivel, 
        fecha,
        edad
	)
	VALUES(
		@_nombreJugador,
        @_nivel,
        @_fecha,
        @_edad
    );
END; 
 GO

-- 2. Proceso almacenado para crear un registro campeon
CREATE PROCEDURE spCrearRegistroCampeon (
 @_nombreCampeon VARCHAR (45),
    @_tipo VARCHAR(20),
    @_precio DECIMAL(8,2),
    @_fecha DATE,
    @_edad INT
)
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO campeones (
		nombreCampeon, 
        tipo, 
        precio,
        fecha,
        edad
	)
	VALUES(
		@_nombreCampeon,
        @_tipo,
        @_precio,
        @_fecha,
        @_edad
    );
END; 
 GO

-- 3. Proceso almacenado para crear un registro batalla
CREATE PROCEDURE spCrearRegistroBatallas (
 @_jugadorId INT,
    @_campeonId INT,
    @_cantidad INT
)
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO batallas (
		jugadorId, 
        campeonId, 
        cantidad
	)
	VALUES(
		@_jugadorId,
        @_campeonId,
        @_cantidad
    );
END; 
 GO

-- 4.Proceso almacenado para actualizar un registro jugador
CREATE PROCEDURE spActualizarRegistroJugador (
 @_idJugador INT,
 @_nombreJugador VARCHAR (45),
    @_nivel INT,
    @_fecha DATE,
    @_edad INT
)
AS
BEGIN
SET NOCOUNT ON;
	UPDATE jugadores 
    SET nombreJugador=@_nombreJugador,
		nivel=@_nivel,
		fecha=@_fecha,
        edad=@_edad
        WHERE idJugador=@_idJugador;
END; 
 GO

-- 5.Proceso almacenado para actualizar un registro campeon
CREATE PROCEDURE spActualizarRegistroCampeon (
 @_idCampeon INT,
 @_nombreCampeon VARCHAR (45),
    @_tipo VARCHAR(20),
    @_precio DECIMAL(8,2),
    @_fecha DATE,
    @_edad INT
)
AS
BEGIN
SET NOCOUNT ON;
	UPDATE campeones
    SET nombreCampeon=@_nombreCampeon,
        tipo=@_tipo,
        precio=@_precio,
        fecha=@_fecha,
        edad=@_edad
        WHERE idCampeon=@_idCampeon;
END; 
 GO

-- 6.Proceso almacenado para actualizar un registro batalla
CREATE PROCEDURE spActualizarRegistroBatallas (
 @_jugadorId INT,
    @_campeonId INT,
    @_cantidad INT
)
AS
BEGIN
SET NOCOUNT ON;
	UPDATE batallas
    SET jugadorId=@_jugadorId,
        campeonId=@_campeonId,
        cantidad=@_cantidad
        WHERE campeonId=@_campeonId and jugadorId=@_jugadorId;
END; 
 GO

-- 7.Proceso almacenado para eliminar un registro jugador
CREATE PROCEDURE spEliminarRegistroJugador (
 @_idJugador INT
)
AS
BEGIN
SET NOCOUNT ON;
	DELETE FROM jugadores
    WHERE idJugador=@_idJugador;
END; 
 GO

-- 8.Proceso almacenado para eliminar un registro campeon
CREATE PROCEDURE spEliminarRegistroCampeon (
 @_idCampeon INT
)
AS
BEGIN
SET NOCOUNT ON;
	DELETE FROM campeones
    WHERE idCampeon=@_idCampeon;
END; 
 GO

-- 9.Proceso almacenado para eliminar un registro batalla
CREATE PROCEDURE spEliminarRegistroBatallas (
 @_jugadorId INT,
    @_campeonId INT
)
AS
BEGIN
SET NOCOUNT ON;
	DELETE FROM batallas 
    WHERE campeonId =@_campeonId
    AND jugadorId=@_jugadorId;
END; 
 GO

-- 10.Proceso almacenado para ver los registros de la tabla jugador
CREATE PROCEDURE spObtenerRegistroJugador 
AS
BEGIN
SET NOCOUNT ON;
	SELECT * FROM jugadores;
END; 
 GO

-- 11.Proceso almacenado para ver los registros de la tabla campeon
CREATE PROCEDURE spObtenerRegistroCampeon 
AS
BEGIN
SET NOCOUNT ON;
	SELECT * FROM campeones;
END; 
 GO

-- 12.Proceso almacenado para ver los registros de la tabla batallas
CREATE PROCEDURE spObtenerRegistroBatallas 
AS
BEGIN
SET NOCOUNT ON;
	SELECT c.nombreCampeon,c.precio,b.cantidad FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador=b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId=c.idCampeon;
END; 
 GO

-- 13.Proceso almacenado que devuelve un jugador en especifico
CREATE PROCEDURE spObtenerUnRegistroJugador (
 @_idJugador int)
AS
BEGIN
SET NOCOUNT ON;
	SELECT * FROM jugadores j where j.idJugador=@_idJugador;
END; 
 GO

-- 14.Proceso almacenado que devuelve un campeon en especifico
CREATE PROCEDURE spObtenerUnRegistroCampeon (
 @_idCampeon int)
AS
BEGIN
SET NOCOUNT ON;
	SELECT * FROM campeones c where c.idCampeon=@_idCampeon;
END; 
 GO

-- 15.Proceso almacenado que muestra los jugadores, que han combatido o no, y campeones 
CREATE PROCEDURE spObtenerJugadoresConOSinBatallas
as
begin
set nocount on;
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    LEFT JOIN batallas b
    ON j.idJugador = b.jugadorId
    LEFT JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end; 
 GO

-- 16.Proceso almacenado que muestra los jugadores y campeones que han combatido 
CREATE PROCEDURE spObtenerJugadoresConBatallas
as
begin
set nocount on;
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end; 
 GO

-- 17.Proceso almacenado que devuelve el campeon mas contratado
CREATE PROCEDURE spObtenerRegistroCampeonMasContratado 
AS
BEGIN
SET NOCOUNT ON;
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.nombreCampeon
    having sum(b.cantidad)>= all
	(SELECT sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END; 
 GO

-- 18.Proceso almacenado que devuelve el campeon menos contratado
CREATE PROCEDURE spObtenerRegistroCampeonMenosContratado 
AS
BEGIN
SET NOCOUNT ON;
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.nombreCampeon
    having sum(b.cantidad)<= all
	(SELECT sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END; 
 GO

-- 19.Proceso almacenado que devuelve el jugador que mas ha gastado
CREATE PROCEDURE spObtenerRegistroJugadorMasGasto 
AS
BEGIN
SET NOCOUNT ON;
	SELECT j.nombreJugador, sum(b.cantidad*c.precio) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.nombreJugador
    having sum(b.cantidad*c.precio)>= all
	(SELECT sum(b.cantidad*c.precio) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.idJugador);
END; 
 GO

-- 20.Proceso almacenado que devuelve el jugador que menos ha contratado
CREATE PROCEDURE spObtenerRegistroJugadorMenosContrata 
AS
BEGIN
SET NOCOUNT ON;
	SELECT j.nombreJugador, sum(b.cantidad) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.nombreJugador
    having sum(b.cantidad)<= all
	(SELECT sum(b.cantidad) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.idJugador);
END; 
 GO

-- 21.Proceso almacenado que devuelve a los jugadores jovenes
CREATE PROCEDURE spObtenerRegistroJugadorJoven 
AS
BEGIN
SET NOCOUNT ON;
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad<18 ;
END; 
 GO

-- 22.Proceso almacenado que devuelve a los jugadores adultos
CREATE PROCEDURE spObtenerRegistroJugadorAdulto 
AS
BEGIN
SET NOCOUNT ON;
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad>=18 ;
END; 
 GO

-- 23.Proceso almacenado que muestra los jugadores que no han combatido
CREATE PROCEDURE spObtenerJugadoresSinBatallas
as
begin
set nocount on;
	SELECT 
		j.nombreJugador
	FROM jugadores j
    LEFT JOIN batallas b
    on j.idJugador = b.jugadorId
    where b.campeonId is null;
end; 
 GO

-- 24.Proceso almacenado que muestra los campeones que no han combatido
CREATE PROCEDURE spObtenerCampeonesSinBatallas
as
begin
set nocount on;
	SELECT c.nombreCampeon
	FROM campeones c
    LEFT JOIN batallas b
    ON c.idCampeon= b.campeonId
    where b.jugadorId is null;
end; 
 GO

-- 25.Proceso almacenado que devuelve el jugador de nivel mas alto
CREATE PROCEDURE spObtenerRegistroJugadorMayorNivel 
AS
BEGIN
SET NOCOUNT ON;
	SELECT nombreJugador, nivel
    FROM jugadores
    where nivel = (SELECT MAX( nivel ) FROM jugadores); 
END; 
 GO

-- 26.Proceso almacenado que devuelve los campeones que no cobran
CREATE PROCEDURE spObtenerRegistroCampeonNoCobra 
AS
BEGIN
SET NOCOUNT ON;
	SELECT nombreCampeon
    FROM campeones
    where precio is null;
END; 
 GO

 EXEC dbo.spCrearRegistroJugador @_nombreJugador = 'Salazar',@_nivel=20,@_fecha='2018-06-29',@_edad=28;
 EXEC dbo.spCrearRegistroJugador @_nombreJugador = 'Jalmes',@_nivel=10,@_fecha='2018-07-15',@_edad=16;
 EXEC dbo.spCrearRegistroJugador @_nombreJugador = 'Bernal',@_nivel=30,@_fecha='2018-09-24',@_edad=18;
 EXEC dbo.spCrearRegistroJugador @_nombreJugador = 'Salazar',@_nivel=null,@_fecha='2018-12-25',@_edad=22;

 EXEC dbo.spCrearRegistroCampeon @_nombreCampeon = 'Akali',@_tipo='Aseseino',@_precio=790,@_fecha='2018-05-11',@_edad=12;
 EXEC dbo.spCrearRegistroCampeon @_nombreCampeon = 'Brand',@_tipo='Aseseino',@_precio= null ,@_fecha='2018-09-10',@_edad=22;
 EXEC dbo.spCrearRegistroCampeon @_nombreCampeon = 'Caitlyn',@_tipo='mago',@_precio=880,@_fecha='2018-01-01',@_edad=32;
 EXEC dbo.spCrearRegistroCampeon @_nombreCampeon = 'Karpov',@_tipo='Aseseino',@_precio=1880,@_fecha='2018-01-01',@_edad=17;

 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=1, @_cantidad =300;
 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=2, @_cantidad =200;
 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =1, @_campeonId=3, @_cantidad =400;
 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =2, @_campeonId=1, @_cantidad =300;
 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =2, @_campeonId=2, @_cantidad =400;
 EXEC dbo.spCrearRegistroBatallas  @_jugadorId =3, @_campeonId=1, @_cantidad =200;

