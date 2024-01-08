-- Creazione della tabella Vendite
CREATE TABLE Vendite (
    id_transazione VARCHAR (10) PRIMARY KEY,
    categoria VARCHAR(50),
    costo DECIMAL (10,2),
    sconto DECIMAL (10,2)
);

-- Creazione della tabella dettagli_vendite
CREATE TABLE dettagli_vendite (
    id_transazione VARCHAR (10) PRIMARY KEY,
    data_acquisto DATE,
    quantita INT
);

INSERT INTO Vendite (id_transazione, categoria, costo, sconto) VALUES
    ('t001', 'Libri', 34, 0.1),
    ('t002', 'Libri', 14, 0.15),
    ('t003', 'Libri', 24, 0.55),
    ('t004', 'Giochi', 90, 0.1),
    ('t005', 'Giochi', 10, 0.55),
    ('t006', 'Giochi', 40, 0.04),
    ('t007', 'Giochi', 56, 0.05),
    ('t008', 'Cancelleria', 4, 0),
    ('t009', 'Cancelleria', 1.2, 0),
    ('t010', 'Cancelleria', 1.5, 0),
    ('t011', 'Giochi', 2.3, 0),
    ('t012', 'Abbigliamento', 10, 0.2),
    ('t013', 'Abbigliamento', 7, 0.2),
    ('t014', 'Abbigliamento', 18, 0.15),
    ('t015', 'Abbigliamento', 32, 0.15),
    ('t016', 'Abbigliamento',83, 0.15),
    ('t017', 'Abbigliamento', 94, 0.15),
    ('t018', 'Libri', 24, 0.1),
    ('t019', 'Libri', 3, 0.15),
    ('t020', 'Libri', 9, 0.55),
    ('t021', 'Giochi', 12, 0.1),
    ('t022', 'Giochi', 15, 0.06),
    ('t023', 'Giochi', 23, 0.07),
    ('t024', 'Giochi', 53, 0.09),
    ('t025', 'Cancelleria', 2.9, 0),
    ('t026', 'Cancelleria', 1.3, 0),
    ('t027', 'Cancelleria', 1.9, 0),
    ('t028', 'Giochi', 5.4, 0.1),
    ('t029', 'Abbigliamento', 12, 0.4),
    ('t030', 'Abbigliamento', 34, 0.4),
    ('t031', 'Abbigliamento', 18, 0.25),
    ('t032', 'Abbigliamento', 25, 0.35),
    ('t033', 'Abbigliamento', 61, 0.65),
    ('t034', 'Abbigliamento', 14, 0.65)
;

INSERT INTO dettagli_vendite (id_transazione, data_acquisto, quantita) VALUES
    ('t001', '2024-01-03', 1),
    ('t002', '2019-09-10', 3),
    ('t003', '2021-11-27', 5),
    ('t004', '2022-12-20', 1),
    ('t005', '2022-12-20', 2),
    ('t006', '2019-02-12', 1),
    ('t007', '2020-01-07', 4),
    ('t008', '2021-03-03', 3),
    ('t009', '2023-04-03', 1),
    ('t010', '2022-05-09', 2),
    ('t011', '2021-06-10', 1),
    ('t012', '2020-05-14', 1),
    ('t013', '2019-07-21', 2),
    ('t014', '2019-08-08', 1),
    ('t015', '2021-10-13', 2),
    ('t016', '2019-10-04', 1),
    ('t017', '2019-11-23', 2),
    ('t018', '2021-05-01', 2),
    ('t019', '2020-04-07', 2),
    ('t020', '2021-04-11', 2),
    ('t021', '2022-03-14', 2),
    ('t022', '2021-01-16', 2),
    ('t023', '2021-02-18', 2),
    ('t024', '2019-04-21', 2),
    ('t025', '2019-05-23', 2),
    ('t026', '2022-05-25', 10),
    ('t027', '2023-07-27', 4),
    ('t028', '2023-09-30', 2),
    ('t029', '2023-10-23', 2),
    ('t030', '2022-10-30', 2),
    ('t031', '2021-10-24', 2),
    ('t032', '2022-12-20', 2),
    ('t033', '2023-12-12', 2),
    ('t034', '2019-11-11', 2)     
    ;

