#!/usr/bin/env python3

"""
Exemple de résultats attendus pour TP4 Exercice 4
À titre de référence - les résultats réels dépendront de votre simulation gem5
"""

import csv
from pathlib import Path

# Données d'exemple - À REMPLACER PAR VOS RÉSULTATS RÉELS
EXAMPLE_DATA = {
    'A7': {
        '1KB': {
            'dijkstra': {
                'IPC': 1.12,
                'CPI': 0.893,
                'L1I_miss_rate': 0.00008,
                'L1D_miss_rate': 0.45,
                'L2_miss_rate': 0.68,
                'cycles': 8900000,
            },
            'blowfish': {
                'IPC': 1.05,
                'CPI': 0.952,
                'L1I_miss_rate': 0.00005,
                'L1D_miss_rate': 0.38,
                'L2_miss_rate': 0.65,
                'cycles': 9500000,
            }
        },
        '2KB': {
            'dijkstra': {
                'IPC': 1.18,
                'CPI': 0.847,
                'L1I_miss_rate': 0.00007,
                'L1D_miss_rate': 0.42,
                'L2_miss_rate': 0.65,
                'cycles': 8470000,
            },
            'blowfish': {
                'IPC': 1.10,
                'CPI': 0.909,
                'L1I_miss_rate': 0.00004,
                'L1D_miss_rate': 0.35,
                'L2_miss_rate': 0.62,
                'cycles': 9090000,
            }
        },
        '4KB': {
            'dijkstra': {
                'IPC': 1.25,
                'CPI': 0.800,
                'L1I_miss_rate': 0.00006,
                'L1D_miss_rate': 0.38,
                'L2_miss_rate': 0.62,
                'cycles': 8000000,
            },
            'blowfish': {
                'IPC': 1.15,
                'CPI': 0.870,
                'L1I_miss_rate': 0.00003,
                'L1D_miss_rate': 0.31,
                'L2_miss_rate': 0.59,
                'cycles': 8700000,
            }
        },
        '8KB': {
            'dijkstra': {
                'IPC': 1.30,
                'CPI': 0.769,
                'L1I_miss_rate': 0.00005,
                'L1D_miss_rate': 0.35,
                'L2_miss_rate': 0.60,
                'cycles': 7690000,
            },
            'blowfish': {
                'IPC': 1.18,
                'CPI': 0.847,
                'L1I_miss_rate': 0.00002,
                'L1D_miss_rate': 0.28,
                'L2_miss_rate': 0.57,
                'cycles': 8470000,
            }
        },
        '16KB': {
            'dijkstra': {
                'IPC': 1.32,
                'CPI': 0.758,
                'L1I_miss_rate': 0.00005,
                'L1D_miss_rate': 0.33,
                'L2_miss_rate': 0.58,
                'cycles': 7580000,
            },
            'blowfish': {
                'IPC': 1.20,
                'CPI': 0.833,
                'L1I_miss_rate': 0.00002,
                'L1D_miss_rate': 0.26,
                'L2_miss_rate': 0.55,
                'cycles': 8330000,
            }
        }
    },
    'A15': {
        '2KB': {
            'dijkstra': {
                'IPC': 1.85,
                'CPI': 0.541,
                'L1I_miss_rate': 0.00010,
                'L1D_miss_rate': 0.52,
                'L2_miss_rate': 0.70,
                'cycles': 5410000,
            },
            'blowfish': {
                'IPC': 1.72,
                'CPI': 0.581,
                'L1I_miss_rate': 0.00007,
                'L1D_miss_rate': 0.45,
                'L2_miss_rate': 0.67,
                'cycles': 5810000,
            }
        },
        '4KB': {
            'dijkstra': {
                'IPC': 1.95,
                'CPI': 0.513,
                'L1I_miss_rate': 0.00008,
                'L1D_miss_rate': 0.48,
                'L2_miss_rate': 0.67,
                'cycles': 5130000,
            },
            'blowfish': {
                'IPC': 1.82,
                'CPI': 0.549,
                'L1I_miss_rate': 0.00005,
                'L1D_miss_rate': 0.40,
                'L2_miss_rate': 0.63,
                'cycles': 5490000,
            }
        },
        '8KB': {
            'dijkstra': {
                'IPC': 2.08,
                'CPI': 0.481,
                'L1I_miss_rate': 0.00006,
                'L1D_miss_rate': 0.44,
                'L2_miss_rate': 0.64,
                'cycles': 4810000,
            },
            'blowfish': {
                'IPC': 1.92,
                'CPI': 0.521,
                'L1I_miss_rate': 0.00004,
                'L1D_miss_rate': 0.35,
                'L2_miss_rate': 0.60,
                'cycles': 5210000,
            }
        },
        '16KB': {
            'dijkstra': {
                'IPC': 2.18,
                'CPI': 0.459,
                'L1I_miss_rate': 0.00005,
                'L1D_miss_rate': 0.40,
                'L2_miss_rate': 0.61,
                'cycles': 4590000,
            },
            'blowfish': {
                'IPC': 2.00,
                'CPI': 0.500,
                'L1I_miss_rate': 0.00003,
                'L1D_miss_rate': 0.31,
                'L2_miss_rate': 0.57,
                'cycles': 5000000,
            }
        },
        '32KB': {
            'dijkstra': {
                'IPC': 2.22,
                'CPI': 0.451,
                'L1I_miss_rate': 0.00004,
                'L1D_miss_rate': 0.38,
                'L2_miss_rate': 0.59,
                'cycles': 4510000,
            },
            'blowfish': {
                'IPC': 2.05,
                'CPI': 0.488,
                'L1I_miss_rate': 0.00002,
                'L1D_miss_rate': 0.29,
                'L2_miss_rate': 0.55,
                'cycles': 4880000,
            }
        }
    }
}

