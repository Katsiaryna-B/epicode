
# PRATICA
# classe Persona con attributi nome, cognome, età, metodo per stampare info
class Persona:
    def __init__(self, nome, cognome, eta):
        self.nome = nome
        self.cognome = cognome
        self.eta = eta
        
    def stampaInfo(self):
        print(self.nome, self.cognome, self.eta)

persona = Persona('kate', 'white', '33')
persona.stampaInfo()
