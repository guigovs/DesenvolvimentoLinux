import pygame
import numpy as np

# Cores
COR_FUNDO = (10, 10, 10)  # Cor do fundo (preto)
COR_GRADE = (40, 40, 40)  # Cor da grade (cinza escuro)
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
        cor = COR_FUNDO if celulas[linha, coluna] == 0 else COR_CELULA_VIVA

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

# Função principal
def main():
    pygame.init()

    # Configuração da janela e do tamanho dos quadrados (células)
    tamanho_celula = 15  # Cada célula terá 15x15 pixels
    tamanho_grade = 40  # A matriz será de 40x40 células
    tamanho_tela = tamanho_celula * tamanho_grade  # Calcula o tamanho total da janela
    tela = pygame.display.set_mode((tamanho_tela, tamanho_tela))
    pygame.display.set_caption("Jogo da Vida - Conway")  # Título da janela

    # Inicializa a matriz de células (todas mortas no início)
    celulas = np.zeros((tamanho_grade, tamanho_grade))
    tela.fill(COR_GRADE)  # Preenche o fundo com a cor da grade
    atualizar(tela, celulas, tamanho_celula)
    pygame.display.flip()

    while True:
        for evento in pygame.event.get():
            if evento.type == pygame.QUIT:  # Sai do jogo se fechar a janela
                pygame.quit()
                return
            elif evento.type == pygame.KEYDOWN:
                if evento.key == pygame.K_SPACE:  # Avança para a próxima geração
                    celulas = atualizar(tela, celulas, tamanho_celula)
                    pygame.display.update()
                elif evento.key == pygame.K_r:  # Reseta a grade (todas as células mortas)
                    celulas = np.zeros((tamanho_grade, tamanho_grade))
                    atualizar(tela, celulas, tamanho_celula)
                    pygame.display.update()

            # Interação com o mouse para adicionar ou remover células
            if pygame.mouse.get_pressed()[0]:  # Botão esquerdo adiciona célula viva
                posicao = pygame.mouse.get_pos()
                celulas[posicao[1] // tamanho_celula, posicao[0] // tamanho_celula] = 1
                atualizar(tela, celulas, tamanho_celula)
                pygame.display.update()
            elif pygame.mouse.get_pressed()[2]:  # Botão direito remove célula viva
                posicao = pygame.mouse.get_pos()
                celulas[posicao[1] // tamanho_celula, posicao[0] // tamanho_celula] = 0
                atualizar(tela, celulas, tamanho_celula)
                pygame.display.update()

        tela.fill(COR_GRADE)  # Preenche a grade

if __name__ == '__main__':
    main()
