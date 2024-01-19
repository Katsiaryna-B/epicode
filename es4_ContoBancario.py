#Conto bancario con attributo saldo e metodo operazioni
class ContoBancario:
    def __init__(self, saldo):
        self.saldo = saldo
    
    def operazioni(self, n):
        new = self.saldo + n
        if new < 0:
            print('non è possibile effettuare operazione')
            new = self.saldo
        return new
    
contoCliente = ContoBancario(100)
saldoNuovo = contoCliente.operazioni(-20)
print(saldoNuovo)