#SELECT * FROM Vendite;
#SELECT * FROM dettagli_vendite;


# Query Semplici, seleziona tutte le vendite avvenute Dec 20, 2022
SELECT * FROM dettagli_vendite 
WHERE data_acquisto = '2022-12-20';


# elenco delle vendite con sconti maggiori del 50%
SELECT * FROM Vendite
WHERE sconto > 0.5;


# 4 Aggregazione dei Dati. Calcola il totale costo delle vendite per categoria
ALTER TABLE Vendite
ADD COLUMN prezzo_finale DECIMAL (10,2);

UPDATE Vendite
SET prezzo_finale = costo*(1-sconto);


SELECT categoria, SUM(prezzo_finale) as TotaleConSconto
FROM Vendite v
GROUP BY categoria;


#Trova il numero totale di prodotti venduti per ogni categoria
SELECT categoria, SUM(quantita)
FROM Vendite v
JOIN dettagli_vendite d ON v.id_transazione = d.id_transazione
GROUP BY categoria;


#5 Funzioni di Data. Seleziona le vendite dell'ultimo trimestre
SELECT d.id_transazione, v.categoria, v.costo
FROM dettagli_vendite d
JOIN Vendite v ON d.id_transazione=v.id_transazione
WHERE QUARTER(data_acquisto)=QUARTER(CURDATE()) AND YEAR(data_acquisto)=YEAR(CURDATE());


#raggruppa le vendite per mese e calcola il totale delle vendite per ogni mese
CREATE VIEW VenditePerMese (mese, TotaleVenditeMese) 
as SELECT MONTH(v2.data_acquisto) as mese, 
        SUM(v2.CostoTotaleTransazione) as TotaleVenditeMese
    FROM (
        SELECT v.id_transazione, d.data_acquisto, prezzo_finale*quantita as CostoTotaleTransazione
        FROM Vendite v 
        JOIN dettagli_vendite d ON v.id_transazione=d.id_transazione) v2
    GROUP BY MONTH(v2.data_acquisto)
    ORDER BY MONTH (v2.data_acquisto) ASC;

#SELECT * FROM VenditePerMese;

#7Analisi degli sconti. Trova la categoria con lo sconto medio piu alto.
SELECT categoria, AVG(sconto) as ScontoMedio
FROM Vendite
GROUP BY categoria
ORDER BY ScontoMedio DESC 
LIMIT 1;


#8. Variazioni delle Vendite. Confronta le vendite mese per mese per vedere l'incremento or il decremento delle vendite. Calcola l'incremento/decremento mese per mese
#Variazione Gennaio-Febbraio
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=2)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=1) as 'VarFebbraio-Gennaio';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=3)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=2) as 'VarMarzo-Febbraio';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=4)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=3) as 'VarAprile-Marzo';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=5)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=4) as 'VarMaggio-Aprile';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=6)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=5) as 'VarGiugno-Aprile';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=7)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=6) as 'VarLuglio-Giugno';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=8)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=7) as 'VarAgosto-Luglio';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=9)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=8) as 'VarSettembre-Agosto';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=10)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=9) as 'VarOttobre-Settembre';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=11)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=10) as 'VarNovembre-Ottobre';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=12)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=11) as 'VarDicembre-Novembre';
SELECT (SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=1)-(SELECT TotaleVenditeMese FROM VenditePerMese WHERE mese=12) as 'VarGennaio-Dicembre';
#Mesi con l'incremento delle vendite Aprile, Luglio, Agosto, Settembre, Ottobre, Novembre, Gennaio


#9. Confronta le vendite totali in diverse stagioni
#Calcola vendite totali in Inverno (mese 1,2, 12), Primavera (3,4,5), Estate(6,7,8), Autunno (9,10,11)
SELECT SUM(TotaleVenditeMese) as TotaleInverno
FROM VenditePerMese
WHERE mese IN (1,2,12);

SELECT SUM(TotaleVenditeMese) as TotalePrimavera
FROM VenditePerMese
WHERE mese IN (3,4,5);

SELECT SUM(TotaleVenditeMese) as TotaleEstate
FROM VenditePerMese
WHERE mese IN (6,7,8);

