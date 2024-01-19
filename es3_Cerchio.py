# class Cerchio con attributo raggio, metodi area e circonferenza
class Cerchio:
    def __init__(self, raggio):
        self.raggio = raggio
        
    def area(self):
        p = 3.14
        calcolo1 = p*self.raggio**2
        return calcolo1
    
    def circonferenza(self):
        p = 3.14
        calcolo2 = 2*p*self.raggio
        return calcolo2

esempio = Cerchio(3)
print('area', esempio.area(), 'circonferenza', esempio.circonferenza())
    
