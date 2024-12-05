import pygame
import numpy as np

COR_FUNDO = (10, 10, 10)  # Cor do fundo (preto)
COR_CELULA_VIVA = (0, 0, 255)  # Cor das células vivas (azul)

# Função para atualizar o estado das células
def atualizar(tela, celulas, tamanho):
    # Cria uma matriz para armazenar o próximo estado das células
    novas_celulas = np.zeros((celulas.shape[0], celulas.shape[1]))

    # Percorre cada célula da matriz
    for linha, coluna in np.ndindex(celulas.shape):
        # Conta o número de vizinhos vivos ao redor da célula
        vizinhos_vivos = np.sum(celulas[linha-1:linha+2, coluna-1:coluna+2]) - celulas[linha, coluna]
        # Define a cor da célula com base no estado atual
        if celulas[linha, coluna] == 0:
            cor = COR_FUNDO
        else:
            cor = COR_CELULA_VIVA

        # Aplica as regras do Jogo da Vida
        if celulas[linha, coluna] == 1:  # Se a célula está viva
            if 2 <= vizinhos_vivos <= 3:
                novas_celulas[linha, coluna] = 1  # Sobrevive
        else:  # Se a célula está morta
            if vizinhos_vivos == 3:
                novas_celulas[linha, coluna] = 1  # Torna-se viva

        # Desenha a célula na tela
        pygame.draw.rect(tela, cor, (coluna * tamanho, linha * tamanho, tamanho - 1, tamanho - 1))

    return novas_celulas  # Retorna o novo estado das células