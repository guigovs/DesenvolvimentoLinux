from scipy import linalg
from src.gauss_jordan import gauss_jordan, np
from src.input_data import input_data

if __name__ == '__main__':

    matriz_a = []
    vetor_b = []
    matriz_a, vetor_b = input_data()

    #matriz_a = [[3, 2, 4], [1, 1, 2], [4, 3, -2]]
    #vetor_b = [1, 2, 3]

    matriz_a = np.array(matriz_a, dtype=float)
    vetor_b = np.array(vetor_b, dtype=float)
    try:
        solucao_numpy = gauss_jordan(matriz_a, vetor_b)
        print("\nSolução (Numpy):", solucao_numpy.round(3))
        solucao_scipy = linalg.solve(matriz_a, vetor_b)
        print("Solução (Scipy):", solucao_scipy.round(3))
    except ValueError as e:
        print("\nErro:", e)
