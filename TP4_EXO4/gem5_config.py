#!/usr/bin/env python3

"""
Script de configuration gem5 pour TP4 Exercice 4
Simule Cortex A7 et A15 en RISC-V avec différentes configurations de cache
"""

import argparse
import sys

# Configuration gem5
from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.memory.memory import MemoryInfo, SingleChannelDDRMemory
from gem5.components.processors.cpu_types import CPUTypes
from gem5.isas import ISA
from gem5.resources.resource import obtain_resource
from gem5.simulate import Simulation

# Configurations des processeurs
PROCESSOR_CONFIGS = {
    'a7': {
        'fetchWidth': 4,
        'decodeWidth': 4,
        'executeWidth': 4,
        'memWidth': 2,
        'issueWidth': 4,
        'commitWidth': 2,
        'numIQEntries': 8,
        'numROBEntries': 8,
        'numPhysIntRegs': 64,
        'numPhysFloatRegs': 32,
        'numThreads': 1,
    },
    'a15': {
        'fetchWidth': 8,
        'decodeWidth': 8,
        'executeWidth': 8,
        'memWidth': 4,
        'issueWidth': 8,
        'commitWidth': 4,
        'numIQEntries': 16,
        'numROBEntries': 16,
        'numPhysIntRegs': 128,
        'numPhysFloatRegs': 64,
        'numThreads': 1,
    }
}

def create_processor(processor_type, clock_freq="1GHz"):
    """Créer un processeur avec les paramètres spécifiés"""
    from gem5.components.processors.simple_core import SimpleCore
    from gem5.components.processors.cpu_types import CPUTypes
    
    # Sélectionner le type de CPU (O3 pour out-of-order)
    cpu_type = CPUTypes.O3
    
    # Créer le core avec les paramètres du processeur
    core = SimpleCore(
        cpu_type=cpu_type,
        isa=ISA.RISCV,
        clock_freq=clock_freq
    )
    
    # Appliquer les configurations spécifiques
    config = PROCESSOR_CONFIGS.get(processor_type, PROCESSOR_CONFIGS['a7'])
    
    # Configurer les paramètres du core
    if hasattr(core, 'fetchWidth'):
        core.fetchWidth = config['fetchWidth']
    if hasattr(core, 'decodeWidth'):
        core.decodeWidth = config['decodeWidth']
    if hasattr(core, 'commitWidth'):
        core.commitWidth = config['commitWidth']
    
    return core

def create_board(l1i_size, l1d_size, l2_size, l1_assoc, l2_assoc, processor='a7'):
    """Créer un board avec la configuration de cache spécifiée"""
    
    # Créer le processeur
    processor_instance = create_processor(processor)
    
    # Configurer la mémoire
    memory = SingleChannelDDRMemory(
        "4GiB",
        MemoryInfo(
            frequency="800MHz",
            size="4GiB"
        )
    )
    
    # Créer le board
    board = SimpleBoard(
        clk_freq="1GHz",
        processor=processor_instance,
        memory=memory,
    )
    
    # Configurer les caches L1
    # Note: Les paramètres exacts dépendent de la version de gem5
    board.cache_hierarchy.l1d_size = l1d_size
    board.cache_hierarchy.l1i_size = l1i_size
    board.cache_hierarchy.l2_size = l2_size
    
    return board

def main():
    """Fonction principale"""
    parser = argparse.ArgumentParser(description="Configuration gem5 pour TP4")
    parser.add_argument('--processor', default='a7', choices=['a7', 'a15'],
                        help='Processeur à simuler (a7 ou a15)')
    parser.add_argument('--l1i_size', default='4KB',
                        help='Taille du cache L1 instructions')
    parser.add_argument('--l1d_size', default='4KB',
                        help='Taille du cache L1 données')
    parser.add_argument('--l2_size', default='512KB',
                        help='Taille du cache L2')
    parser.add_argument('--l1_assoc', type=int, default=2,
                        help='Associativité L1')
    parser.add_argument('--l2_assoc', type=int, default=8,
                        help='Associativité L2')
    parser.add_argument('--binary', required=True,
                        help='Chemin du binaire à simuler')
    
    args = parser.parse_args()
    
    # Créer le board avec la configuration
    board = create_board(
        l1i_size=args.l1i_size,
        l1d_size=args.l1d_size,
        l2_size=args.l2_size,
        l1_assoc=args.l1_assoc,
        l2_assoc=args.l2_assoc,
        processor=args.processor
    )
    
    # Créer la simulation
    simulation = Simulation(
        board=board,
        full_system=False,
        workload=args.binary
    )
    
    # Exécuter la simulation
    print(f"[v0] Starting simulation: {args.processor} with L1I={args.l1i_size} L1D={args.l1d_size} L2={args.l2_size}")
    simulation.run()
    
    print("[v0] Simulation completed")

if __name__ == "__main__":
    main()
