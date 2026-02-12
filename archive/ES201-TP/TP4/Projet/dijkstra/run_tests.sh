#!/bin/bash

# Caminho para o executável do gem5
GEM5_EXEC="/home/vizanca/gem5/build/RISCV/gem5.opt"

# Verifica se o binário existe
if [ ! -f "dijkstra_large.riscv" ]; then
    echo "Erro: Compile primeiro (make)."
    exit 1
fi

echo "=========================================="
echo "      A iniciar benchmarks RISC-V         "
echo "=========================================="

# 1. Simulação CORTEX A7
echo "-> A simular Configuração A7..."
$GEM5_EXEC -d m5out_A7 se_A7.py \
    --cmd=dijkstra_large.riscv

echo "   Resultados A7 guardados em: m5out_A7/stats.txt"

# 2. Simulação CORTEX A15
echo "-> A simular Configuração A15..."
$GEM5_EXEC -d m5out_A15 se_A15.py \
    --cmd=dijkstra_large.riscv

echo "   Resultados A15 guardados em: m5out_A15/stats.txt"
echo "=========================================="