# TP4 Exercice 4 - Simulation et Analyse de Performances des Caches

Analyse des performances de processeurs Cortex A7 et A15 simulés en RISC-V avec différentes configurations de cache L1 et L2 pour les applications Dijkstra et BlowFish.

## 📋 Vue d'ensemble

Ce projet permet de:
1. **Compiler** les applications Dijkstra et BlowFish pour RISC-V
2. **Simuler** l'exécution avec gem5 pour différentes configurations de cache
3. **Analyser** les performances (IPC, CPI, miss rates)
4. **Estimer** la surface des caches avec CACTI
5. **Calculer** l'efficacité surfacique et énergétique

## 🚀 Démarrage Rapide

### Prérequis

```bash
# RISC-V Compiler
sudo apt-get install gcc-riscv64-unknown-elf

# gem5 (avec support RISC-V)
# https://www.gem5.org/getting_started/

# CACTI 7.0
git clone https://github.com/HewlettPackard/cacti
cd cacti && make

# Python 3.6+
sudo apt-get install python3
```

### Exécution Complète

```bash
cd TP4_EXO4

# 1. Vérifier la configuration
./04_quick_start.sh

# 2. Compiler les applications
./01_compile_riscv.sh

# 3. Exécuter les simulations gem5
./02_run_simulations.sh

# 4. Analyser les résultats
python3 03_analyze_results.py results/ --output_dir analysis
```

## 📁 Structure du Projet

```
TP4_EXO4/
├── README.md                          # Ce fichier
├── INSTRUCTIONS.md                    # Documentation détaillée
├── RAPPORT_TEMPLATE.md                # Template pour le rapport
│
├── Scripts d'exécution:
├── 01_compile_riscv.sh               # Compilation des apps
├── 02_run_simulations.sh             # Exécution des simulations
├── 03_analyze_results.py             # Analyse des résultats
├── 04_quick_start.sh                 # Guide de démarrage
│
├── Configuration gem5:
├── gem5_config.py                    # Config gem5 principale
├── gem5_simple_config.py             # Config simplifiée
│
├── Configuration CACTI:
├── cache_L1_A7.cfg                   # Config cache A7
├── cache_L1_A15.cfg                  # Config cache A15
│
├── Dossiers générés:
├── sources/                          # Code source des apps
├── build/                            # Fichiers compilés temp
├── binaries/                         # Binaires RISC-V compilés
├── results/                          # Résultats des simulations
└── analysis/                         # Rapports et analyses
```

## 🔄 Workflow

### 1. Compilation

```bash
./01_compile_riscv.sh
```

Compile:
- **Dijkstra** (100 nœuds, algo SSSP)
- **BlowFish** (chiffrement ECB, CBC, CFB, OFB)

Paramètres:
- Architecture: RISC-V 64-bit
- Optimisation: -O2
- Flags: `-march=rv64i -mabi=lp64`

### 2. Simulations gem5

```bash
./02_run_simulations.sh
```

Teste:
- **Cortex A7**: L1 = 1KB, 2KB, 4KB, 8KB, 16KB
- **Cortex A15**: L1 = 2KB, 4KB, 8KB, 16KB, 32KB
- **L2 fixe**: 512KB
- **Applications**: Dijkstra, BlowFish

Génère:
- `results/A[7|15]_L1_[SIZE]KB/{dijkstra|blowfish}/stats.txt`

### 3. Analyse des Résultats

```bash
python3 03_analyze_results.py results/
```

Produit:
- `analysis/results.csv` - Tableau complet en CSV
- `analysis/summary.txt` - Résumé lisible

### 4. Analyse CACTI

```bash
# Pour chaque configuration, créer un .cfg et exécuter:
./cacti -infile cache_L1_A7_4KB.cfg > result_L1_A7_4KB.txt
./cacti -infile cache_L1_A15_8KB.cfg > result_L1_A15_8KB.txt
```

## 📊 Résultats Attendus

### Performance (IPC)
- A7 Dijkstra: ~1.2-1.8 IPC
- A15 Dijkstra: ~1.5-2.5 IPC
- BlowFish: Résultats similaires avec meilleure localité

### Miss Rates
- L1I: Très faible (< 0.1%)
- L1D: Modéré (15-25%)
- L2: Élevé (40-50%)

### Efficacité
- Augmenter L1 améliore les performances jusqu'à un point de saturation
- A15 plus performant mais plus gourmand en énergie
- Configuration optimale dépend de l'application

## 🔧 Configuration des Processeurs

### Cortex A7 (RISC-V)
```
Fetch Width:       4
Decode Width:      4
Issue Width:       4
Commit Width:      2
RUU Size:          8 (Register Update Unit)
LSQ Size:          8
L1I/L1D:           32KB / 32B blocks / 2-way
L2:                512KB / 32B blocks / 8-way
Branch Predictor:  Bimodal (BTB=256)
Clock Frequency:   1.0 GHz
Power:             0.10 mW/MHz → 100 mW
```

