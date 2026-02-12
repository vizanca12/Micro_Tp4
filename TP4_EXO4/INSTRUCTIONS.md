# TP4 Exercice 4 - Analyse de Performances des Caches

## Objectif
Analyser les performances des processeurs Cortex A7 et A15 (simulés en RISC-V) avec différentes configurations de cache L1 et L2 pour les applications Dijkstra et BlowFish.

## Architectures Comparées

### Cortex A7 (RISC-V)
- Fetch Width: 4
- Decode Width: 4
- Commit Width: 2
- RUU Size: 8
- L1I/L1D: 32KB / 32 bytes block / 2-way
- L2: 512KB / 32 bytes block / 8-way
- Prédicteur de branchement: bimodal

### Cortex A15 (RISC-V)
- Fetch Width: 8
- Decode Width: 8
- Commit Width: 4
- RUU Size: 16
- L1I/L1D: 32KB / 64 bytes block / 2-way
- L2: 512KB / 64 bytes block / 16-way
- Prédicteur de branchement: 2-level

## Étapes d'Exécution

### 1. Compilation des Applications

```bash
cd TP4_EXO4
chmod +x 01_compile_riscv.sh
./01_compile_riscv.sh
```

Cela compilera:
- **Dijkstra**: Algorithme de recherche du plus court chemin
- **BlowFish**: Algorithme de chiffrement

Les binaires RISC-V seront créés dans `binaries/`.

### 2. Exécution des Simulations

```bash
chmod +x 02_run_simulations.sh
./02_run_simulations.sh
```

Cette étape exécutera gem5 avec:
- **Cortex A7**: L1 cache de 1KB à 16KB (1, 2, 4, 8, 16 KB)
- **Cortex A15**: L1 cache de 2KB à 32KB (2, 4, 8, 16, 32 KB)
- **Applications**: Dijkstra et BlowFish
- **L2 cache**: Fixé à 512KB

Les résultats seront dans `results/`.

### 3. Analyse des Résultats

```bash
python3 03_analyze_results.py results/ --output_dir analysis
```

Cela générera:
- `analysis/results.csv`: Tableau des résultats en format CSV
- `analysis/summary.txt`: Résumé lisible des performances

## Réponses aux Questions du TP

### Q1 - Profiling de l'application

```bash
# Utiliser gem5 pour générer le profil d'instructions
gem5 -c gem5_config.py --processor=a7 --binary=binaries/dijkstra
```

Analysez les fichiers de statistiques pour obtenir:
- Pourcentage de chaque classe d'instructions (ALU, Load/Store, FP, etc.)
- Taux de branchements
- Utilisation des unités fonctionnelles

### Q2 - Catégorie d'instructions

Basez votre analyse sur:
1. Le taux d'instructions de chaque classe
2. Le nombre d'unités fonctionnelles disponibles
3. L'impact sur le IPC global

### Q3 - Localité de références

Observez:
- Les taux de défauts L1D (données)
- Les taux de défauts L1I (instructions)
- Les patterns d'accès mémoire

### Q4 & Q5 - Variations de L1 Cache

Les résultats montreront:
- Évolution du IPC avec la taille de L1
- Évolution des miss rates
- Point de saturation (où augmenter L1 n'améliore plus)

### Q6 - Paramètres CACTI

Configuration par défaut dans `cache.cfg`:
```
-cache_type "cache"
-cache_size 32 (KB)
-block_size 64 (Bytes)
-associativity 2
-operating_point "default"
-technology_node 28 (nm)
-output_width 64 (bits)
```

### Q7 - Surface des Caches L1

Utilisez CACTI:
```bash
# Cortex A7 - L1I/L1D 32KB 2-way 32B blocks
./cacti -infile cache_L1_A7.cfg

# Cortex A15 - L1I/L1D 32KB 2-way 64B blocks
./cacti -infile cache_L1_A15.cfg
```

Calcul du pourcentage:
```
% surface L1 = (surface_L1 / surface_totale) * 100
surface core hors L1 = surface_totale - surface_L1
```

### Q8 - Variation de L1 avec CACTI

Pour chaque configuration testée:
1. Créer un fichier `.cfg` pour CACTI
2. Exécuter CACTI
3. Extraire la surface estimée
4. Calculer la surface totale (L1 + L2 + core)

### Q9 - Efficacité Surfacique

Formule:
$$\text{Efficacité surfacique} = \frac{\text{IPC}}{\text{surface (mm}^2\text{)}}$$

Comparer A7 et A15 pour chaque configuration.

### Q10 - Puissance Consommée

À fréquence maximale:
- **Cortex A7**: 0.10 mW/MHz × 1000 MHz = **100 mW**
- **Cortex A15**: 0.20 mW/MHz × 2500 MHz = **500 mW**

### Q11 - Efficacité Énergétique

Formule:
$$\text{Efficacité énergétique} = \frac{\text{IPC}}{\text{consommation (mW)}}$$

### Q12 - Configuration big.LITTLE Optimale

Pour chaque application:
1. Comparer les efficacités (surfacique et énergétique)
2. Proposer la meilleure configuration A7
3. Proposer la meilleure configuration A15
4. Justifier les choix

### Q13 & Q14 - Discussion

- Les configurations A7 et A15 optimales sont-elles les mêmes?
- Proposer un compromis pour un système multi-applications
- Méthodologie générale de spécification d'architecture

## Structure des Fichiers

```
TP4_EXO4/
├── 01_compile_riscv.sh       # Compilation RISC-V
├── 02_run_simulations.sh      # Exécution gem5
├── 03_analyze_results.py      # Analyse des résultats
├── gem5_config.py             # Configuration gem5
├── cache_L1_A7.cfg            # Config CACTI A7
├── cache_L1_A15.cfg           # Config CACTI A15
├── sources/                   # Code source des apps
├── build/                     # Fichiers compilés temporaires
├── binaries/                  # Binaires RISC-V
├── results/                   # Résultats gem5
└── analysis/                  # Rapports et analyses
```

## Troubleshooting

### gem5 pas trouvé
```bash
# Vérifier l'installation
which gem5

# Ou utiliser le chemin complet
/path/to/gem5/build/RISCV/gem5.py
```

### Compilation RISC-V échouée
```bash
# Vérifier le toolchain
riscv64-unknown-elf-gcc --version

# Installer si nécessaire
# Ubuntu/Debian
sudo apt-get install gcc-riscv64-unknown-elf

# macOS
brew install riscv-gnu-toolchain
```

### Pas de fichier stats.txt
- Vérifier que gem5 s'est exécuté correctement
- Vérifier les fichiers `.log` dans les répertoires de résultats
- S'assurer que les binaires sont valides pour RISC-V

## Références

- gem5 Documentation: https://www.gem5.org/
- CACTI 7.0: https://github.com/HewlettPackard/cacti
- ARM Cortex-A7: ARMv7 Architecture
- ARM Cortex-A15: ARMv7 Architecture
- RISC-V Specification: https://riscv.org/

## Notes

1. **Architecture simulée**: RISC-V au lieu d'ARM pour compatibilité gem5
2. **Paramètres adaptés**: Les paramètres A7/A15 sont simplifiés pour RISC-V
3. **Données déterministes**: Utiliser les mêmes données d'entrée pour comparaison
4. **Répétabilité**: Les simulations gem5 sont déterministes

## Contacts

- Instructeur: hammami@ensta.fr
- Chargé de TD: [email de votre chargé de TD]
