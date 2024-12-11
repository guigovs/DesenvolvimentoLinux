import threading
import random
import time
from queue import Queue

class Estoque:
    def __init__(self, capacidade=10):
        self.estoque = Queue(maxsize=capacidade)
        self.condicao = threading.Condition()  # Condition para gerenciar o acesso ao estoque

    def armazenar_item(self, produtor_id, item_id):
        with self.condicao:  # Usando Condition para garantir acesso sincronizado ao estoque
            while self.estoque.full():
                print(f"Estoque cheio! Produtor {produtor_id} aguardando.")
                self.condicao.wait()  # Espera até que haja espaço no estoque
            self.estoque.put((produtor_id, item_id))
            print(f"Produtor {produtor_id} armazena o item {item_id}.")
            self.condicao.notify_all()  # Notifica os consumidores que um item foi adicionado

    def fornecer_item(self, consumidor_id):
        with self.condicao:  # Usando Condition para garantir acesso sincronizado ao estoque
            while self.estoque.empty():
                print(f"Estoque vazio! Consumidor {consumidor_id} aguardando.")
                self.condicao.wait()  # Espera até que haja itens no estoque
            item_id = self.estoque.get()
            print(f"Consumidor {consumidor_id} recebe o item {item_id}.")
            self.condicao.notify_all()  # Notifica os produtores que um item foi retirado
            return item_id

class Produtor(threading.Thread):
    def __init__(self, id, estoque, parar_evento):
        super().__init__()
        self.id = id
        self.estoque = estoque
        self.item_id = 0
        self.parar_evento = parar_evento  # Evento de parada

    def run(self):
        while not self.parar_evento.is_set():  # Condição de parada
            time.sleep(random.uniform(1, 5))  # Tempo aleatório entre 1 e 5 segundos
            self.item_id += 1
            self.estoque.armazenar_item(self.id, self.item_id)

class Consumidor(threading.Thread):
    def __init__(self, id, estoque, parar_evento):
        super().__init__()
        self.id = id
        self.estoque = estoque
        self.parar_evento = parar_evento  # Evento de parada

    def run(self):
        while not self.parar_evento.is_set():  # Condição de parada
            time.sleep(random.uniform(1, 3))  # Tempo aleatório entre 1 e 3 segundos
            self.estoque.fornecer_item(self.id)

def main():
    estoque = Estoque()

    # Evento para sinalizar a parada das threads
    parar_evento = threading.Event()

    # Criando uma lista de produtores
    produtores = []
    for i in range(1, 4):
        produtor = Produtor(i, estoque, parar_evento)
        produtores.append(produtor)

    # Criando uma lista de consumidores
    consumidores = []
    for i in range(1, 4):
        consumidor = Consumidor(i, estoque, parar_evento)
        consumidores.append(consumidor)

    # Iniciando os produtores
    for produtor in produtores:
        produtor.start()

    # Iniciando os consumidores
    for consumidor in consumidores:
        consumidor.start()

    # Deixa o sistema rodar por 30 segundos
    time.sleep(15)

    # Sinaliza para todas as threads pararem
    parar_evento.set()

    # Espera as threads dos produtores terminarem
    for produtor in produtores:
        produtor.join()

    # Espera as threads dos consumidores terminarem
    for consumidor in consumidores:
        consumidor.join()

if __name__ == "__main__":
    main()
