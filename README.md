**Q1 – Paramètres du simulateur de cache gem5**

Dans cette question, nous déterminons les paramètres d’entrée du simulateur de cache gem5 pour les deux configurations de caches décrites dans le Tableau 7.

L’associativité est déduite du type d’organisation du cache : un cache direct-mapped correspond à une associativité égale à 1, tandis qu’un cache n-way set associative possède une associativité égale à n.

Pour la configuration C1, les trois niveaux de cache (IL1, DL1 et UL2) sont de type direct-mapped. Les paramètres du simulateur sont donc :

IL1 : 4 KB, associativité 1, taille de bloc 32 octets

DL1 : 4 KB, associativité 1, taille de bloc 32 octets

UL2 : 32 KB, associativité 1, taille de bloc 32 octets

Pour la configuration C2, le cache d’instructions L1 reste direct-mapped, tandis que le cache de données L1 est 2-way set associative et le cache L2 est 4-way set associative. Les paramètres correspondants sont :

IL1 : 4 KB, associativité 1, taille de bloc 32 octets

DL1 : 4 KB, associativité 2, taille de bloc 32 octets

UL2 : 32 KB, associativité 4, taille de bloc 32 octets
