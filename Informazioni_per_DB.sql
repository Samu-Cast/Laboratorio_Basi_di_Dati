INSERT INTO Operatore (nome, cognome, dataDiNascita, luogoDiNascita, cf) VALUES
('Mario', 'Rossi', '1985-04-12', 'Roma', 'RSSMRA85D12H501Z'),
('Luigi', 'Verdi', '1990-07-23', 'Milano', 'VRDLGI90L23F205X'),
('Giovanni', 'Bianchi', '1988-01-30', 'Torino', 'BNCGNN88A30B963Y'),
('Anna', 'Neri', '1993-09-15', 'Firenze', 'NRNNA93P15T234W'),
('Elena', 'Gialli', '1995-03-14', 'Bologna', 'GLLNLE95C14G273S');
SELECT * FROM Operatore;

INSERT INTO Amministratore (nome, cognome, dataDiNascita, luogoDiNascita, cf) VALUES
('Marco', 'Esposito', '1980-06-10', 'Napoli', 'ESPMAK80H10L219V'),
('Simona', 'Romano', '1987-12-20', 'Palermo', 'ROMSIM87T20P702U'),
('Paolo', 'Conti', '1978-08-05', 'Genova', 'CONPAO78M05G273Y'),
('Francesca', 'De Luca', '1992-02-14', 'Bari', 'DELFRN92B14A345R');
SELECT * FROM Operatore;

INSERT INTO Patente (numero, dataScadenza, ID_Operatore) VALUES
('PAT123456', '2028-12-31', 1),
('PAT789012', '2027-06-30', 2),
('PAT345678', '2029-03-15', 3),
('PAT901234', '2027-11-30', 4);
SELECT * FROM Patente;

INSERT INTO Tipo (nome) VALUES
('Motocicli'),
('Automobili'),
('Veicoli pesanti');
SELECT * FROM Tipo;

INSERT INTO Contiene (ID_Tipo, numero_Patente) VALUES
(1, 'PAT123456'),
(2, 'PAT789012'),
(3, 'PAT345678'),
(1, 'PAT901234');
SELECT * FROM Contiene;

INSERT INTO Abilita (descrizione) VALUES
('Primo Soccorso'),
('Spegnimento Incendi'),
('Supporto Medico Avanzato'),
('Salvataggio Acquatico'),
('Elettricità Civile');
SELECT * FROM Abilita;

INSERT INTO Possiede (ID_Operatore, ID_Abilita, certificato) VALUES
(1, 1, 'CERT_PS_001'),
(1, 2, 'CERT_SI_002'),
(2, 3, 'CERT_SMA_003'),
(3, 4, 'CERT_SA_004'),
(4, 5, 'CERT_EC_005'),
(5, 1, 'CERT_PS_005'),
(5, 5, 'CERT_EC_006');
SELECT * FROM Possiede;

INSERT INTO Conosce (ID_Amministratore, ID_Abilita, certificato) VALUES
(1, 1, 'ADMIN_CERT_001'),
(1, 2, 'ADMIN_CERT_002'),
(2, 3, 'ADMIN_CERT_003'),
(3, 4, 'ADMIN_CERT_004'),
(4, 5, 'ADMIN_CERT_005');
SELECT * FROM Conosce;

INSERT INTO Materiale (nome, dataScadenza, descrizione, qtaDisponibile) VALUES
('Kit Pronto Soccorso', '2026-12-31', 'Confezione completa di bendaggi e disinfettanti', 10),
('Estintore Portatile', '2027-06-30', 'Estintore a polvere 2kg', 15),
('Maschera Antifumo', '2025-09-30', 'Maschera autorespiratoria', 8),
('Coperta Termica', '2024-12-31', 'Per soccorsi in ambienti freddi', 20),
('Cavo di Traino', '2028-12-31', 'Cavo robusto per recupero veicoli', 5),
('Scala', '2026-12-31', 'Scala portatile, lunghezza 4 metri', 5),
('Kit attrezzi', '2027-06-30', 'Martello, Avvitatore, Metro, Livella', 8),
('Corda da Soccorso', '2025-12-31', 'Corda di emergenza lunga 30m', 10),
('Kit defibrillatore', '2024-12-31', 'Defibrillatore, Ventilatore portatile', 20),
('Pompa tira acqua', '2027-03-31', 'Per allagamenti', 3);
SELECT * FROM Materiale;

