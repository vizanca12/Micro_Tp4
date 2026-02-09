# Rapport TP4 : Hiérarchie Mémoire et Caches

## Q1 – Paramètres du simulateur de cache gem5

Dans cette question, nous déterminons les paramètres d’entrée du simulateur de cache gem5 pour les deux configurations de caches décrites dans le Tableau 7.

L’associativité est déduite du type d’organisation du cache : un cache direct-mapped correspond à une associativité égale à 1, tandis qu’un cache n-way set associative possède une associativité égale à n.

Pour la configuration C1, les trois niveaux de cache (IL1, DL1 et UL2) sont de type direct-mapped. Les paramètres du simulateur sont donc :

* **IL1** : 4 KB, associativité 1, taille de bloc 32 octets
* **DL1** : 4 KB, associativité 1, taille de bloc 32 octets
* **UL2** : 32 KB, associativité 1, taille de bloc 32 octets

Pour la configuration C2, le cache d’instructions L1 reste direct-mapped, tandis que le cache de données L1 est 2-way set associative et le cache L2 est 4-way set associative. Les paramètres correspondants sont :

* **IL1** : 4 KB, associativité 1, taille de bloc 32 octets
* **DL1** : 4 KB, associativité 2, taille de bloc 32 octets
* **UL2** : 32 KB, associativité 4, taille de bloc 32 octets


## Q2 – Résultats des simulations (Taux de défauts)

Nous avons simulé les quatre variantes de l’algorithme de multiplication de matrices (P1, P2, P3, P4) sur les deux configurations de caches (C1 et C2). Les tableaux ci-dessous résument les taux de défauts (*Miss Rates*) obtenus via gem5.

### Tableau 9 — Instruction Cache (IL1) Miss Rate

| Programme        | C1        | C2        |
|------------------|-----------|-----------|
| P1 (normale)     | 0.000097  | 0.000096  |
| P2 (pointeur)    | 0.000088  | 0.000088  |
| P3 (tempo)       | 0.000088  | 0.000088  |
| P4 (unrol)       | 0.000133  | 0.000134  |


### Tableau 10 — Data Cache (DL1) Miss Rate

| Programme        | C1        | C2        |
|------------------|-----------|-----------|
| P1 (normale)     | 0.201756  | 0.208527  |
| P2 (pointeur)    | 0.199701  | 0.205574  |
| P3 (tempo)       | 0.199700  | 0.205575  |
| P4 (unrol)       | 0.290973  | 0.299470  |


### Tableau 11 — Unified Cache L2 (UL2) Miss Rate

| Programme        | C1        | C2        |
|------------------|-----------|-----------|
| P1 (normale)     | 0.494761  | 0.412146  |
| P2 (pointeur)    | 0.500437  | 0.422006  |
| P3 (tempo)       | 0.500438  | 0.422006  |
| P4 (unrol)       | 0.500487  | 0.422118  |


## Q3 — Localité de références du code

Les quatre algorithmes de multiplication de matrices présentent une **bonne localité de références pour le code**.  
Leur exécution repose principalement sur des **boucles imbriquées** qui réutilisent les mêmes instructions de façon répétitive.  
La taille du code est **faible par rapport à la taille du cache d’instructions (4 KB)**, ce qui permet de conserver la majorité des instructions en cache et explique les **taux de défauts très faibles** observés.  

L’algorithme `unrol` présente un taux légèrement plus élevé, car le déroulage de boucles augmente la taille du code, mais la localité reste globalement excellente.
