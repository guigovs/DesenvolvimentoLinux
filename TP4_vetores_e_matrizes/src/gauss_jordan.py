import numpy as np

def gauss_jordan(A, b):
    n = len(b)

    for i in range(n):
        # Verifica se o pivô é zero
        if np.isclose(A[i, i], 0):
            raise ValueError("O pivô é zero. O sistema pode ser incompatível ou indeterminado.")
        
        # Normaliza a linha do pivô
        pivo = A[i, i]
        A[i] /= pivo
        b[i] /= pivo
        
        # Zera os elementos acima e abaixo do pivô
        for j in range(n):
            if j != i:
                fator = A[j, i]
                A[j] -= fator * A[i]
                b[j] -= fator * b[i]

    return b
