#include <stdio.h>
#include <stdlib.h>

#define N 64

int A[N][N];
int B[N][N];
int C[N][N];

void init_matrices() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand() % 10;
            B[i][j] = rand() % 10;
            C[i][j] = 0;
        }
    }
}

int main() {
    init_matrices();
    printf("Iniciando P2 (Pointeur)...\n");

    int i, j, k;
    int *pA, *pB, *pC;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            pC = &C[i][j];
            pA = &A[i][0]; // Aponta para o inicio da linha i de A
            pB = &B[0][j]; // Aponta para o inicio da coluna j de B
            
            for (k = 0; k < N; k++) {
                *pC += (*pA) * (*pB);
                pA++;       // Avança 1 posição (próxima coluna)
                pB += N;    // Avança N posições (próxima linha)
            }
        }
    }

    printf("Fim P2.\n");
    return 0;
}