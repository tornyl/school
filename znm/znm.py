import numpy as np



# matice A
"""
A = np.array([[1, -1, 0],
              [1, -2, 0],
              [-1, 1, 2]])
"""

A = np.array([[2, -1, 0],
              [1, -1, 0],
              [1/2, 0, 1/2]])

# pocatecni vektor
pocatecni_vektor = np.array([1,0,0])

# maximalni pocet iteraci
max_iteraci = 1000

def mocninna_metoda (A, pocatecni_vektor, tolerance= 1e-6):

    v = pocatecni_vektor
    vlastni_cislo = np.nan

    for i in range(max_iteraci):

        vl_pred = vlastni_cislo


        v_norm = v / np.linalg.norm(v) 
        v = A @ v_norm

        vlastni_cislo = v_norm.T @ v

        print("iter:",i, " v_norm iter -1:",v_norm," v:",v," vlastni cislo:",vlastni_cislo)
        
        if np.abs(vlastni_cislo - vl_pred) < tolerance: 
            break
    return vlastni_cislo


mocninna_metoda(A, pocatecni_vektor)
    
