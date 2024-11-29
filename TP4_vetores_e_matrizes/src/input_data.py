def input_data():
    dimensao = int(input('\nInforme quantas linhas terá a matriz A: '))
    print('\nOBS: Escreva os números separados por espaço seguindo a seguinte formatação: X X ...\n')
    matriz_a = []
    for i in range(dimensao):
        linha = input(f'Números da {i+1}ª linha da matriz A: ')
        linha = linha.split(' ')
        while len(linha) != dimensao:
            print(f'É necessário ser informado uma quantidade de {dimensao} números na linha!')
            linha = input(f'Números da {i+1}ª linha da matriz A: ')
            linha = linha.split(' ')
        linha = [int(i) for i in linha]
        matriz_a.append(linha)

    print('')
    vetor_b = input(f'Informe os {dimensao} números do vetor B: ')
    vetor_b = vetor_b.split(' ')
    while len(vetor_b) != dimensao:
        print(f'É necessário ser informado uma quantidade de {dimensao} números para o vetor B!')
        vetor_b = input(f'Informe os {dimensao} números do vetor B: ')
        vetor_b = vetor_b.split(' ')
    b = [int(i) for i in vetor_b]

    return matriz_a, b