INSERT INTO Mezzo (targa, nome, descrizione, carburante, patenteNecessaria) VALUES
('AB123CD', 'Ambulanza Base', 'Veicolo per emergenze sanitarie', 'Diesel', 2), -- tipo 2 = Automobili (B)
('EF456GH', 'Autopompa Antincendio', 'Per interventi su incendi strutturali', 'Benzina', 3), -- tipo 3 = Veicoli pesanti (C)
('XY789ZX', 'Motovedetta', 'Barca per salvataggio in mare', 'Gasolio', 1), -- tipo 1 = Motocicli (A)
('KL567MN', 'Fuoristrada', 'Veicolo per terreni impervi', 'Metano', 2); -- tipo 2 = Automobili (B)
SELECT * FROM Mezzo;

INSERT INTO Segnalante (nome, email, IP) VALUES
('Pino Rossi', 'pinorossi@example.com', '192.168.1.12'),
('Maria Bianchi', 'bianchi.maria@example.com', '192.168.1.17');
SELECT * FROM Segnalante;

INSERT INTO Richiesta_Soccorso (
    UUID,
    validata,
    descrizione,
    coordinate,
    indirizzo,
    ID_Segnalante
) VALUES
(UUID_TO_BIN(UUID()), TRUE, 'Incidente stradale', POINT(45.0703, 7.6868), 'Via Roma 1, Torino', 1),
(UUID_TO_BIN(UUID()), TRUE, 'Incendio domestico', POINT(45.0637, 7.7094), 'Via Garibaldi 10, Torino', 2),
(UUID_TO_BIN(UUID()), TRUE, 'Persona scomparsa', POINT(44.4938, 11.3426), 'Parco di Firenze', 3),
(UUID_TO_BIN(UUID()), TRUE, 'Allagamento', POINT(44.5048, 11.3426), 'Strada statale, Bologna', 4),
(UUID_TO_BIN(UUID()), TRUE, 'Incidente stradale', POINT(45.0703, 7.6868), 'Via Roma 2, Torino', 1);
SET @nuovo_uuid = (SELECT UUID FROM Richiesta_Soccorso ORDER BY dataOraApertura DESC LIMIT 1);
SELECT * FROM Richiesta_Soccorso;

INSERT INTO Missione (
    timestampInizio,
    timestampFine,
    obiettivo,
    UUID_Richiesta_Soccorso,
    livello_successo
) VALUES
(NOW(), NOW() + INTERVAL 1 HOUR, 'Recupero veicolo incidentato', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 1), 'successo'),
(NOW(), NOW() + INTERVAL 2 HOUR, 'Sgombero fumo da appartamento', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 2), 'moderato'),
(NOW(), NOW() + INTERVAL 3 HOUR, 'Ricerca persona dispersa', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 3), 'parziale'),
(NOW(), NOW() + INTERVAL 2 HOUR, 'Asciugatura strada allagata', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 4), 'scarso'),
(NOW(), 'Recupero veicoli incidentati', @nuovo_uuid, 'successo');
SELECT * FROM Missione;

INSERT INTO Effettua (ID_Missione, ID_Operatore, caposquadra) VALUES
(1, 1, TRUE),
(1, 2, FALSE),
(2, 1, TRUE),
(2, 3, FALSE),
(3, 4, TRUE),
(3, 5, FALSE),
(4, 2, TRUE),
(4, 1, FALSE);
SELECT * FROM Effettua;

INSERT INTO Impiega (ID_Missione, ID_Mezzo) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);
SELECT * FROM Impiega;

INSERT INTO Utilizza (ID_Missione, ID_Materiale, qtaImpiegata) VALUES
(1, 1, 1),
(1, 4, 1),
(2, 2, 2),
(2, 5, 1),
(3, 3, 1),
(4, 1, 1),
(4, 2, 1),
(6, 2, 1),
(6, 6, 1);
SELECT * FROM Utilizza;

INSERT INTO Foto (percorso, ID_Richiesta_Soccorso) VALUES
('/foto/incidente1.jpg', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 1)),
('/foto/incendio1.jpg', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 2)),
('/foto/scomparsa1.jpg', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 3)),
('/foto/allagamento1.jpg', (SELECT UUID FROM Richiesta_Soccorso WHERE ID_Segnalante = 4));
SELECT * FROM Foto;

INSERT INTO Aggiorna (ID_Missione, ID_Amministratore, testo) VALUES
(1, 1, 'Missione avviata correttamente'),
(2, 2, 'Richiesto supporto extra'),
(3, 3, 'Problemi tecnici al mezzo'),
(4, 4, 'Tempo di intervento superiore al previsto');
SELECT * FROM Aggiorna;

INSERT INTO Commento (ID_Missione, ID_Amministratore, testo) VALUES
(1, 1, 'Buon lavoro, missione completata rapidamente'),
(2, 2, 'Intervento efficace ma lungo'),
(3, 3, 'Equipaggiamento insufficiente'),
(4, 4, 'Necessario migliorare la tempistica');
SELECT * FROM Commento