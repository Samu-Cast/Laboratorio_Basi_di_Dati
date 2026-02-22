CREATE DATABASE IF NOT EXISTS Soccorso;
USE soccorso;

DROP TABLE IF EXISTS Impiega;
DROP TABLE IF EXISTS Aggiorna;
DROP TABLE IF EXISTS Effettua;
DROP TABLE IF EXISTS Utilizza;
DROP TABLE IF EXISTS Contiene;
DROP TABLE IF EXISTS Possiede;
DROP TABLE IF EXISTS Conosce;
DROP TABLE IF EXISTS Commento;
DROP TABLE IF EXISTS Missione;
DROP TABLE IF EXISTS Foto;
DROP TABLE IF EXISTS Richiesta_Soccorso;
DROP TABLE IF EXISTS Segnalante;
DROP TABLE IF EXISTS Patente;
DROP TABLE IF EXISTS Tipo;
DROP TABLE IF EXISTS Operatore;
DROP TABLE IF EXISTS Amministratore;
DROP TABLE IF EXISTS Materiale;
DROP TABLE IF EXISTS Mezzo;
DROP TABLE IF EXISTS Abilita;



CREATE TABLE Operatore (
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    dataDiNascita DATE NOT NULL,
    luogoDiNascita VARCHAR(50) NOT NULL,
    cf CHAR(16) UNIQUE NOT NULL
);

