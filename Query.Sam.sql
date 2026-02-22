INSERT INTO Richiesta_Soccorso ( -- 1. Inserimento di una richiesta di soccorso.
    UUID,
    validata,
    descrizione,
    coordinate,
    indirizzo,
    ID_Segnalante
) VALUES (
    UUID_TO_BIN(UUID()),
    TRUE,
    'Incidente tra due camion',
    POINT(55.7558, 37.6173), 
    'Prospekt Mira, Mosca',
    1
);


UPDATE Missione -- 3. Chiusura (modifica) di una missone
SET
    timestampFine = NOW(),
    livello_successo = 'successo'
WHERE ID = 3;


SELECT COUNT(*) AS numero_missioni_concluse
FROM Effettua e
JOIN Missione m ON e.ID_Missione = m.ID
WHERE e.ID_Operatore = 1
  AND m.timestampFine IS NOT NULL;


SELECT COUNT(*) AS richieste_negli_ultimi_36h -- 7. Numero richieste da un segnalante (tramite mail/IP) nelle ultime 36 h
FROM Richiesta_Soccorso r
JOIN Segnalante s ON r.ID_Segnalante = s.ID
WHERE
    s.email = 'carlo@gmail.com'
    OR s.IP = '192.168.1.10'
    AND r.dataOraApertura >= NOW() - INTERVAL 36 HOUR;
   
-- 9. Missioni stesso luogo in 3 anni

-- semplice 
SELECT m2.*
FROM Missione m1
JOIN Richiesta_Soccorso r1 ON m1.UUID_Richiesta_Soccorso = r1.UUID
JOIN Missione m2 ON m2.ID <> m1.ID
JOIN Richiesta_Soccorso r2 ON m2.UUID_Richiesta_Soccorso = r2.UUID
WHERE ST_Equals(r1.coordinate, r2.coordinate)
  AND m2.timestampInizio >= DATE_SUB(m1.timestampInizio, INTERVAL 3 YEAR)
  AND m1.ID = 1;

-- posso creare una vista, cosi poi richiamo semplicemente con un comando
CREATE VIEW MissioniStessoLuogo AS 
SELECT m2.*
FROM Missione m1
JOIN Richiesta_Soccorso r1 ON m1.UUID_Richiesta_Soccorso = r1.UUID
JOIN Missione m2 ON m2.ID <> m1.ID
JOIN Richiesta_Soccorso r2 ON m2.UUID_Richiesta_Soccorso = r2.UUID
WHERE ST_Equals(r1.coordinate, r2.coordinate)
  AND m2.timestampInizio >= DATE_SUB(m1.timestampInizio, INTERVAL 3 YEAR)
  AND m1.ID = 1;
-- poi comando per chiamare
SELECT * FROM MissioniStessoLuogo;

-- oppure una STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE TrovaMissioniStessoLuogo(IN id_missione_input INT)
BEGIN
    SELECT m2.*
    FROM Missione m1
    JOIN Richiesta_Soccorso r1 ON m1.UUID_Richiesta_Soccorso = r1.UUID
    JOIN Missione m2 ON m2.ID <> m1.ID
    JOIN Richiesta_Soccorso r2 ON m2.UUID_Richiesta_Soccorso = r2.UUID
    WHERE ST_Equals(r1.coordinate, r2.coordinate)
      AND m2.timestampInizio >= DATE_SUB(m1.timestampInizio, INTERVAL 3 YEAR)
      AND m1.ID = id_missione_input;
END //
DELIMITER ;
-- la uso con call
CALL TrovaMissioniStessoLuogo(1);



SELECT -- 11. Operatori nelle missioni che non hanno preso il massimo 
    o.ID,
    o.nome,
    o.cognome,
    COUNT(*) AS missioni_insoddisfacenti
FROM Effettua e
JOIN Missione m ON e.ID_Missione = m.ID
JOIN Operatore o ON e.ID_Operatore = o.ID
WHERE m.livello_successo IN ('fallimento', 'scarso', 'parziale', 'moderato', 'quasi_successo')
GROUP BY o.ID
ORDER BY missioni_insoddisfacenti DESC;


SELECT -- 13. Ore utilizzo mateeriale con ID 1
    m.nome,
    SEC_TO_TIME(SUM(TIMESTAMPDIFF(SECOND, mi.timestampInizio, mi.timestampFine))) AS ore_uso
FROM Utilizza u
JOIN Missione mi ON u.ID_Missione = mi.ID
JOIN Materiale m ON u.ID_Materiale = m.ID
WHERE m.ID = 1 AND mi.timestampFine IS NOT NULL
GROUP BY m.ID;

-- QUERY LUCA
-- query 2
SET @RandomID = (SELECT UUID FROM Richiesta_Soccorso WHERE validata =
TRUE ORDER BY RAND() LIMIT 1);
INSERT INTO Missione(obiettivo, UUID_Richiesta_soccorso ) VALUES (
"L'obiettivo della missione è concludere la missione",
@RandomID -- sostiture con l'ID della richiesta di soccorso a cui si vuole associare la missione
);

-- query 4
SELECT * FROM Operatore O
WHERE NOT EXISTS (
SELECT 1
FROM Effettua E
JOIN Missione M ON E.ID_Missione = M.ID
WHERE E.ID_Operatore = O.ID AND M.timestampFine IS NULL
);

-- query 6
-- anno specifico
SELECT AVG(TIMESTAMPDIFF(HOUR, M.timestampInizio, M.timestampFine)) AS
tempo_medio_in_ore FROM Missione M
WHERE YEAR(M.timestampInizio) = 2025;
-- per ciascun caposquadra
SELECT O.id, O.nome, O.cognome, AVG(TIMESTAMPDIFF(HOUR,
M.timestampInizio, M.timestampFine)) AS tempo_medio_in_ore FROM Missione
M
JOIN Effettua E ON M.timestampFine IS NOT NULL AND M.ID =
E.ID_Missione -- escludo le missioni non terminate
JOIN Operatore O ON E.caposquadra = TRUE AND O.ID = E.ID_Operatore -- prendo solo i capisquadra
GROUP BY O.id;

-- query 8
SELECT O.id, O.nome, O.cognome, SUM(TIMESTAMPDIFF(HOUR,
M.timestampInizio, M.timestampFine)) AS tempo_in_ore FROM Missione M
JOIN Effettua E ON M.timestampFine IS NOT NULL AND M.ID =
E.ID_Missione -- escludo le missioni non terminate
JOIN Operatore O ON O.ID = E.ID_Operatore
WHERE O.id = 5;

-- query 10
SELECT RS.* FROM Richiesta_Soccorso RS
JOIN Missione M ON RS.UUID = M.UUID_Richiesta_Soccorso
WHERE M.timestampFine IS NOT NULL AND M.livello_successo < 'successo';

-- query 12
SELECT Mi.ID AS Missione, Mi.timestampFine AS data_ora FROM Mezzo Me
JOIN Impiega I ON I.ID_Mezzo = Me.ID
JOIN Missione Mi ON Mi.ID = I.ID_Missione
WHERE Mi.timestampFine IS NOT NULL AND Me.ID = 2
ORDER BY Mi.timestampFine DESC;

-- query 13 
SELECT Ma.ID, Ma.nome, SUM(TIMESTAMPDIFF(HOUR, Mi.timestampInizio,
Mi.timestampFine)) AS ore_uso FROM Materiale Ma
JOIN Utilizza U ON U.ID_Materiale = Ma.ID
JOIN Missione Mi ON Mi.timestampFine IS NOT NULL AND Mi.ID =
U.ID_Missione
WHERE Ma.ID = 3