### Cortex A15 (RISC-V)
```
Fetch Width:       8
Decode Width:      8
Issue Width:       8
Commit Width:      4
RUU Size:          16
LSQ Size:          16
L1I/L1D:           32KB / 64B blocks / 2-way
L2:                512KB / 64B blocks / 16-way
Branch Predictor:  2-level (BTB=256)
Clock Frequency:   2.5 GHz
Power:             0.20 mW/MHz → 500 mW
```

## 📈 Métriques Calculées

### Performance
- **IPC**: Instructions Per Cycle
- **CPI**: Cycles Per Instruction
- **Number of Cycles**: Cycles totaux d'exécution

### Mémoire
- **L1I Miss Rate**: Défauts cache L1 instructions
- **L1D Miss Rate**: Défauts cache L1 données
- **L2 Miss Rate**: Défauts cache L2

### Efficacité
$$\text{Efficacité Surfacique} = \frac{\text{IPC}}{\text{Surface (mm}^2\text{)}}$$

$$\text{Efficacité Énergétique} = \frac{\text{IPC}}{\text{Consommation (mW)}}$$

## 🐛 Troubleshooting

### gem5 n'est pas trouvé
```bash
# Vérifier l'installation
which gem5

# Ou utiliser le path complet
/path/to/gem5/build/RISCV/gem5.py

# Ajouter au PATH
export PATH=/path/to/gem5:$PATH
```

### Erreur de compilation RISC-V
```bash
# Vérifier le toolchain
riscv64-unknown-elf-gcc --version

# Installer si manquant
# Ubuntu/Debian
sudo apt-get install gcc-riscv64-unknown-elf

# Fedora
sudo dnf install riscv64-unknown-elf-gcc

# macOS
brew install riscv-gnu-toolchain
```

### Pas de fichier stats.txt
```bash
# Vérifier les logs d'erreur
cat results/A7_L1_4KB/dijkstra.log

# Vérifier que le binaire existe
file binaries/dijkstra

# Tester gem5 manuellement
gem5 --help
```

### CACTI ne compile pas
```bash
# Télécharger la version la plus récente
git clone https://github.com/HewlettPackard/cacti
cd cacti
make clean
make

# Ou télécharger depuis le site officiel
# https://github.com/HewlettPackard/cacti/releases
```

## 📚 Documentation

- **INSTRUCTIONS.md** - Guide détaillé avec réponses attendues
- **RAPPORT_TEMPLATE.md** - Template pour rédiger le rapport
- [gem5 Documentation](https://www.gem5.org/)
- [CACTI GitHub](https://github.com/HewlettPackard/cacti)
- [RISC-V Spec](https://riscv.org/)

## 📝 Questions du TP

1. **Q1-Q3**: Profiling et analyse des instructions
2. **Q4-Q5**: Variation de L1 cache (Cortex A7 et A15)
3. **Q6-Q9**: Efficacité surfacique avec CACTI
4. **Q10-Q11**: Efficacité énergétique
5. **Q12-Q14**: Architecture big.LITTLE optimale

Voir **RAPPORT_TEMPLATE.md** pour le template complet.

## 📅 Calendrier

| Étape | Durée Estimée |
|-------|----------------|
| Compilation | 5-10 min |
| Simulations | 1-4 heures |
| Analyse | 15-30 min |
| CACTI | 30-60 min |
| Rapport | 2-3 heures |

**Total: 4-8 heures** (selon la puissance de calcul)

## ✅ Checklist de Remise

- [ ] Compilation sans erreur
- [ ] Simulations complètes (toutes les configurations)
- [ ] Fichiers stats.txt générés
- [ ] Analyse CSV et résumé générés
- [ ] Résultats CACTI collectés
- [ ] Tableau avec efficacités rempli
- [ ] Figures de performance générées
- [ ] Rapport PDF rédigé et complété
- [ ] Tous les fichiers sources inclus

## 👥 Contacts

- **Instructeur**: hammami@ensta.fr
- **Chargé de TD**: [À remplir]
- **Subject**: ECE_4ES01_TA/TP4
- **Deadline**: 23/02/2026

## 📄 Format de Remise

```
TP4-nom1-nom2-nom3-nom4.pdf
```

Inclure:
- Réponses à toutes les questions
- Tableaux et figures
- Explications et analyses
- Conclusion et recommandations

## 🎯 Objectifs Pédagogiques

À la fin de ce TP, vous comprendrez:

- Architecture des processeurs modernes (pipeline, out-of-order)
- Impact de la hiérarchie mémoire sur les performances
- Trade-offs entre performance, surface et consommation d'énergie
- Méthodologie de simulation et d'analyse d'architectures
- Conception de systèmes embarqués efficaces (big.LITTLE)

## 📌 Notes Importantes

1. **Déterminisme**: Les simulations gem5 sont déterministes
2. **Données d'entrée**: Utiliser les mêmes données pour toutes les configurations
3. **Architecture simulée**: RISC-V au lieu d'ARM pour compatibilité gem5
4. **Paramètres**: Inspirés de Cortex A7/A15 mais simplifiés pour RISC-V
5. **Résultats**: Les performances relatives restent valides

---

**Bon travail! 🚀**

Pour plus de détails, lire `INSTRUCTIONS.md`
