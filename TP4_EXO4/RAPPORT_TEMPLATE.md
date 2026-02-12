# Rapport TP4 - Exercice 4
## Analyse des Performances des Caches pour Cortex A7 et A15

**Groupe:** [Noms des 4 membres]  
**Date:** [Date]  
**Cours:** ECE_4ES01_TA - Architecture des Microprocesseurs

---

## 1. Profiling de l'Application

### Q1: Classes d'Instructions

Analysez le pourcentage de chaque classe d'instructions pour Dijkstra et BlowFish:

| Classe d'Instructions | Dijkstra (%) | BlowFish (%) |
|---|---|---|
| ALU (Integer) | | |
| Load/Store | | |
| Floating Point | | |
| Branchements | | |
| Autres | | |

**Procédure:**
```bash
gem5 --outdir=results/ -c gem5_config.py --binary=binaries/dijkstra
gem5 --outdir=results/ -c gem5_config.py --binary=binaries/blowfish
```

Extraire les statistiques de `stats.txt`:
- `system.cpu.op_class::*`
- `system.cpu.branchPrediction::*`

### Q2: Catégories d'Instructions à Améliorer

**Analyse (max 5 lignes):**

Basé sur les résultats du profiling:
- [À compléter]

### Q3: Similitudes avec TP2

Comparez les résultats avec dijkstra, BlowFish, SSCA2-BCS, SHA-1 et produit de polynômes:

**Observations:**
- [À compléter]

---

## 2. Évaluation des Performances

### Q4: Cortex A7 - Variation de L1 Cache

**Configurations testées:** L1 cache de 1KB à 16KB (L2 fixe à 512KB)

#### Table Q4.1: Performance Générale (A7)

| L1 Size | Dijkstra IPC | Dijkstra CPI | BlowFish IPC | BlowFish CPI |
|---|---|---|---|---|
| 1KB | | | | |
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |

#### Table Q4.2: Miss Rates (A7 - Dijkstra)

| L1 Size | L1I Miss | L1D Miss | L2 Miss |
|---|---|---|---|
| 1KB | | | |
| 2KB | | | |
| 4KB | | | |
| 8KB | | | |
| 16KB | | | |

#### Table Q4.3: Miss Rates (A7 - BlowFish)

| L1 Size | L1I Miss | L1D Miss | L2 Miss |
|---|---|---|---|
| 1KB | | | |
| 2KB | | | |
| 4KB | | | |
| 8KB | | | |
| 16KB | | | |

#### Figure Q4.1: IPC vs L1 Size (A7)
```
[À générer avec matplotlib/gnuplot]
```

#### Figure Q4.2: Miss Rates vs L1 Size (A7)
```
[À générer avec matplotlib/gnuplot]
```

**Analyse Q4:**

Meilleure configuration A7: **[À compléter]**

Justification:
- [À compléter]

**Paramètres d'exécution gem5:**
```bash
gem5 -c gem5_config.py \
  --processor=a7 \
  --l1i_size=4KB \
  --l1d_size=4KB \
  --l2_size=512KB \
  --binary=binaries/dijkstra
```

---

### Q5: Cortex A15 - Variation de L1 Cache

**Configurations testées:** L1 cache de 2KB à 32KB (L2 fixe à 512KB)

#### Table Q5.1: Performance Générale (A15)

| L1 Size | Dijkstra IPC | Dijkstra CPI | BlowFish IPC | BlowFish CPI |
|---|---|---|---|---|
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |
| 32KB | | | | |

#### Table Q5.2: Miss Rates (A15 - Dijkstra)

| L1 Size | L1I Miss | L1D Miss | L2 Miss |
|---|---|---|---|
| 2KB | | | |
| 4KB | | | |
| 8KB | | | |
| 16KB | | | |
| 32KB | | | |

#### Figure Q5.1: IPC vs L1 Size (A15)
```
[À générer avec matplotlib/gnuplot]
```

**Analyse Q5:**

Meilleure configuration A15: **[À compléter]**

Justification:
- [À compléter]

---

## 3. Efficacité Surfacique

### Q6: Paramètres CACTI par Défaut

Fichier `cache.cfg`:
```
-cache_type "cache"
-cache_size 32 (KB)
-block_size 64 (Bytes)
-associativity 2
-technology_node 28 (nm)
```

### Q7: Surface des Caches L1 (Configuration par défaut)

#### Table Q7.1: Surface des Caches L1

| Cœur | L1I Size | L1D Size | Block | Assoc | Surface (mm²) |
|---|---|---|---|---|---|
| A7 | 32KB | 32KB | 32B | 2-way | |
| A15 | 32KB | 32KB | 64B | 2-way | |

**Calculs:**

Surface totale A7: 2.0 mm² (énoncé)
```
% surface L1 = (surface_L1 / 2.0) * 100 = [À compléter]%
Surface core hors L1 = 2.0 - surface_L1 = [À compléter] mm²
```

Surface totale A15: 2.0 mm² (énoncé)
```
% surface L1 = (surface_L1 / 2.0) * 100 = [À compléter]%
Surface core hors L1 = 2.0 - surface_L1 = [À compléter] mm²
```

**Analyse Q7:**
- [À compléter]

