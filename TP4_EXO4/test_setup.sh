#!/bin/bash

# Script de teste para verificar a configuração

echo "============================================"
echo "TESTE DE CONFIGURAÇÃO - TP4 EXO4"
echo "============================================"
echo ""

RISCV_GCC="riscv64-unknown-elf-gcc"
GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"

# ==== TESTE 1: Compilador RISC-V ====
echo "[1/5] Testando compilador RISC-V..."
if command -v ${RISCV_GCC} &> /dev/null; then
    echo "  ✓ ${RISCV_GCC} encontrado"
    ${RISCV_GCC} --version | head -n 1 | sed 's/^/  /'
else
    echo "  ✗ ${RISCV_GCC} não encontrado"
    echo "    Instale com: sudo apt-get install gcc-riscv64-unknown-elf"
fi

echo ""

# ==== TESTE 2: gem5 ====
echo "[2/5] Testando gem5..."
if [ -f "${GEM5_BINARY}" ]; then
    echo "  ✓ gem5 encontrado: ${GEM5_BINARY}"
    echo "  Tamanho: $(du -h "${GEM5_BINARY}" | cut -f1)"
else
    echo "  ✗ gem5 não encontrado em:"
    echo "    ${GEM5_BINARY}"
    echo ""
    echo "  Procurando alternativas em ${GEM5_ROOT}..."
    if [ -d "${GEM5_ROOT}" ]; then
        find "${GEM5_ROOT}" -name "gem5*" -type f 2>/dev/null | head -5 | sed 's/^/    /'
    fi
fi

echo ""

# ==== TESTE 3: Python ====
echo "[3/5] Testando Python..."
if command -v python3 &> /dev/null; then
    echo "  ✓ Python3 encontrado"
    python3 --version | sed 's/^/  /'
else
    echo "  ✗ Python3 não encontrado"
fi

echo ""

# ==== TESTE 4: Scripts ====
echo "[4/5] Verificando scripts..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in 01_compile_riscv.sh 02_run_simulations.sh 03_analyze_results.py; do
    if [ -f "${SCRIPT_DIR}/${script}" ]; then
        echo "  ✓ ${script} encontrado"
    else
        echo "  ✗ ${script} não encontrado"
    fi
done

echo ""

# ==== TESTE 5: Arquivos de dados ====
echo "[5/5] Verificando arquivos de dados..."
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

if [ -f "${PROJECT_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_small.c" ]; then
    echo "  ✓ Dijkstra source encontrado"
else
    echo "  ✗ Dijkstra source não encontrado"
fi

if [ -f "${PROJECT_ROOT}/archive/ES201-TP/TP4/Projet/blowfish/bftest.c" ]; then
    echo "  ✓ BlowFish source encontrado"
else
    echo "  ✗ BlowFish source não encontrado"
fi

echo ""
echo "============================================"
echo "RESUMO DO TESTE"
echo "============================================"
echo ""

# Contar sucessos e falhas
success=0
[ -f "${GEM5_BINARY}" ] && ((success++))
command -v ${RISCV_GCC} &> /dev/null && ((success++))
command -v python3 &> /dev/null && ((success++))

echo "Status: ${success}/3 verificações OK"
echo ""

if [ ${success} -eq 3 ]; then
    echo "✓ Tudo pronto para começar!"
    echo ""
    echo "Próximo passo: bash START_HERE.sh"
else
    echo "⚠ Algumas configurações estão faltando."
    echo "Consulte as instruções acima para resolver."
fi

echo ""
