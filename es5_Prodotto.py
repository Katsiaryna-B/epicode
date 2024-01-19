# class Prodotto con attributi nome, prezzo, quantita. metodi costo_totale e disponibilita
class Prodotto:
    def __init__(self, nome, prezzo, quantita):
        self.nome = nome
        self.prezzo = prezzo
        self.quantita = quantita
    
    def costo_totale(self):
        totale = self.prezzo*self.quantita
        return totale
    
    def disponibilita(self):
        if self.quantita is None:
            print('prodotto non disponibile')
            return self.quantita
        else:
            return self.quantita
        
prodotto = Prodotto('chocolate', 10,3)
costoTotale = prodotto.costo_totale()
Disponibilita = prodotto.disponibilita()
print(costoTotale, Disponibilita)
