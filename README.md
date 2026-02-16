# TP4 : Évaluation des Performances Caches & Architecture big.LITTLE

Ce dépôt contient les scripts de simulation, les résultats bruts et le rapport d'analyse approfondie réalisés dans le cadre du module **Architecture des Microprocesseurs (CSC_4OS02_TA)** à l'**ENSTA Paris**.

L'objectif de ce projet est d'explorer l'impact du dimensionnement des mémoires caches (L1) sur les performances brutes, l'empreinte physique (silicium) et la consommation énergétique de deux microarchitectures ARM fondamentalement différentes : le **Cortex A7** (In-Order, basse consommation) et le **Cortex A15** (Out-of-Order superscalaire, haute performance).

---

## Outils et Technologies
* **Gem5** : Simulateur microarchitectural cycle-précis utilisé pour évaluer l'IPC (Instructions Per Cycle) et les taux de défauts de cache (Miss Rates).
* **CACTI** : Outil d'estimation analytique utilisé pour modéliser la surface physique (mm²) des caches L1 et L2 en technologie 32nm et 28nm.
* **Python** : Scripts de configuration matérielle pour Gem5 (se_A7.py, se_A15.py).
* **LaTeX** : Rédaction du rapport d'analyse scientifique.

---

## Benchmarks Étudiés
Afin de mettre en évidence les goulots d'étranglement matériels, deux algorithmes aux comportements antagonistes ont été profilés et simulés :
1. **Dijkstra** : Algorithme de parcours de graphe. Comportement typique **Memory-Bound** (fort taux de pointer chasing et dépendance de données).
2. **Blowfish** : Algorithme de chiffrement cryptographique. Comportement typique **Compute-Bound** (fort potentiel de parallélisme d'instructions - ILP).

---

## Résultats Principaux (Key Findings)

L'étude croisée des métriques de performance, de surface (SWaP-C) et d'énergie a permis de démontrer empiriquement les concepts avancés d'architecture des ordinateurs :

* **La Loi des Rendements Décroissants (Cortex A7) :** Bridé par une fenêtre d'exécution minuscule (RUU=2), le Cortex A7 sature rapidement. Augmenter son cache L1 au-delà de 8 KB gaspille de la surface silicium sans gain de performance notable. Il reste cependant le champion absolu de l'efficacité énergétique pour les tâches limitées par la mémoire.
* **Le Paradoxe de l'Efficacité Surfacique (Cortex A15) :** Bien que physiquement massif, le Cortex A15 et son exécution Out-of-Order agressive (RUU=16) maintiennent ses unités de calcul constamment nourries en données. Sur des calculs lourds, il offre paradoxalement une meilleure rentabilité par mm² que le petit processeur A7.
* **Le Concept de Race-to-Sleep :** Sur l'algorithme Blowfish, le puissant Cortex A15 consomme 5 fois plus de puissance en crête (500 mW), mais termine les calculs si rapidement qu'il consomme finalement moins d'énergie totale que l'A7.
* **Validation du paradigme big.LITTLE :** La conclusion du projet justifie la conception de SoCs hétérogènes asymétriques, où le système d'exploitation route les tâches de fond vers le cluster A7 (LITTLE) et les tâches critiques vers le cluster A15 (big).

---

## Structure du Dépôt

Micro_Tp4/
* **archive/** : Dossier d'archives et ressources complémentaires.
* **TP4/** : Dossier principal du TP.
  * **ex4/** : Scripts, statistiques Gem5 et résultats pour l'évaluation des performances (Cortex A7 et A15).
  * **exo3/** : Données et scripts relatifs à l'étude de la localité des caches (Multiplication de matrices).

---

## Auteurs
* Lucca Amodio
* Vinicius Cesar Cavallaro Zancheta
* Serena Dagher
* Danylo Danyliuk

*Projet réalisé en février 2026.*