#!/usr/bin/env python3

"""
Script d'analyse des résultats gem5 pour TP4 Exercice 4
Extrait les statistiques de performance et génère des tableaux/graphiques
"""

import os
import re
import json
from pathlib import Path
from collections import defaultdict
import csv

class Gem5Results:
    """Parser et analyseur de résultats gem5"""
    
    def __init__(self, results_dir):
        self.results_dir = Path(results_dir)
        self.data = defaultdict(lambda: defaultdict(dict))
        self.stats_names = [
            'system.cpu.cpi',
            'system.cpu.ipc',
            'system.cpu.overall_cpi',
            'system.cpu.stat.num_insts',
            'system.cpu.stat.num_cycles',
            'system.l1_dcache.overall_miss_rate::total',
            'system.l1_icache.overall_miss_rate::total',
            'system.l2.overall_miss_rate::total',
            'system.cpu.branchPrediction.condPredicted',
            'system.cpu.branchPrediction.condIncorrect',
        ]
    
    def parse_stats_file(self, filepath):
        """Parse un fichier stats.txt de gem5"""
        stats = {}
        try:
            with open(filepath, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#'):
                        # Format: name value unit
                        parts = line.split()
                        if len(parts) >= 2:
                            name = parts[0]
                            try:
                                value = float(parts[1])
                                stats[name] = value
                            except (ValueError, IndexError):
                                pass
        except FileNotFoundError:
            print(f"[v0] Fichier non trouvé: {filepath}")
        
        return stats
    
    def extract_metrics(self, stats):
        """Extraire les métriques importantes"""
        metrics = {}
        
        # IPC et CPI
        metrics['IPC'] = stats.get('system.cpu.ipc', 0)
        metrics['CPI'] = stats.get('system.cpu.cpi', 0)
        
        # Miss rates
        metrics['L1I_miss_rate'] = stats.get('system.l1_icache.overall_miss_rate::total', 0)
        metrics['L1D_miss_rate'] = stats.get('system.l1_dcache.overall_miss_rate::total', 0)
        metrics['L2_miss_rate'] = stats.get('system.l2.overall_miss_rate::total', 0)
        
        # Nombre d'instructions et cycles
        metrics['num_insts'] = stats.get('system.cpu.stat.num_insts', 0)
        metrics['num_cycles'] = stats.get('system.cpu.stat.num_cycles', 0)
        
        # Branch prediction
        metrics['branch_pred'] = stats.get('system.cpu.branchPrediction.condPredicted', 0)
        metrics['branch_mispredict'] = stats.get('system.cpu.branchPrediction.condIncorrect', 0)
        
        return metrics
    
    def load_results(self):
        """Charger tous les résultats disponibles"""
        print("[v0] Chargement des résultats gem5...")
        
        for config_dir in self.results_dir.iterdir():
            if config_dir.is_dir():
                config_name = config_dir.name
                
                # Parse A7/A15 et taille L1
                if 'A7_L1' in config_name:
                    processor = 'A7'
                    l1_size = config_name.split('_')[-1]
                elif 'A15_L1' in config_name:
                    processor = 'A15'
                    l1_size = config_name.split('_')[-1]
                else:
                    continue
                
                # Charger les résultats pour Dijkstra et BlowFish
                for app in ['dijkstra', 'blowfish']:
                    stats_path = config_dir / app / 'stats.txt'
                    
                    if stats_path.exists():
                        stats = self.parse_stats_file(stats_path)
                        metrics = self.extract_metrics(stats)
                        
                        self.data[processor][l1_size][app] = metrics
                        print(f"[v0] Chargé: {processor} L1={l1_size} {app}")
    
    def generate_csv_report(self, output_file):
        """Générer un rapport CSV des résultats"""
        print(f"[v0] Génération du rapport CSV: {output_file}")
        
        with open(output_file, 'w', newline='') as csvfile:
            fieldnames = [
                'Processor', 'L1_Size', 'Application', 'IPC', 'CPI',
                'L1I_Miss_Rate', 'L1D_Miss_Rate', 'L2_Miss_Rate',
                'Num_Instructions', 'Num_Cycles'
            ]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            
            for processor in ['A7', 'A15']:
                for l1_size in sorted(self.data[processor].keys()):
                    for app in ['dijkstra', 'blowfish']:
                        metrics = self.data[processor][l1_size].get(app, {})
                        if metrics:
                            writer.writerow({
                                'Processor': processor,
                                'L1_Size': l1_size,
                                'Application': app,
                                'IPC': metrics.get('IPC', ''),
                                'CPI': metrics.get('CPI', ''),
                                'L1I_Miss_Rate': metrics.get('L1I_miss_rate', ''),
                                'L1D_Miss_Rate': metrics.get('L1D_miss_rate', ''),
                                'L2_Miss_Rate': metrics.get('L2_miss_rate', ''),
                                'Num_Instructions': metrics.get('num_insts', ''),
                                'Num_Cycles': metrics.get('num_cycles', ''),
                            })
    
    def generate_summary_table(self, output_file):
        """Générer un tableau récapitulatif"""
        print(f"[v0] Génération du tableau récapitulatif: {output_file}")
        
        with open(output_file, 'w') as f:
            f.write("RÉSUMÉ DES PERFORMANCES - TP4 Exercice 4\n")
            f.write("=" * 80 + "\n\n")
            
            for processor in ['A7', 'A15']:
                f.write(f"\n{processor} - Cortex Performance Analysis\n")
                f.write("-" * 80 + "\n")
                
                f.write(f"{'L1 Size':<12} {'App':<12} {'IPC':<10} {'CPI':<10} {'L1I Miss':<12} {'L1D Miss':<12} {'L2 Miss':<12}\n")
                f.write("-" * 80 + "\n")
                
                for l1_size in sorted(self.data[processor].keys()):
                    for app in ['dijkstra', 'blowfish']:
                        metrics = self.data[processor][l1_size].get(app, {})
                        if metrics:
                            f.write(
                                f"{l1_size:<12} {app:<12} "
                                f"{metrics.get('IPC', 0):<10.4f} "
                                f"{metrics.get('CPI', 0):<10.4f} "
                                f"{metrics.get('L1I_miss_rate', 0):<12.6f} "
                                f"{metrics.get('L1D_miss_rate', 0):<12.6f} "
                                f"{metrics.get('L2_miss_rate', 0):<12.6f}\n"
                            )

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Analyse des résultats gem5")
    parser.add_argument('results_dir', help='Répertoire contenant les résultats')
    parser.add_argument('--output_dir', default='analysis',
                        help='Répertoire de sortie pour les rapports')
    
    args = parser.parse_args()
    
    # Créer le répertoire de sortie
    output_dir = Path(args.output_dir)
    output_dir.mkdir(exist_ok=True)
    
    # Charger et analyser les résultats
    analyzer = Gem5Results(args.results_dir)
    analyzer.load_results()
    
    # Générer les rapports
    analyzer.generate_csv_report(output_dir / 'results.csv')
    analyzer.generate_summary_table(output_dir / 'summary.txt')
    
    print(f"[v0] Rapports générés dans: {output_dir}")

if __name__ == "__main__":
    main()
