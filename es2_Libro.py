# class libro con attributi 
class Libro:
    def __init__(self, titolo, autore, anno):
        self.titolo = titolo
        self.autore = autore
        self.anno = anno
        
    def seRecente(self):
        if self.anno >= 2023:
            print ('recente')
        else:
            print('non recente')
            

libro1 = Libro('interessante', 'famoso', 2019)
libro1.seRecente()

