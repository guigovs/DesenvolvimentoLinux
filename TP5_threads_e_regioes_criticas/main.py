import threading
import random
import time
from queue import Queue

class Estoque:
    def __init__(self):
        self.fila = Queue(maxsize=10)

    def adicionar(self, item, produtor_id):
        self.fila.put(item)
        print(f"Produtor {produtor_id} armazena item {item[1]}.")

    def remover(self, consumidor_id):
        item = self.fila.get()
        print(f"Consumidor {consumidor_id} recebe item {item[1]}.")
        return item


class Produtor(threading.Thread):
    def __init__(self, produtor_id, estoque):
        super().__init__()
        self.produtor_id = produtor_id
        self.estoque = estoque
        self.contador_item = 0

    def run(self):
        while True:
            tempo_producao = random.randint(1, 5)
            time.sleep(tempo_producao)  # Simula o tempo de produção
            self.contador_item += 1
            item = (self.produtor_id, self.contador_item)
            self.estoque.adicionar(item, self.produtor_id)


class Consumidor(threading.Thread):
    def __init__(self, consumidor_id, estoque):
        super().__init__()
        self.consumidor_id = consumidor_id
        self.estoque = estoque

    def run(self):
        while True:
            tempo_consumo = random.randint(1, 3)
            time.sleep(tempo_consumo)  # Simula o tempo de consumo
            self.estoque.remover(self.consumidor_id)


if __name__ == "__main__":
    estoque = Estoque()

    produtores = []
    consumidores = []
    for i in range(3):
        produtor = Produtor(produtor_id=i+1, estoque=estoque)
        produtores.append(produtor)
        consumidor = Consumidor(consumidor_id=i+1, estoque=estoque)
        consumidores.append(consumidor)

    for produtor in produtores:
        produtor.start()

    for consumidor in consumidores:
        consumidor.start()

    for produtor in produtores:
        produtor.join()

    for consumidor in consumidores:
        consumidor.join()