# Données de surface CACTI en mm²
CACTI_AREAS = {
    'A7': {
        '1KB': 0.048,
        '2KB': 0.068,
        '4KB': 0.125,
        '8KB': 0.238,
        '16KB': 0.456,
    },
    'A15': {
        '2KB': 0.092,
        '4KB': 0.185,
        '8KB': 0.356,
        '16KB': 0.698,
        '32KB': 1.385,
    }
}

# Surface L2 (512KB)
L2_AREA = 0.850  # mm² (estimé pour 512KB)

# Surface des cores sans L1/L2
A7_CORE_AREA = 2.0 - 0.315  # 2.0mm² total - default L1 area
A15_CORE_AREA = 2.0 - 0.420  # 2.0mm² total - default L1 area

# Données de consommation énergétique
POWER_DATA = {
    'A7': 100,  # mW à 1.0 GHz
    'A15': 500  # mW à 2.5 GHz
}

def generate_csv_example():
    """Générer un fichier CSV d'exemple"""
    csv_file = Path('example_results.csv')
    
    with open(csv_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=[
            'Processor', 'L1_Size', 'Application', 'IPC', 'CPI',
            'L1I_Miss_Rate', 'L1D_Miss_Rate', 'L2_Miss_Rate',
            'Cycles', 'Total_Area_mm2'
        ])
        writer.writeheader()
        
        for proc in ['A7', 'A15']:
            for l1_size in sorted(EXAMPLE_DATA[proc].keys()):
                total_area = CACTI_AREAS[proc][l1_size] * 2 + L2_AREA  # *2 for I+D
                
                for app in ['dijkstra', 'blowfish']:
                    data = EXAMPLE_DATA[proc][l1_size][app]
                    writer.writerow({
                        'Processor': proc,
                        'L1_Size': l1_size,
                        'Application': app,
                        'IPC': f"{data['IPC']:.2f}",
                        'CPI': f"{data['CPI']:.3f}",
                        'L1I_Miss_Rate': f"{data['L1I_miss_rate']:.6f}",
                        'L1D_Miss_Rate': f"{data['L1D_miss_rate']:.2f}",
                        'L2_Miss_Rate': f"{data['L2_miss_rate']:.2f}",
                        'Cycles': data['cycles'],
                        'Total_Area_mm2': f"{total_area:.3f}"
                    })
    
    print(f"[v0] CSV example generated: {csv_file}")

def generate_summary_text():
    """Générer un résumé texte d'exemple"""
    summary_file = Path('example_summary.txt')
    
    with open(summary_file, 'w') as f:
        f.write("RÉSUMÉ DES PERFORMANCES - TP4 Exercice 4 (EXEMPLE)\n")
        f.write("=" * 90 + "\n\n")
        
        for proc in ['A7', 'A15']:
            f.write(f"\n{proc} - Cortex Performance Analysis\n")
            f.write("-" * 90 + "\n")
            f.write(f"{'L1 Size':<12} {'App':<12} {'IPC':<10} {'CPI':<10} {'L1I Miss':<12} {'L1D Miss':<12} {'L2 Miss':<12}\n")
            f.write("-" * 90 + "\n")
            
            for l1_size in sorted(EXAMPLE_DATA[proc].keys()):
                for app in ['dijkstra', 'blowfish']:
                    data = EXAMPLE_DATA[proc][l1_size][app]
                    f.write(
                        f"{l1_size:<12} {app:<12} "
                        f"{data['IPC']:<10.2f} "
                        f"{data['CPI']:<10.3f} "
                        f"{data['L1I_miss_rate']:<12.6f} "
                        f"{data['L1D_miss_rate']:<12.2f} "
                        f"{data['L2_miss_rate']:<12.2f}\n"
                    )
    
    print(f"[v0] Summary text generated: {summary_file}")