CREATE TABLE Patente (
	numero CHAR(10) PRIMARY KEY,
	dataScadenza DATE NOT NULL,
	ID_Operatore INT UNSIGNED NOT NULL,
    CONSTRAINT patente_operatore FOREIGN KEY (ID_Operatore) 
		REFERENCES Operatore(ID)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Materiale (
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    dataScadenza DATE NOT NULL,
	descrizione TEXT,
    qtaDisponibile INT UNSIGNED NOT NULL    
);

CREATE TABLE Segnalante (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    IP VARCHAR(40) NOT NULL
);

CREATE TABLE Richiesta_Soccorso (
    `UUID` BINARY(16) PRIMARY KEY,
    validata BOOLEAN NOT NULL DEFAULT FALSE,
    dataOraApertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descrizione TEXT NOT NULL,
    coordinate POINT NOT NULL,
    indirizzo TEXT NOT NULL,
    ID_Segnalante INT UNSIGNED NOT NULL,
    CONSTRAINT richiesta_soccorso_segnalante FOREIGN KEY (ID_Segnalante) 
		REFERENCES Segnalante(ID)
		ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE Missione (
	ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    timestampInizio TIMESTAMP NOT NULL DEFAULT current_timestamp,
    timestampFine TIMESTAMP DEFAULT NULL,
    obiettivo TEXT NOT NULL,
    UUID_Richiesta_Soccorso BINARY(16) UNIQUE NOT NULL,
    livello_successo ENUM(
	  'fallimento',     -- 0
	  'scarso',         -- 1
	  'parziale',       -- 2
	  'moderato',       -- 3
	  'quasi_successo', -- 4
	  'successo'        -- 5
	), 
    CONSTRAINT missione_richiesta_soccorso FOREIGN KEY (UUID_Richiesta_Soccorso)
		REFERENCES Richiesta_Soccorso(UUID)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
);



CREATE TABLE Effettua (
	ID_Missione INT UNSIGNED NOT NULL,
    ID_Operatore INT UNSIGNED NOT NULL,
    caposquadra BOOL NOT NULL,
    PRIMARY KEY (ID_Missione, ID_Operatore),
    CONSTRAINT effettua_missione FOREIGN KEY (ID_Missione)
		REFERENCES Missione(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT effettua_operatore FOREIGN KEY (ID_Operatore)
		REFERENCES Operatore(ID)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
);
CREATE TABLE Utilizza (
	ID_Missione INT UNSIGNED NOT NULL,
    ID_Materiale INT UNSIGNED NOT NULL,
    qtaImpiegata INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID_Missione, ID_Materiale),
	CONSTRAINT utilizza_missione FOREIGN KEY (ID_Missione)
		REFERENCES Missione(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,        
	CONSTRAINT utilizza_operatore FOREIGN KEY (ID_Materiale)
		REFERENCES Materiale(ID)
		ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE Amministratore (
    ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    dataDiNascita DATE NOT NULL,
    luogoDiNascita VARCHAR(50) NOT NULL,
    cf CHAR(16) UNIQUE NOT NULL
);

CREATE TABLE Aggiorna (
    ID_Missione INT UNSIGNED NOT NULL,
    ID_Amministratore INT UNSIGNED NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    testo TEXT NOT NULL,
    PRIMARY KEY (ID_Missione, ID_Amministratore, `timestamp`),
    CONSTRAINT aggiorna_missione FOREIGN KEY (ID_Missione) 
		REFERENCES Missione(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT aggiorna_amministratore FOREIGN KEY (ID_Amministratore) 
		REFERENCES Amministratore(ID)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE Mezzo (
	ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	targa VARCHAR(10) NOT NULL UNIQUE,
	nome VARCHAR(50) NOT NULL,
	descrizione TEXT NOT NULL,
	carburante VARCHAR(15) NOT NULL,
	patenteNecessaria VARCHAR(10) NOT NULL
);

CREATE TABLE Impiega (
    ID_Missione INT UNSIGNED NOT NULL,
    ID_Mezzo INT UNSIGNED NOT NULL,
    PRIMARY KEY (ID_Missione, ID_Mezzo),
    CONSTRAINT impiega_missione FOREIGN KEY (ID_Missione)
		REFERENCES Missione(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT impiega_mezzo FOREIGN KEY (ID_Mezzo)
		REFERENCES Mezzo(ID)
		ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE Foto (
	ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	percorso TEXT NOT NULL,
	ID_Richiesta_Soccorso BINARY(16) NOT NULL,
	CONSTRAINT foto_richiesta_soccorso FOREIGN KEY (ID_Richiesta_Soccorso) 
		REFERENCES Richiesta_Soccorso(UUID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Abilita(
	ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	descrizione TEXT NULL
);

CREATE TABLE Conosce (
    ID_Amministratore INT UNSIGNED NOT NULL,
    ID_Abilita INT UNSIGNED NOT NULL,
    certificato VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID_Amministratore, ID_Abilita),
    CONSTRAINT conosce_amministratore FOREIGN KEY (ID_Amministratore) 
		REFERENCES Amministratore(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT conosce_abilita FOREIGN KEY (ID_Abilita)
		REFERENCES Abilita(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Possiede (
	ID_Operatore INT UNSIGNED NOT NULL,
    ID_Abilita INT UNSIGNED NOT NULL,
    certificato VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID_Operatore, ID_Abilita),
    CONSTRAINT possiede_operatore FOREIGN KEY (ID_Operatore) 
		REFERENCES Operatore(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT possiede_abilita FOREIGN KEY (ID_Abilita)
		REFERENCES Abilita(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Tipo (
	ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(15) NOT NULL
);

CREATE TABLE Contiene (
    ID_Tipo INT UNSIGNED NOT NULL,
    numero_Patente CHAR(10) NOT NULL,
    PRIMARY KEY (ID_Tipo, numero_Patente),
    CONSTRAINT contiene_tipo FOREIGN KEY (ID_Tipo) 
		REFERENCES Tipo(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT contiene_patente FOREIGN KEY (numero_Patente) 
		REFERENCES Patente(numero)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Commento (
    ID_Missione INT UNSIGNED NOT NULL,
    ID_Amministratore INT UNSIGNED NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    testo TEXT NOT NULL,
    PRIMARY KEY (ID_Missione, ID_Amministratore, `timestamp`),
    CONSTRAINT commento_missione FOREIGN KEY (ID_Missione) 
		REFERENCES Missione(ID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT commento_amministratore FOREIGN KEY (ID_Amministratore) 
		REFERENCES Amministratore(ID)
		ON DELETE NO ACTION
        ON UPDATE CASCADE
);


DELIMITER $$ 
CREATE TRIGGER check_caposquadra -- vincolo caposquadra 
AFTER INSERT ON Effettua
FOR EACH ROW
BEGIN
DECLARE n_caposquadra INT;
SELECT COUNT(*) INTO n_caposquadra
FROM Effettua
WHERE ID_Missione = NEW.ID_Missione AND caposquadra = TRUE;
IF n_caposquadra = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Almeno un caposquadra deve essere assegnato
alla missione.';
END IF;
END$$
CREATE TRIGGER check_caposquadra_update
AFTER UPDATE ON Effettua
FOR EACH ROW
BEGIN
DECLARE n_caposquadra INT;
SELECT COUNT(*) INTO n_caposquadra
FROM Effettua
WHERE ID_Missione = NEW.ID_Missione AND caposquadra = TRUE;
IF n_caposquadra = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Non è possibile aggiornare: ogni missione
deve avere almeno un caposquadra.';
END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_qta_materiale -- vincolo materiali
BEFORE INSERT ON Utilizza
FOR EACH ROW
BEGIN
DECLARE qta_attuale INT;
SELECT qtaDisponibile INTO qta_attuale
FROM Materiale
WHERE ID = NEW.ID_Materiale;
IF NEW.qtaImpiegata > qta_attuale THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Quantità impiegata superiore a quella
disponibile.';
END IF;
-- Aggiorna la quantità disponibile
UPDATE Materiale
SET qtaDisponibile = qtaDisponibile - NEW.qtaImpiegata
WHERE ID = NEW.ID_Materiale;
END$$
CREATE TRIGGER recupero_materiale_su_missione_chiusa
AFTER UPDATE ON Missione
FOR EACH ROW
BEGIN
-- Se la missione è impostata come conclusa
IF OLD.timestampFine IS NULL AND NEW.timestampFine IS NOT NULL THEN
-- Per ogni materiale usato nella missione, somma di nuovo la quantità
UPDATE Materiale M
JOIN Utilizza U ON M.ID = U.ID_Materiale
SET M.qtaDisponibile = M.qtaDisponibile + U.qtaImpiegata
WHERE U.ID_Missione = NEW.ID;
END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_patente_compatibile -- vincolo patenti
BEFORE INSERT ON Impiega
FOR EACH ROW
BEGIN
DECLARE tipo_patente_necessaria VARCHAR(15);
DECLARE compatibili INT;
SELECT patenteNecessaria
INTO tipo_patente_necessaria
FROM Mezzo
WHERE ID = NEW.ID_Mezzo;
-- Conta quanti operatori della squadra hanno una patente compatibile
SELECT COUNT(*) INTO compatibili
FROM Effettua E
JOIN Patente P ON P.ID_Operatore = E.ID_Operatore
JOIN Contiene C ON C.numero_Patente = P.numero
JOIN Tipo T ON T.ID = C.ID_Tipo
WHERE E.ID_Missione = NEW.ID_Missione
AND T.nome = tipo_patente_necessaria;
IF compatibili = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Nessun operatore della missione possiede una
patente compatibile con il mezzo.';
END IF;
END$$
DELIMITER ;
