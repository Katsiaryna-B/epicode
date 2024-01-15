/*
#Domanda1. Trovare il totale delle vendite per ogni mese
SELECT month(DataTransazione), SUM(ImportoTotaleTransazione)
FROM BuildWeek.transazioni_dataset
GROUP BY month(DataTransazione)
ORDER BY month(DataTransazione) ASC;

#Domanda 2: Identifica i tre prodotti più venduti e la loro quantità venduta.
SELECT t.ProdottoID,  NomeProdotto, SUM(QuantitaAcquistata)
FROM BuildWeek.transazioni_dataset t
JOIN prodotti_dataset p ON t.ProdottoID=p.ProdottoID 
GROUP BY ProdottoID
ORDER BY SUM(QuantitaAcquistata) DESC
LIMIT 3;


#Domanda 3: Trova il cliente che ha effettuato il maggior numero di acquisti.
SELECT NomeCliente, COUNT(IDTransazione), t.ClienteID
FROM BuildWeek.clienti_dataset c
JOIN transazioni_dataset t ON c.ClienteID=t.ClienteID
GROUP BY c.ClienteID                          
ORDER BY COUNT(IDTransazione) DESC
LIMIT 3;


#4 Media di transazione: '56.861620'
SELECT AVG(ImportoTotaleTransazione)
FROM BuildWeek.transazioni_dataset


#5 Analisi Categoria Prodotto: categoria con maggior numero di vendite: LIBRI, '865', or ProdottoID 3577 Libri
SELECT p.Categoria, t.ProdottoID, SUM(QuantitaAcquistata)
FROM BuildWeek.transazioni_dataset t
JOIN prodotti_dataset p ON t.ProdottoID=p.ProdottoID
GROUP BY t.ProdottoID                    
ORDER BY SUM(QuantitaAcquistata) DESC;


#6 Cliente Fedele - Domanda: Identifica il cliente con il maggior valore totale di acquisti.
SELECT c.NomeCliente, SUM(ImportoTotaleTransazione), Count(IDTransazione)
FROM BuildWeek.clienti_dataset c
JOIN transazioni_dataset t ON c.ClienteID=t.ClienteID
GROUP BY c.ClienteID
order by SUM(ImportoTotaleTransazione) DESC
LIMIT 3;


# Domanda 7: Calcola la percentuale di spedizioni con "Consegna Riuscita".
SELECT COUNT(
	CASE 
		WHEN StatusConsegna='Consegna Riuscita' 
        THEN 1 
        END)/COUNT(*) as PercConsRius
    FROM BuildWeek.spedizioni_dataset;
    
#Domanda8: Trova il prodotto con la recensione media più alta
SELECT NomeProdotto, AVG(Rating), COUNT(RatingID)
FROM BuildWeek.ratings_dataset r
JOIN prodotti_dataset p
ON r.ProductID = p.ProdottoID
GROUP BY ProductID
ORDER BY AVG(Rating) DESC, COUNT(RatingID) DESC LIMIT 5;

# 9 Domanda: Calcola la variazione percentuale nelle vendite rispetto al mese precedente.
SELECT month(DataTransazione), 
	SUM(ImportoTotaleTransazione) as VenditeMeseCorr, 
    SUM(ImportoTotaleTransazione)-LAG(SUM(ImportoTotaleTransazione), 1,0) OVER (ORDER BY MONTH(DataTransazione)) as Differenza,
    (SUM(ImportoTotaleTransazione)-LAG(SUM(ImportoTotaleTransazione), 1,0) OVER (ORDER BY MONTH(DataTransazione)))/LAG(SUM(ImportoTotaleTransazione), 1,0) OVER (ORDER BY MONTH(DataTransazione))
FROM BuildWeek.transazioni_dataset
GROUP BY month(DataTransazione)
ORDER BY month(DataTransazione) ASC;


#Domanda10: Determina la quantità media disponibile per categoria di prodotto
SELECT Categoria, AVG(QuantitaDisponibile) as MediaPerCategoria
FROM BuildWeek.prodotti_dataset
GROUP BY Categoria;

#Domanda11: Domanda: Trova il metodo di spedizione più utilizzato.
SELECT COUNT(MetodoSpedizione), MetodoSpedizione
FROM BuildWeek.spedizioni_dataset
GROUP BY MetodoSpedizione
ORDER BY COUNT(MetodoSpedizione) DESC;


#Domanda 12: Calcola il numero medio di clienti registrati al mese.
SELECT AVG(ttt.conteggio) as mediaClientiRegistrati
FROM ( 
	SELECT MONTH(DataRegistrazione), COUNT(ClienteID) conteggio
	FROM BuildWeek.clienti_dataset
	GROUP BY MONTH(DataRegistrazione)) ttt
    ;
  
#Domanda 13: Identifica i prodotti con una quantità disponibile inferiore alla media.
SELECT NomeProdotto
FROM BuildWeek.prodotti_dataset
where QuantitaDisponibile < 
	(SELECT AVG(QuantitaDisponibile)
	FROM BuildWeek.prodotti_dataset);
 
-- Domanda 13: Identifica i prodotti con una quantità disponibile inferiore alla media. by Categoria
SELECT Categoria, Count(NomeProdotto) as NumeroProdotti
FROM BuildWeek.prodotti_dataset
WHERE QuantitaDisponibile < 
	(SELECT AVG(QuantitaDisponibile)
	FROM BuildWeek.prodotti_dataset)
GROUP BY Categoria 
 
 #Domanda 14: Per ogni cliente, elenca i prodotti acquistati e il totale speso
 SELECT ClienteID, ProdottoID, SUM(ImportoTotaleTransazione)
 FROM BuildWeek.transazioni_dataset
 GROUP BY ClienteID, ProdottoID;
 

#Domanda 15: Identifica il mese con il maggior importo totale delle vendite
SELECT MONTH(DataTransazione), SUM(ImportoTotaleTransazione) as VenditeTotali
FROM BuildWeek.transazioni_dataset
GROUP BY MONTH(DataTransazione)
ORDER BY SUM(ImportoTotaleTransazione) DESC LIMIT 1;

# 16 Domanda: Trova la quantità totale di prodotti disponibili in magazzino
SELECT SUM(QuantitaDisponibile)
FROM BuildWeek.prodotti_dataset


#17 clienti che non hanno fatto un acquisto
SELECT COUNT(d.NomeCliente) 
FROM
	(SELECT NomeCliente, IDTransazione
	FROM BuildWeek.clienti_dataset c
	LEFT JOIN transazioni_dataset t 
	ON c.ClienteID = t.ClienteID
	Where t.IDTransazione is NULL) d;


#18 Domanda: Calcola il totale delle vendite per ogni anno.
SELECT YEAR(DataTransazione), SUM(ImportoTotaleTransazione)
FROM BuildWeek.transazioni_dataset
GROUP BY YEAR(DataTransazione);

#19 Domanda: Trova la percentuale di spedizioni con "In Consegna" rispetto al totale.
SELECT COUNT(
	CASE 
		WHEN StatusConsegna='In Consegna' THEN 1
        WHEN StatusConsegna='Consegna Ruiscita' THEN 0
        END)/COUNT(*) as PercConsRius
    FROM BuildWeek.spedizioni_dataset;


-- SELECT COUNT(DISTINCT(ClienteID))# 475
-- FROM BuildWeek.transazioni_dataset


#Recensioni: media 
   SELECT AVG(Rating) #2.4850
   FROM ratings_dataset
  
# Recensioni: clienti che hanno fatto almeno un ordine   
SELECT AVG(Rating) #2.5918
FROM ratings_dataset
WHERE CustomerID IN (
	SELECT DISTINCT(ClienteID)
	FROM BuildWeek.transazioni_dataset)
    
# Recensioni: clienti che NON hanno fatto almeno un ordine  
SELECT AVG(Rating) #2.4735
FROM ratings_dataset
WHERE CustomerID NOT IN (
	SELECT DISTINCT(ClienteID)
	FROM BuildWeek.transazioni_dataset)


#Tempo di preparazione del’ordine
 SELECT AVG(datediff(DataSpedizione,DataTransazione)) as media, 
		MAX(datediff(DataSpedizione,DataTransazione)) as max, 
        MIN(datediff(DataSpedizione,DataTransazione)) as min
 FROM spedizioni_dataset
 ;


-- SELECT COUNT(DISTINCT(ProductID)) #4348
-- FROM BuildWeek.ratings_dataset

-- SELECT COUNT(DISTINCT(ClienteID))# 486 prodotti 475 Clienti
-- FROM BuildWeek.transazioni_dataset


# Consegna lenta per spedizioni in consegna
SELECT MetodoSpedizione,  AVG(datediff(CURDATE(), DataSpedizione)) as media, MAX(datediff(CURDATE(), DataSpedizione)) as max, MIN(datediff(CURDATE(), DataSpedizione)) as min
FROM transazioni_dataset
WHERE StatusSpedizione = 'In consegna'
GROUP BY MetodoSpedizione ;


# Recensioni di clienti che hanno fatto piu acquisti (700, 4063) or con piu valore totale  2105
SELECT AVG(Rating), CustomerID
FROM ratings_dataset
WHERE CustomerID IN (700, 4063, 2105)
GROUP BY CustomerID
  
  
# Recensioni di prodotti piu venduti
SELECT  NomeProdotto, AVG(Rating)
FROM ratings_dataset r
RIGHT JOIN prodotti_dataset p ON r.ProductID = p.ProdottoID
WHERE p.NomeProdotto IN ('Prodotto 3485', 'Prodotto 4360', 'Prodotto 1154')
GROUP BY p.NomeProdotto


# Recensioni dei clienti con tempo preparazione ordine veloce, 30gg    
SELECT AVG(r.Rating) AS AverageRating, t.ClienteID
FROM transazioni_dataset t
JOIN ratings_dataset r ON r.CustomerID = t.ClienteID
WHERE DATEDIFF(t.DataSpedizione, t.DataTransazione) < 30
GROUP BY t.ClienteID;
 */ 
 


 

