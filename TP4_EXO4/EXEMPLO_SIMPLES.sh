#!/bin/bash

# ============================================
# EXEMPLO SIMPLES - Como usar gem5
# ============================================

GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"

echo "============================================"
echo "Testando gem5..."
echo "============================================"
echo ""

# Verificar gem5
if [ ! -f "${GEM5_BINARY}" ]; then
    echo "ERRO: gem5 não encontrado"
    echo "Esperado em: ${GEM5_BINARY}"
    echo ""
    echo "Verifique:"
    echo "  1. gem5 está compilado?"
    echo "  2. O caminho ${GEM5_ROOT} está correto?"
    exit 1
fi

echo "✓ gem5 encontrado!"
echo "  Caminho: ${GEM5_BINARY}"
echo ""

# Testar versão
echo "Versão gem5:"
"${GEM5_BINARY}" --version 2>&1 || true

echo ""
echo "============================================"
echo "Opções para executar simulações:"
echo "============================================"
echo ""
echo "OPÇÃO 1: Criar um binário RISC-V simples"
echo "  $ riscv64-unknown-elf-gcc -o hello hello.c"
echo "  $ ${GEM5_BINARY} -c config.py --binary=hello"
echo ""
echo "OPÇÃO 2: Usar binários ARM/x86 existentes"
echo "  $ find . -executable -type f"
echo ""
echo "OPÇÃO 3: Consultar documentação gem5"
echo "  Veja em: ${GEM5_ROOT}/configs/example"
echo ""

# Criar diretório de resultados
RESULT_DIR="$(dirname "$0")/results"
mkdir -p "$RESULT_DIR"

echo "Diretório de resultados: $RESULT_DIR"
echo ""
echo "Próximo passo: Compile um programa RISC-V simples e execute com gem5!"
echo ""