### Q8: Variation de L1 avec CACTI

#### Table Q8.1: Surface des Caches L1 (Cortex A7)

| L1 Size | Block Size | Assoc | Surface (mm²) |
|---|---|---|---|
| 1KB | 32B | 2 | |
| 2KB | 32B | 2 | |
| 4KB | 32B | 2 | |
| 8KB | 32B | 2 | |
| 16KB | 32B | 2 | |

#### Table Q8.2: Surface des Caches L1 (Cortex A15)

| L1 Size | Block Size | Assoc | Surface (mm²) |
|---|---|---|---|
| 2KB | 64B | 2 | |
| 4KB | 64B | 2 | |
| 8KB | 64B | 2 | |
| 16KB | 64B | 2 | |
| 32KB | 64B | 2 | |

#### Table Q8.3: Surface Totale (A7 + L2)

| L1 Size | L1 Surface | L2 Surface | Core Hors L1 | Total |
|---|---|---|---|---|
| 1KB | | | 1.685 | |
| 2KB | | | 1.685 | |
| 4KB | | | 1.685 | |
| 8KB | | | 1.685 | |
| 16KB | | | 1.685 | |

#### Figure Q8.1: Surface vs L1 Size (A7)
```
[Courbe de surface en fonction de la taille L1]
```

#### Figure Q8.2: Surface vs L1 Size (A15)
```
[Courbe de surface en fonction de la taille L1]
```

### Q9: Efficacité Surfacique

$$\text{Efficacité surfacique} = \frac{\text{IPC}}{\text{surface (mm}^2\text{)}}$$

#### Table Q9.1: Efficacité Surfacique (Cortex A7)

| L1 Size | Dijkstra IPC | Dijkstra Surf Eff | BlowFish IPC | BlowFish Surf Eff |
|---|---|---|---|---|
| 1KB | | | | |
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |

#### Table Q9.2: Efficacité Surfacique (Cortex A15)

| L1 Size | Dijkstra IPC | Dijkstra Surf Eff | BlowFish IPC | BlowFish Surf Eff |
|---|---|---|---|---|
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |
| 32KB | | | | |

#### Figure Q9.1: Efficacité Surfacique vs L1 Size
```
[Comparaison A7 vs A15]
```

---

## 4. Efficacité Énergétique

### Q10: Puissance Consommée à Fréquence Maximale

**Donnés énoncé:**
- A7: 0.10 mW/MHz @ 1.0 GHz → **100 mW**
- A15: 0.20 mW/MHz @ 2.5 GHz → **500 mW**

### Q11: Efficacité Énergétique

$$\text{Efficacité énergétique} = \frac{\text{IPC}}{\text{consommation (mW)}}$$

#### Table Q11.1: Efficacité Énergétique (Cortex A7)

| L1 Size | Dijkstra IPC | Dijkstra Energy Eff | BlowFish IPC | BlowFish Energy Eff |
|---|---|---|---|---|
| 1KB | | | | |
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |

#### Table Q11.2: Efficacité Énergétique (Cortex A15)

| L1 Size | Dijkstra IPC | Dijkstra Energy Eff | BlowFish IPC | BlowFish Energy Eff |
|---|---|---|---|---|
| 2KB | | | | |
| 4KB | | | | |
| 8KB | | | | |
| 16KB | | | | |
| 32KB | | | | |

#### Figure Q11.1: Efficacité Énergétique vs L1 Size
```
[Comparaison A7 vs A15]
```

---

## 5. Architecture Système big.LITTLE

### Q12: Configuration Optimale

#### Pour Dijkstra:
**Configuration A7 optimale:** [À compléter]
- Raison: [À compléter]

**Configuration A15 optimale:** [À compléter]
- Raison: [À compléter]

#### Pour BlowFish:
**Configuration A7 optimale:** [À compléter]
- Raison: [À compléter]

**Configuration A15 optimale:** [À compléter]
- Raison: [À compléter]

### Q13: Équivalence des Configurations (Facultatif)

**Les configurations optimales A7 et A15 sont-elles équivalentes?**

Réponse: [À compléter]

**Compromis proposé:**

[À compléter]

**Conclusion:**

[À compléter]

### Q14: Approche Générale (Facultatif)

**Méthodologie pour spécifier une architecture multi-applications:**

1. [À compléter]
2. [À compléter]
3. [À compléter]

---

## Conclusion Générale

### Synthèse des Résultats
- [À compléter]

### Recommandations
- [À compléter]

### Observations Intéressantes
- [À compléter]

---

## Annexe: Paramètres de Simulation gem5

**Paramètres utilisés:**
```bash
gem5 [options] -c gem5_config.py \
  --processor=[a7|a15] \
  --l1i_size=[SIZE] \
  --l1d_size=[SIZE] \
  --l2_size=512KB \
  --binary=[app]
```

**Architectures simulées:**
- Cortex A7 en RISC-V (out-of-order)
- Cortex A15 en RISC-V (out-of-order)

**Applications:**
- Dijkstra: Algorithme de recherche du plus court chemin
- BlowFish: Algorithme de chiffrement

---

**Remis le:** [Date]  
**À:** hammami@ensta.fr  
**Sujet:** ECE_4ES01_TA/TP4