SELECT SUM(TotaleVenditeMese) as TotaleAutunno
FROM VenditePerMese
WHERE mese IN (9,10,11);



#10. Clienti Fedeli. Creare tabella clienti con campi IDcliente, IDvendita. Trovare i top 5 clienti con il maggior numero d'acquisti
-- Creazione della tabella clienti
CREATE TABLE clienti (
    id_cliente INT,
    id_vendita VARCHAR (10)
);
INSERT INTO clienti (id_cliente, id_vendita) VALUES
(1, 't001'),
    (2, 't002'),
    (3, 't003'),
    (4, 't004'),
    (1, 't005'),
    (2, 't006'),
    (3, 't007'),
    (5, 't008'),
    (10, 't009'),
    (11, 't010'),
    (7, 't011'),
    (8, 't012'),
    (10, 't013'),
    (11, 't014'),
    (13, 't015'),
    (3, 't016'),
    (5, 't017'),
    (6, 't018'),
    (10, 't019'),
    (8, 't020'),
    (10, 't021'),
    (2, 't022'),
    (7, 't023'),
    (11, 't024'),
    (12, 't025'),
    (13,  't026'),
    (10, 't027'),
    (11, 't028'),
    (7, 't029'),
    (8, 't030'),
    (5, 't031'),
    (6, 't032'),
    (4, 't033'),
    (3, 't034')     
    ;

#Trovare top 5 clienti che hanno fatto maggior numero di acquisti
SELECT id_cliente, COUNT(id_vendita) as TotaleNumeroAcquisti
FROM clienti
GROUP BY id_cliente
ORDER BY COUNT(id_vendita) DESC
LIMIT 5;


#Per trovare top 5 clienti che hanno comprato piu articoli 
SELECT id_cliente, SUM(v2.quantita) as TotaleNumeroArticoliAcquistati
FROM clienti c
JOIN (SELECT v.id_transazione, prezzo_finale, quantita, prezzo_finale*quantita as CostoTotaleTransazione
    FROM Vendite v 
    JOIN dettagli_vendite d ON v.id_transazione=d.id_transazione) v2 ON c.id_vendita=v2.id_transazione
GROUP BY c.id_cliente
ORDER BY SUM(quantita) DESC
LIMIT 5;

#Per trovare top 5 clienti che hanno speso di piu
SELECT id_cliente, SUM(v2.CostoTotaleTransazione) as TotaleSpesa
FROM clienti c
JOIN (SELECT v.id_transazione, prezzo_finale*quantita as CostoTotaleTransazione
    FROM Vendite v 
    JOIN dettagli_vendite d ON v.id_transazione=d.id_transazione) v2 ON c.id_vendita=v2.id_transazione
GROUP BY c.id_cliente
ORDER BY SUM(v2.CostoTotaleTransazione) DESC
LIMIT 5;

#Per trovare vendite totali per ogni anno
SELECT YEAR(data_acquisto), SUM(v2.CostoTotaleTransazione) as TotaleSpesa
FROM Vendite v
JOIN (SELECT v.id_transazione, data_acquisto, prezzo_finale*quantita as CostoTotaleTransazione
    FROM Vendite v 
    JOIN dettagli_vendite d ON v.id_transazione=d.id_transazione) v2 ON v.id_transazione=v2.id_transazione
GROUP BY YEAR(data_acquisto)
ORDER BY YEAR(data_acquisto) DESC;



#Per ogni cliente trovare quanto ha speso e ha risparmiato in totale, ordinare dal maggior risparmio
SELECT id_cliente, SUM(v2.CostoTotaleTransazione) as TotaleSpesa, SUM(RisparmioPerTransazione) as TotaleRisparmio
FROM clienti c
JOIN (SELECT v.id_transazione, prezzo_finale*quantita as CostoTotaleTransazione, costo*quantita*sconto as RisparmioPerTransazione
    FROM Vendite v 
    JOIN dettagli_vendite d ON v.id_transazione=d.id_transazione) v2 ON c.id_vendita=v2.id_transazione
GROUP BY c.id_cliente
ORDER BY SUM(v2.RisparmioPerTransazione) DESC;






