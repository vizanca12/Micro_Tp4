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
    printf("Iniciando P3 (Tempo)...\n");

    int i, j, k;
    int temp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            temp = 0; // Acumula em variável local (registrador)
            for (k = 0; k < N; k++) {
                temp += A[i][k] * B[k][j];
            }
            C[i][j] = temp; // Escreve na memória só 1 vez
        }
    }

    printf("Fim P3.\n");
    return 0;
}