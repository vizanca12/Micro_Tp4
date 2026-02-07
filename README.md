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

**Tableau 9 : Taux de défauts dans le cache d’instructions (IL1)**

| Programmes | Configuration C1 (Direct Mapped) | Configuration C2 (Associative) |
| :--- | :---: | :---: |
| **P1 (normale)** | 0.014486 | 0.013586 |
| **P2 (pointeur)**| 0.027285 | 0.025370 |
| **P3 (tempo)** | 0.016803 | 0.015720 |
| **P4 (unrol)** | 0.036662 | 0.033995 |

**Tableau 10 : Taux de défauts dans le cache de données (DL1)**

| Programmes | Configuration C1 (Direct Mapped) | Configuration C2 (Associative) |
| :--- | :---: | :---: |
| **P1 (normale)** | 0.122857 | 0.059671 |
| **P2 (pointeur)**| 0.135399 | 0.073022 |
| **P3 (tempo)** | 0.080969 | 0.065929 |
| **P4 (unrol)** | 0.090562 | 0.074574 |

**Tableau 11 : Taux de défauts dans le cache unifié (UL2)**

| Programmes | Configuration C1 (Direct Mapped) | Configuration C2 (Associative) |
| :--- | :---: | :---: |
| **P1 (normale)** | 0.122404 | 0.010338 |
| **P2 (pointeur)**| 0.111330 | 0.010227 |
| **P3 (tempo)** | 0.154461 | 0.007942 |
| **P4 (unrol)** | 0.145938 | 0.008691 |

## Q3 – Analyse de la localité de référence pour le code

**Question :** Les 4 algorithmes de multiplication de matrices présentent-ils une bonne localité de références pour le **code** ? Pourquoi ?

**Réponse :**

En analysant le Tableau 9 (*IL1 Miss Rate*), nous pouvons conclure que les algorithmes présentent globalement une bonne localité de référence pour le code, mais avec des variations notables selon la technique d'optimisation utilisée :

1.  **P1 (Normale) et P3 (Tempo) :** Ces versions présentent la **meilleure localité** (taux de défauts très faibles, ~1.4% - 1.6%).
    * **Pourquoi ?** Le code principal est constitué de boucles `for` imbriquées très compactes. Ces instructions tiennent facilement dans le cache L1 d'instructions (4 KB). Une fois chargées, elles sont réutilisées de nombreuses fois (forte localité temporelle) sans générer de nouveaux défauts.

2.  **P4 (Unroll) :** Cette version présente la **moins bonne localité de code** parmi les quatre (taux de défauts le plus élevé, ~3.4% - 3.7%).
    * **Pourquoi ?** La technique de *Loop Unrolling* (déroulage de boucle) consiste à dupliquer le corps de la boucle pour réduire le nombre de tests et de sauts. Cela augmente mécaniquement la **taille du code binaire** (*code bloat*). Le programme étant plus volumineux, il occupe davantage d'espace dans le cache d'instructions, augmentant ainsi les risques de conflits et d'évictions, ce qui dégrade légèrement la performance du cache IL1.

En résumé, bien que la localité reste correcte pour tous, l'optimisation par déroulage de boucle (P4) a un coût négatif sur la localité du code par rapport aux versions plus compactes (P1 et P3).