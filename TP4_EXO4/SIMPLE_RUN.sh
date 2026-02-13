#!/bin/bash

# ============================================
# Script SIMPLES para executar simulações gem5
# Usa binários já compilados do repositório
# ============================================

set -e

GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Caminhos dos binários existentes no repositório
BLOWFISH_BIN="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/blowfish/bftest"
DIJKSTRA_SMALL="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_small.c"
DIJKSTRA_LARGE="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_large.c"

echo "========================================"
echo "Simulações gem5 - TP4 Exercício 4"
echo "========================================"
echo ""

# Verificar gem5
if [ ! -f "${GEM5_BINARY}" ]; then
    echo "ERRO: gem5 não encontrado em ${GEM5_BINARY}"
    echo "Verifique se gem5 está compilado em ${GEM5_ROOT}"
    exit 1
fi

echo "✓ gem5 encontrado: ${GEM5_BINARY}"
echo ""

# Verificar binários
if [ -f "${BLOWFISH_BIN}" ]; then
    echo "✓ BlowFish binário encontrado: ${BLOWFISH_BIN}"
else
    echo "✗ BlowFish não encontrado em ${BLOWFISH_BIN}"
fi

echo ""
echo "========================================"
echo "Binários disponíveis no repositório:"
echo "========================================"
echo ""

# Listar todos os binários disponíveis
find "${REPO_ROOT}/archive/ES201-TP/TP4/Projet" -type f ! -name "*.c" ! -name "*.h" ! -name "*.doc" 2>/dev/null | while read file; do
    if file "$file" | grep -q "ELF"; then
        echo "  - $(basename "$file"): $(file -b "$file" | cut -d',' -f1)"
    fi
done

echo ""
echo "========================================"
echo "Menu de Opções"
echo "========================================"
echo ""
echo "1) Informações sobre gem5"
echo "2) Listar arquivos fonte Dijkstra"
echo "3) Listar arquivos fonte BlowFish"
echo "4) Testar gem5 com um binário simples"
echo "5) Sair"
echo ""

read -p "Escolha uma opção (1-5): " choice

case $choice in
    1)
        echo ""
        echo "Versão gem5:"
        "${GEM5_BINARY}" --version 2>&1 || true
        echo ""
        ;;
    2)
        echo ""
        echo "Arquivos Dijkstra encontrados:"
        find "${REPO_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra" -type f
        echo ""
        ;;
    3)
        echo ""
        echo "Arquivos BlowFish encontrados:"
        find "${REPO_ROOT}/archive/ES201-TP/TP4/Projet/blowfish" -type f
        echo ""
        ;;
    4)
        echo ""
        echo "Testando gem5 com blowfish..."
        echo "Comando que seria executado:"
        echo "${GEM5_BINARY} -c ${SCRIPT_DIR}/gem5_config.py --binary=${BLOWFISH_BIN}"
        echo ""
        ;;
    5)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida!"
        exit 1
        ;;
esac

echo ""
echo "Próximos passos:"
echo "1. Compile Dijkstra para RISC-V usando as fontes em .c"
echo "2. Use o script gem5_config.py para simular"
echo "3. Ou, peça ajuda para criar um script de compilação completo"
echo ""
