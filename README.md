# Database Soccorso

Database relazionale per la gestione di un sistema di **soccorso e pronto intervento**, sviluppato come progetto per il corso di **Laboratorio Basi di Dati**.

## Descrizione

Il sistema modella le operazioni di un'organizzazione di soccorso, gestendo:

- **Richieste di soccorso** georeferenziate inviate da segnalanti
- **Missioni** con livello di successo, assegnazione operatori e caposquadra
- **Operatori** con abilità certificate e patenti
- **Mezzi** (ambulanze, autopompe, fuoristrada, motovedette)
- **Materiali** con tracciamento quantità e scadenze
- **Amministratori** che aggiornano e commentano le missioni

## Schema del Database

Il database `Soccorso` è composto dalle seguenti tabelle:

| Tabella | Descrizione |
|---|---|
| `Operatore` | Personale operativo con dati anagrafici e CF |
| `Patente` | Patenti associate agli operatori |
| `Tipo` | Categorie di patente (Motocicli, Automobili, Veicoli pesanti) |
| `Contiene` | Associazione tipo–patente |
| `Abilita` | Competenze (Primo Soccorso, Antincendio, ecc.) |
| `Possiede` | Abilità certificate degli operatori |
| `Amministratore` | Personale amministrativo |
| `Conosce` | Abilità certificate degli amministratori |
| `Materiale` | Risorse consumabili con quantità e scadenza |
| `Mezzo` | Veicoli con targa, carburante e patente necessaria |
| `Segnalante` | Chi invia le richieste di soccorso |
| `Richiesta_Soccorso` | Segnalazioni con coordinate GPS e validazione |
| `Foto` | Immagini allegate alle richieste |
| `Missione` | Interventi con timestamp e livello di successo |
| `Effettua` | Assegnazione operatori alle missioni (con ruolo caposquadra) |
| `Utilizza` | Materiali impiegati per missione |
| `Impiega` | Mezzi impiegati per missione |
| `Aggiorna` | Aggiornamenti amministrativi sulle missioni |
| `Commento` | Commenti degli amministratori |

## Vincoli e Trigger

Il database include trigger per garantire la coerenza dei dati:

- **Caposquadra obbligatorio** — Ogni missione deve avere almeno un caposquadra
- **Controllo quantità materiali** — Non si può impiegare più materiale di quello disponibile; la quantità viene decrementata automaticamente
- **Recupero materiali** — Alla chiusura di una missione, i materiali vengono reintegrati
- **Patente compatibile** — Un mezzo può essere assegnato solo se almeno un operatore della squadra possiede la patente necessaria

## Struttura dei File

```
├── soccorso.sql              # Creazione schema (tabelle + trigger)
├── Informazioni_per_DB.sql   # Popolamento con dati di esempio
├── Query.Sam.sql             # Query di interrogazione e stored procedure
└── README.md
```

## Utilizzo

1. **Creare il database e le tabelle:**
   ```sql
   SOURCE soccorso.sql;
   ```

2. **Popolare con dati di esempio:**
   ```sql
   SOURCE Informazioni_per_DB.sql;
   ```

## Query Principali

- Inserimento e chiusura di richieste/missioni
- Conteggio missioni concluse per operatore
- Richieste da un segnalante nelle ultime 36h
- Missioni nello stesso luogo negli ultimi 3 anni (query, vista, stored procedure)
- Operatori con missioni dal risultato insoddisfacente
- Tempo medio di missione per anno e per caposquadra
- Ore di utilizzo di materiali e mezzi
- Operatori attualmente liberi (senza missioni attive)
- Richieste con missioni non completamente riuscite

## Tecnologie

- **DBMS:** MySQL
- **Linguaggio:** SQL (DDL, DML, trigger, stored procedure, viste)
