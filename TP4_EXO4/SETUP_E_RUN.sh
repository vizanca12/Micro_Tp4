#!/bin/bash

# ============================================
# Setup e execução automática de simulações
# Detecta compilador correto e executa
# ============================================

set -e

GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Caminhos
DIJKSTRA_SMALL="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_small.c"
DIJKSTRA_LARGE="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_large.c"
BLOWFISH_SRC="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/blowfish/bftest.c"
BLOWFISH_BIN="${REPO_ROOT}/archive/ES201-TP/TP4/Projet/blowfish/bftest"
OUTPUT_DIR="${SCRIPT_DIR}/binaries"

mkdir -p "$OUTPUT_DIR"

echo "============================================"
echo "Setup e Compilação para TP4 Exercício 4"
echo "============================================"
echo ""

# 1. Verificar gem5
echo "[1/5] Verificando gem5..."
if [ ! -f "${GEM5_BINARY}" ]; then
    echo "  ✗ gem5 não encontrado em ${GEM5_BINARY}"
    exit 1
fi
echo "  ✓ gem5 encontrado"
echo ""

# 2. Verificar compiladores RISC-V
echo "[2/5] Procurando compilador RISC-V..."
RISCV_CC=""

if command -v riscv64-linux-gnu-gcc &> /dev/null; then
    RISCV_CC="riscv64-linux-gnu-gcc"
    echo "  ✓ Compilador RISC-V com Linux: $RISCV_CC"
elif command -v riscv64-unknown-elf-gcc &> /dev/null; then
    RISCV_CC="riscv64-unknown-elf-gcc"
    echo "  ! Compilador bare-metal encontrado (pode ter problemas)"
    echo "    Tente instalar: sudo apt-get install gcc-riscv64-linux-gnu"
else
    echo "  ✗ Nenhum compilador RISC-V encontrado"
    echo "    Instale com: sudo apt-get install gcc-riscv64-linux-gnu"
    echo ""
    echo "    Para agora, pode usar binários já compilados:"
    if [ -f "${BLOWFISH_BIN}" ]; then
        echo "    - BlowFish: ${BLOWFISH_BIN}"
    fi
    exit 1
fi
echo ""

# 3. Compilar Dijkstra
echo "[3/5] Compilando Dijkstra para RISC-V..."

if [ ! -f "${DIJKSTRA_SMALL}" ]; then
    echo "  ✗ Arquivo fonte não encontrado: ${DIJKSTRA_SMALL}"
    exit 1
fi

"${RISCV_CC}" -O2 -o "${OUTPUT_DIR}/dijkstra_small" "${DIJKSTRA_SMALL}"
if [ -f "${DIJKSTRA_LARGE}" ]; then
    "${RISCV_CC}" -O2 -o "${OUTPUT_DIR}/dijkstra_large" "${DIJKSTRA_LARGE}"
fi

echo "  ✓ Dijkstra compilado em ${OUTPUT_DIR}"
echo ""

# 4. Compilar BlowFish
echo "[4/5] Compilando BlowFish para RISC-V..."

if [ ! -f "${BLOWFISH_SRC}" ]; then
    echo "  ! Arquivo fonte não encontrado: ${BLOWFISH_SRC}"
    echo "    Usando binário pré-compilado se disponível..."
    if [ -f "${BLOWFISH_BIN}" ]; then
        cp "${BLOWFISH_BIN}" "${OUTPUT_DIR}/bftest"
        echo "  ✓ BlowFish copiado de ${BLOWFISH_BIN}"
    fi
else
    "${RISCV_CC}" -O2 -o "${OUTPUT_DIR}/bftest" "${BLOWFISH_SRC}"
    echo "  ✓ BlowFish compilado em ${OUTPUT_DIR}"
fi
echo ""

# 5. Listar binários
echo "[5/5] Binários disponíveis:"
echo ""
ls -lh "${OUTPUT_DIR}/" 2>/dev/null | tail -n +2 || echo "  Nenhum binário compilado"
echo ""

# Criar script de teste
cat > "${SCRIPT_DIR}/test_run.sh" << 'TESTSCRIPT'
#!/bin/bash

GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/binaries"

echo "Testando execução com gem5..."
echo ""

if [ ! -f "${GEM5_BINARY}" ]; then
    echo "ERRO: gem5 não encontrado"
    exit 1
fi

if [ ! -f "${OUTPUT_DIR}/dijkstra_small" ]; then
    echo "ERRO: dijkstra_small não compilado"
    exit 1
fi

echo "Executando gem5 com dijkstra_small..."
echo "Comando: ${GEM5_BINARY} -c ${SCRIPT_DIR}/gem5_config.py --binary=${OUTPUT_DIR}/dijkstra_small"
echo ""

# Criar diretório de saída
mkdir -p "${SCRIPT_DIR}/results"

# Executar simulação (exemplo básico)
echo "Nota: Isso pode demorar alguns minutos..."
"${GEM5_BINARY}" \
    --outdir="${SCRIPT_DIR}/results/dijkstra_test" \
    "${SCRIPT_DIR}/gem5_config.py" \
    --binary="${OUTPUT_DIR}/dijkstra_small" \
    2>&1 | tee "${SCRIPT_DIR}/results/test.log" || true

echo ""
echo "Simulação concluída!"
echo "Resultados em: ${SCRIPT_DIR}/results/dijkstra_test/"
TESTSCRIPT

chmod +x "${SCRIPT_DIR}/test_run.sh"

echo "============================================"
echo "Setup Completo!"
echo "============================================"
echo ""
echo "Próximos passos:"
echo "1. Teste a compilação:"
echo "   bash ${SCRIPT_DIR}/test_run.sh"
echo ""
echo "2. Execute simulações completas:"
echo "   bash ${SCRIPT_DIR}/02_run_simulations.sh"
echo ""
echo "3. Analise resultados:"
echo "   python3 ${SCRIPT_DIR}/03_analyze_results.py"
echo ""