def generate_efficiency_tables():
    """Générer les tableaux d'efficacité surfacique et énergétique"""
    eff_file = Path('example_efficiency.csv')
    
    with open(eff_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=[
            'Processor', 'L1_Size', 'Application', 'IPC',
            'Area_mm2', 'Surf_Efficiency', 'Power_mW', 'Energy_Efficiency'
        ])
        writer.writeheader()
        
        for proc in ['A7', 'A15']:
            total_area_l1 = {l: CACTI_AREAS[proc][l] * 2 for l in CACTI_AREAS[proc]}
            power = POWER_DATA[proc]
            
            for l1_size in sorted(EXAMPLE_DATA[proc].keys()):
                area = total_area_l1[l1_size] + L2_AREA
                
                for app in ['dijkstra', 'blowfish']:
                    data = EXAMPLE_DATA[proc][l1_size][app]
                    ipc = data['IPC']
                    
                    surf_eff = ipc / area
                    energy_eff = ipc / power
                    
                    writer.writerow({
                        'Processor': proc,
                        'L1_Size': l1_size,
                        'Application': app,
                        'IPC': f"{ipc:.2f}",
                        'Area_mm2': f"{area:.3f}",
                        'Surf_Efficiency': f"{surf_eff:.4f}",
                        'Power_mW': power,
                        'Energy_Efficiency': f"{energy_eff:.4f}"
                    })
    
    print(f"[v0] Efficiency tables generated: {eff_file}")

def print_analysis():
    """Imprimer une analyse d'exemple"""
    print("\n" + "="*80)
    print("ANALYSE D'EXEMPLE - TP4 Exercice 4")
    print("="*80 + "\n")
    
    print("[v0] Résultats Cortex A7:")
    print("-" * 40)
    print("  Meilleure configuration: 16KB L1")
    print("  IPC Dijkstra: 1.32")
    print("  Raison: Point de saturation - augmenter au-delà n'améliore plus")
    print()
    
    print("[v0] Résultats Cortex A15:")
    print("-" * 40)
    print("  Meilleure configuration: 32KB L1")
    print("  IPC Dijkstra: 2.22")
    print("  Raison: A15 plus large peut bénéficier de plus de cache")
    print()
    
    print("[v0] Efficacité Surfacique:")
    print("-" * 40)
    a7_eff = 1.32 / (0.456*2 + 0.850)  # A7 16KB
    a15_eff = 2.22 / (1.385*2 + 0.850)  # A15 32KB
    print(f"  A7 (16KB): {a7_eff:.4f} IPC/mm²")
    print(f"  A15 (32KB): {a15_eff:.4f} IPC/mm²")
    print(f"  Avantage: A15 malgré plus de surface")
    print()
    
    print("[v0] Efficacité Énergétique:")
    print("-" * 40)
    a7_energy = 1.32 / 100
    a15_energy = 2.22 / 500
    print(f"  A7 (16KB): {a7_energy:.4f} IPC/mW")
    print(f"  A15 (32KB): {a15_energy:.4f} IPC/mW")
    print(f"  Avantage: A7 plus efficace énergétiquement")
    print()
    
    print("[v0] Recommandations big.LITTLE:")
    print("-" * 40)
    print("  Dijkstra: A15 32KB pour perfs, A7 16KB pour effi énergétique")
    print("  BlowFish: Similaire, légère préférence pour A15 si perf prioritaire")
    print()

def main():
    """Fonction principale"""
    print("[v0] Génération de fichiers d'exemple...\n")
    
    generate_csv_example()
    generate_summary_text()
    generate_efficiency_tables()
    print_analysis()
    
    print("="*80)
    print("[v0] Fichiers d'exemple générés:")
    print("  - example_results.csv")
    print("  - example_summary.txt")
    print("  - example_efficiency.csv")
    print("="*80)

if __name__ == "__main__":
    main()
