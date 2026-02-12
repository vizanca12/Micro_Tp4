#!/bin/bash

# Script de simulation gem5 pour TP4 Exercice 4
# Teste différentes configurations de cache L1 pour Cortex A7 et A15 en RISC-V

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARIES_DIR="${SCRIPT_DIR}/binaries"
RESULTS_DIR="${SCRIPT_DIR}/results"

# Créer le répertoire des résultats
mkdir -p "${RESULTS_DIR}"

echo "=========================================="
echo "Simulation gem5 - TP4 Exercice 4"
echo "=========================================="

# Vérifier que gem5 est disponible
if ! command -v gem5 &> /dev/null; then
    echo "Erreur: gem5 n'est pas trouvé dans le PATH"
    echo "Assurez-vous que gem5 est installé et disponible dans le PATH"
    exit 1
fi

# Configurer gem5
GEM5_BINARY="gem5"
GEM5_SCRIPT="${SCRIPT_DIR}/gem5_config.py"

# ========== Configuration Cortex A7 en RISC-V ==========
echo ""
echo "Configuration: Cortex A7 (RISC-V)"
echo "Variation de L1 cache: 1KB, 2KB, 4KB, 8KB, 16KB"
echo ""

# Paramètres de base pour A7 (simplifié en RISC-V)
A7_FETCH_WIDTH=4
A7_DECODE_WIDTH=4
A7_COMMIT_WIDTH=2
A7_RUU_SIZE=8
A7_L2_SIZE=512

for L1_SIZE in 1 2 4 8 16; do
    echo "  A7 - L1: ${L1_SIZE}KB..."
    
    RESULT_DIR="${RESULTS_DIR}/A7_L1_${L1_SIZE}KB"
    mkdir -p "${RESULT_DIR}"
    
    # Dijkstra
    ${GEM5_BINARY} \
        --outdir="${RESULT_DIR}/dijkstra" \
        -c "${GEM5_SCRIPT}" \
        --processor="a7" \
        --l1i_size="${L1_SIZE}KB" \
        --l1d_size="${L1_SIZE}KB" \
        --l2_size="${A7_L2_SIZE}KB" \
        --l1_assoc="2" \
        --l2_assoc="8" \
        --binary="${BINARIES_DIR}/dijkstra" \
        2>&1 | tee "${RESULT_DIR}/dijkstra.log" || true
    
    # BlowFish
    ${GEM5_BINARY} \
        --outdir="${RESULT_DIR}/blowfish" \
        -c "${GEM5_SCRIPT}" \
        --processor="a7" \
        --l1i_size="${L1_SIZE}KB" \
        --l1d_size="${L1_SIZE}KB" \
        --l2_size="${A7_L2_SIZE}KB" \
        --l1_assoc="2" \
        --l2_assoc="8" \
        --binary="${BINARIES_DIR}/blowfish" \
        2>&1 | tee "${RESULT_DIR}/blowfish.log" || true
done

# ========== Configuration Cortex A15 en RISC-V ==========
echo ""
echo "Configuration: Cortex A15 (RISC-V)"
echo "Variation de L1 cache: 2KB, 4KB, 8KB, 16KB, 32KB"
echo ""

# Paramètres de base pour A15 (simplifié en RISC-V)
A15_FETCH_WIDTH=8
A15_DECODE_WIDTH=8
A15_COMMIT_WIDTH=4
A15_RUU_SIZE=16
A15_L2_SIZE=512

for L1_SIZE in 2 4 8 16 32; do
    echo "  A15 - L1: ${L1_SIZE}KB..."
    
    RESULT_DIR="${RESULTS_DIR}/A15_L1_${L1_SIZE}KB"
    mkdir -p "${RESULT_DIR}"
    
    # Dijkstra
    ${GEM5_BINARY} \
        --outdir="${RESULT_DIR}/dijkstra" \
        -c "${GEM5_SCRIPT}" \
        --processor="a15" \
        --l1i_size="${L1_SIZE}KB" \
        --l1d_size="${L1_SIZE}KB" \
        --l2_size="${A15_L2_SIZE}KB" \
        --l1_assoc="2" \
        --l2_assoc="16" \
        --binary="${BINARIES_DIR}/dijkstra" \
        2>&1 | tee "${RESULT_DIR}/dijkstra.log" || true
    
    # BlowFish
    ${GEM5_BINARY} \
        --outdir="${RESULT_DIR}/blowfish" \
        -c "${GEM5_SCRIPT}" \
        --processor="a15" \
        --l1i_size="${L1_SIZE}KB" \
        --l1d_size="${L1_SIZE}KB" \
        --l2_size="${A15_L2_SIZE}KB" \
        --l1_assoc="2" \
        --l2_assoc="16" \
        --binary="${BINARIES_DIR}/blowfish" \
        2>&1 | tee "${RESULT_DIR}/blowfish.log" || true
done

echo ""
echo "=========================================="
echo "Simulations terminées!"
echo "Résultats disponibles dans: ${RESULTS_DIR}/"
echo "=========================================="
