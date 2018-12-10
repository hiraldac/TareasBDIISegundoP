
create database ejemplo;
use ejemplo;

CREATE TABLE cuenta (
	idCuenta int identity(1,1),
	saldo decimal(8,2)
);  

-- Atomicidad
BEGIN TRANSACTION;  
   INSERT INTO cuenta(saldo) VALUES(389.55);  
   INSERT INTO cuenta(saldo) VALUES(278.05);  
ROLLBACK; 

-- Consistencia, Durabilidad
BEGIN TRANSACTION;  
    INSERT INTO cuenta(saldo) VALUES(389.55);  
   INSERT INTO cuenta(saldo) VALUES(278.05);   
COMMIT; 

-- Aislamiento
BEGIN TRANSACTION;  
   UPDATE cuenta SET saldo=saldo-100 where idCuenta=1;  
COMMIT; 
BEGIN TRANSACTION;  
   UPDATE cuenta SET saldo=saldo+100 where idCuenta=1;  
COMMIT; 