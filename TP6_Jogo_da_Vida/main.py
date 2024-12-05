import pygame
import numpy as np
from src.jogo_da_vida import atualizar

COR_GRADE = (40, 40, 40)  # Cor da grade (cinza escuro)

if __name__ == '__main__':
    pygame.init()

    # Configuração da janela e do tamanho dos quadrados (células)
    tamanho_celula = 15  # Cada célula terá 15x15 pixels
    tamanho_grade = 40  # A matriz será de 40x40 células
    tamanho_tela = tamanho_celula * tamanho_grade  # Calcula o tamanho total da janela
    tela = pygame.display.set_mode((tamanho_tela, tamanho_tela))
    pygame.display.set_caption("Jogo da Vida")  # Título da janela

    # Inicializa a matriz de células (todas mortas no início)
    celulas = np.zeros((tamanho_grade, tamanho_grade))
    tela.fill(COR_GRADE)  # Preenche o fundo com a cor da grade
    atualizar(tela, celulas, tamanho_celula)
    pygame.display.flip()

    rodando = False  # Variável para controlar o avanço automático

    while True:
        for evento in pygame.event.get():
            if evento.type == pygame.QUIT:  # Sai do jogo se fechar a janela
                pygame.quit()
            elif evento.type == pygame.KEYDOWN:
                if evento.key == pygame.K_SPACE:  # Avança para a próxima geração
                    celulas = atualizar(tela, celulas, tamanho_celula)
                    pygame.display.update()
                elif evento.key == pygame.K_r:  # Reseta a grade (todas as células mortas)
                    celulas = np.zeros((tamanho_grade, tamanho_grade))
                    atualizar(tela, celulas, tamanho_celula)
                    pygame.display.update()
                elif evento.key == pygame.K_RETURN:  # Avança automaticamente até a geração final
                    rodando = not rodando

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

        # Avança automaticamente se rodando for True
        if rodando:
            nova_geracao = atualizar(tela, celulas, tamanho_celula)
            pygame.display.update()
            pygame.time.wait(1)  # Pausa entre as gerações
            if np.array_equal(celulas, nova_geracao):  # Verifica se a geração final foi atingida
                rodando = False  # Para de rodar quando não houver mudanças
            celulas = nova_geracao
