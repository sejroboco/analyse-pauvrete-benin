# 📊 Analyse de la pauvreté au Bénin à partir des données EHCVM

Ce projet présente une analyse approfondie des indicateurs de pauvreté au Bénin, à partir des données de l’Enquête Harmonisée sur les Conditions de Vie des Ménages (EHCVM 2018-2019). Il s'inscrit dans une démarche de compréhension des facteurs économiques et sociaux influençant la pauvreté, à travers des méthodes statistiques et économétriques mises en œuvre sous STATA.

## 🎯 Objectifs

- Calculer les indicateurs de pauvreté : taux, profondeur, sévérité.
- Étudier la répartition de la pauvreté selon le sexe, le milieu, la religion et le département.
- Analyser la distribution des revenus via la courbe de Lorenz et l’indice de Gini.
- Estimer des modèles logit et probit pour identifier les déterminants de la pauvreté.
- Interpréter les effets marginaux, les élasticités et les odds ratios.

## 🧰 Technologies utilisées

- **Langage** : STATA
- **Données** : EHCVM 2018–2019 (8 012 ménages)
- **Méthodes** : statistiques descriptives, modèles logit & probit, évaluation ROC

## 📥 Accès aux données

> ℹ️ Pour des raisons de confidentialité, les données ne sont pas incluses dans le dépôt.

Les données utilisées sont disponibles ici :  
🔗 [Lien Google Drive vers les données EHCVM](https://drive.google.com/drive/folders/1Y-u6RVQvFcXxxRDtEXk8tyzH9e-zcTww?usp=drive_link)

## 📈 Résultats clés

- **Taux de pauvreté national** : 38,5 %
- **Par milieu** : 44,2 % en rural contre 31,4 % en urbain
- **Indice de Gini** : 0,360
- **Courbe de Lorenz** construite et analysée
- **Modèle logit** :
  - Effet positif de la taille du ménage
  - Effet négatif des consommations alimentaires et non alimentaires
  - AUC : 0.9827, précision de classification : 95 %

## 📌 Exemple d’indicateurs par département

| Département | Taux de pauvreté (%) |
|-------------|----------------------|
| Atacora     | 60,5 %               |
| Littoral    | 18,8 %               |
| Borgou      | 53,3 %               |

## ✍️ Auteur

- **Nom** : Sèjro Toussaint BOCO
- **Contact** : sejroboco9@gmail.com
