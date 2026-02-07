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
    printf("Iniciando P1 (Normale)...\n");

    int i, j, k;
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            for (k = 0; k < N; k++) {
                // Acesso direto à memória a cada iteração
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    printf("Fim P1.\n");
    return 0;
}