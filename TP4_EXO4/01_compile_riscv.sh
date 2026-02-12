#!/bin/bash

# Script de compilation des applications pour RISC-V avec gem5
# Utilisé pour le TP4 Exercice 4 - Analyse de performances des caches

set -e  # Exit on error

# Répertoires
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/sources"
BUILD_DIR="${SCRIPT_DIR}/build"
BINARIES_DIR="${SCRIPT_DIR}/binaries"

# Créer les répertoires
mkdir -p "$BUILD_DIR"
mkdir -p "$BINARIES_DIR"

echo "=========================================="
echo "Compilation pour RISC-V avec gem5"
echo "=========================================="

# Configuration du compilateur RISC-V
RISCV_CROSS_COMPILE="riscv64-unknown-elf-"
RISCV_GCC="${RISCV_CROSS_COMPILE}gcc"

# Vérifier que le compilateur RISC-V est disponible
if ! command -v ${RISCV_GCC} &> /dev/null; then
    echo "Erreur: Compilateur RISC-V non trouvé: ${RISCV_GCC}"
    echo "Installez avec: sudo apt-get install gcc-riscv64-unknown-elf"
    exit 1
fi

RISCV_FLAGS="-O2 -march=rv64i -mabi=lp64"

# ========== Compilation Dijkstra ==========
echo ""
echo "Compilation de Dijkstra..."

# Créer un fichier de test de données
cat > "${BUILD_DIR}/dijkstra_input.txt" << 'EOF'
0 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 0 2 3 4 5 6 7 8 9 0 1 3 4 5 6 7 8 9 0 1 2 4 5 6 7 8 9 0 1 2 3 5 6 7 8 9 0 1 2 3 4 6 7 8 9 0 1 2 3 4 5 7 8 9 0 1 2 3 4 5 6 8 9 0 1 2 3 4 5 6 7 9 0 1 2 3 4 5 6 7 8 0 1 2 3
1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 0 2 3 4 5 6 7 8 9 0 1 3 4 5 6 7 8 9 0 1 2 4 5 6 7 8 9 0 1 2 3 5 6 7 8 9 0 1 2 3 4 6 7 8 9 0 1 2 3 4 5 7 8 9 0 1 2 3 4 5 6 8 9 0 1
2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3
5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
6 5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5
7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6
8 7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7
9 8 7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
0 9 8 7 6 5 4 3 2 1 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0
EOF

# Copier et compiler Dijkstra
cp "${SCRIPT_DIR}/../archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_small.c" "${BUILD_DIR}/dijkstra.c"

${RISCV_CROSS_COMPILE}gcc ${RISCV_FLAGS} \
    -o "${BINARIES_DIR}/dijkstra" \
    "${BUILD_DIR}/dijkstra.c"

echo "✓ Dijkstra compilé avec succès"

# ========== Compilation BlowFish ==========
echo ""
echo "Compilation de BlowFish..."

# Copier les fichiers BlowFish
mkdir -p "${BUILD_DIR}/blowfish"
cp "${SCRIPT_DIR}/../archive/ES201-TP/TP4/Projet/blowfish/"*.c "${BUILD_DIR}/blowfish/"
cp "${SCRIPT_DIR}/../archive/ES201-TP/TP4/Projet/blowfish/"*.h "${BUILD_DIR}/blowfish/"

# Compiler BlowFish
${RISCV_CROSS_COMPILE}gcc ${RISCV_FLAGS} \
    -o "${BINARIES_DIR}/blowfish" \
    "${BUILD_DIR}/blowfish/bftest.c" \
    "${BUILD_DIR}/blowfish/bf_skey.c" \
    "${BUILD_DIR}/blowfish/bf_ecb.c" \
    "${BUILD_DIR}/blowfish/bf_cfb64.c" \
    "${BUILD_DIR}/blowfish/bf_ofb64.c" \
    "${BUILD_DIR}/blowfish/bf_cbc.c" \
    "${BUILD_DIR}/blowfish/bf_enc.c" \
    2>/dev/null || true

if [ ! -f "${BINARIES_DIR}/blowfish" ]; then
    # Essayer une compilation alternative plus simple
    ${RISCV_CROSS_COMPILE}gcc ${RISCV_FLAGS} \
        -o "${BINARIES_DIR}/blowfish" \
        "${BUILD_DIR}/blowfish/bftest.c" \
        "${BUILD_DIR}/blowfish/bf_skey.c" \
        "${BUILD_DIR}/blowfish/bf_enc.c"
fi

echo "✓ BlowFish compilé avec succès"

echo ""
echo "=========================================="
echo "Compilation terminée!"
echo "Binaires disponibles dans: ${BINARIES_DIR}/"
echo "=========================================="

# Lister les binaires créés
ls -lh "${BINARIES_DIR}/"
