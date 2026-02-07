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
    printf("Iniciando P4 (Unroll)...\n");

    int i, j, k;
    int temp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            temp = 0;
            // Loop desenrolado: passo 4
            for (k = 0; k < N; k += 4) {
                temp += A[i][k]   * B[k][j];
                temp += A[i][k+1] * B[k+1][j];
                temp += A[i][k+2] * B[k+2][j];
                temp += A[i][k+3] * B[k+3][j];
            }
            C[i][j] = temp;
        }
    }

    printf("Fim P4.\n");
    return 0;
}