#!/bin/bash

# Script Quick Start pour TP4 Exercice 4
# Guide étape par étape pour l'exécution du TP

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "TP4 Exercice 4 - Quick Start"
echo "=========================================="
echo ""

# Vérifier les prérequis
echo "Vérification des prérequis..."
echo ""

# Vérifier gem5
if ! command -v gem5 &> /dev/null; then
    echo "⚠️  WARNING: gem5 n'est pas trouvé"
    echo "   Assurez-vous que gem5 est installé avec support RISC-V"
    echo "   https://www.gem5.org/getting_started/"
else
    echo "✓ gem5 trouvé: $(which gem5)"
fi

# Vérifier RISC-V compiler
if ! command -v riscv64-unknown-elf-gcc &> /dev/null; then
    echo "⚠️  WARNING: RISC-V compiler non trouvé"
    echo "   Installez avec: sudo apt-get install gcc-riscv64-unknown-elf"
else
    echo "✓ RISC-V compiler: $(which riscv64-unknown-elf-gcc)"
fi

# Vérifier Python
if ! command -v python3 &> /dev/null; then
    echo "✗ Python3 est requis"
    exit 1
else
    echo "✓ Python3: $(which python3)"
fi

# Vérifier CACTI
if ! command -v cacti &> /dev/null; then
    echo "⚠️  WARNING: CACTI non trouvé"
    echo "   Télécharger depuis: https://github.com/HewlettPackard/cacti"
else
    echo "✓ CACTI trouvé: $(which cacti)"
fi

echo ""
echo "=========================================="
echo "Étapes à suivre:"
echo "=========================================="
echo ""

echo "1. COMPILATION DES APPLICATIONS"
echo "   - Compile Dijkstra et BlowFish en RISC-V"
echo "   Commande:"
echo "     chmod +x 01_compile_riscv.sh"
echo "     ./01_compile_riscv.sh"
echo ""

echo "2. EXÉCUTION DES SIMULATIONS gem5"
echo "   - Lance des simulations pour différentes configurations"
echo "   - Cortex A7: L1 = 1KB à 16KB"
echo "   - Cortex A15: L1 = 2KB à 32KB"
echo "   Commande:"
echo "     chmod +x 02_run_simulations.sh"
echo "     ./02_run_simulations.sh"
echo ""

echo "3. ANALYSE DES RÉSULTATS"
echo "   - Parse les fichiers stats.txt"
echo "   - Génère tableaux et graphiques"
echo "   Commande:"
echo "     python3 03_analyze_results.py results/"
echo ""

echo "4. ANALYSE CACTI"
echo "   - Pour chaque configuration, créer un fichier .cfg"
echo "   - Exécuter: ./cacti -infile cache_Lx_Ay_ZKB.cfg"
echo "   - Extraire la surface estimée"
echo ""

echo "5. GÉNÉRATION DU RAPPORT"
echo "   - Compiler les résultats dans un tableau"
echo "   - Générer les figures de performance"
echo "   - Rédiger les conclusions"
echo ""

echo "=========================================="
echo "Fichiers disponibles dans ce répertoire:"
echo "=========================================="
echo ""

ls -lh "$SCRIPT_DIR" | grep -E "\.(sh|py|cfg|md)$" | awk '{print "  " $NF}'

echo ""
echo "=========================================="
echo "Documentation complète:"
echo "=========================================="
echo ""
echo "  Lire INSTRUCTIONS.md pour plus de détails"
echo ""

# Créer un fichier de configuration exemple pour gem5
cat > "${SCRIPT_DIR}/gem5_simple_config.py" << 'PYTHONEOF'
#!/usr/bin/env python3

"""
Configuration simple pour gem5 avec RISC-V
À adapter selon votre installation de gem5
"""

import sys
import os

# Configuration processeur A7 simplifiée
class ProcessorConfigA7:
    fetch_width = 4
    decode_width = 4
    issue_width = 4
    commit_width = 2
    ruu_size = 8
    l1i_size = "4KB"
    l1d_size = "4KB"
    l2_size = "512KB"
    clock_freq = "1GHz"

# Configuration processeur A15 simplifiée
class ProcessorConfigA15:
    fetch_width = 8
    decode_width = 8
    issue_width = 8
    commit_width = 4
    ruu_size = 16
    l1i_size = "32KB"
    l1d_size = "32KB"
    l2_size = "512KB"
    clock_freq = "2.5GHz"

def get_processor_config(processor_type, l1_size=None):
    """Obtenir la configuration du processeur"""
    if processor_type == "a7":
        config = ProcessorConfigA7()
        if l1_size:
            config.l1i_size = l1_size
            config.l1d_size = l1_size
        return config
    elif processor_type == "a15":
        config = ProcessorConfigA15()
        if l1_size:
            config.l1i_size = l1_size
            config.l1d_size = l1_size
        return config
    else:
        raise ValueError(f"Processeur inconnu: {processor_type}")

# Exemple d'utilisation avec gem5
"""
from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.processors.simple_core import SimpleCore
from gem5.components.processors.cpu_types import CPUTypes
from gem5.isas import ISA

config = get_processor_config("a7", "4KB")

core = SimpleCore(
    cpu_type=CPUTypes.O3,
    isa=ISA.RISCV,
    clock_freq=config.clock_freq
)

# Configuration additionnelle du core
core.l1i_size = config.l1i_size
core.l1d_size = config.l1d_size

board = SimpleBoard(
    clk_freq=config.clock_freq,
    processor=core,
    memory=... # Configurer la mémoire
)
"""

if __name__ == "__main__":
    # Test simple
    for proc in ["a7", "a15"]:
        config = get_processor_config(proc)
        print(f"{proc.upper()}:")
        print(f"  Fetch Width: {config.fetch_width}")
        print(f"  Decode Width: {config.decode_width}")
        print(f"  Commit Width: {config.commit_width}")
        print(f"  RUU Size: {config.ruu_size}")
        print(f"  L1I/L1D: {config.l1i_size}/{config.l1d_size}")
        print(f"  L2: {config.l2_size}")
        print()

PYTHONEOF

chmod +x "${SCRIPT_DIR}/gem5_simple_config.py"

echo "Script de configuration simple créé: gem5_simple_config.py"
echo ""

echo "=========================================="
echo "Pour commencer:"
echo "=========================================="
echo ""
echo "  cd ${SCRIPT_DIR}"
echo "  ./01_compile_riscv.sh"
echo ""
