# Système d'Enquête Policière en Prolog

Un système expert développé en Prolog pour simuler et analyser des enquêtes criminelles. Le système utilise des faits et des règles d'inférence pour calculer des scores de suspicion et identifier des suspects potentiels.

## 🎯 Fonctionnalités Principales

- **Calcul automatique de scores de suspicion** basé sur multiple critères
- **Analyse des motifs** (héritage, dettes, rivalités professionnelles, etc.)
- **Vérification des alibis** et détection des incohérences
- **Évaluation des preuves physiques** avec niveaux de fiabilité
- **Analyse des témoignages** et comportements suspects
- **Génération de rapports** d'enquête complets
- **Recommandations d'action** pour les enquêteurs

## 📁 Architecture Modulaire

```
enquete-meurtre/
├── README.md
├── main.pl                 # Point d'entrée principal avec aide
├── data/
│   ├── personnes.pl        # Personnes, relations, motifs, accès
│   ├── preuves.pl          # Preuves physiques, témoignages, alibis
│   └── comportements.pl    # Comportements suspects et antécédents
├── regles/
│   ├── scoring.pl          # Calcul des scores de suspicion
│   ├── classification.pl   # Classification et suspect principal
│   └── analysis.pl         # Analyse avancée et cohérence
└── rapports/
    ├── generation.pl       # Génération des rapports principaux
    └── queries.pl          # Requêtes spécialisées pour enquêteurs
```

## 🚀 Installation et Utilisation

### Prérequis
- SWI-Prolog installé sur votre système

### Lancement
```bash
$ swipl
?- [main].
```

Le système s'initialise automatiquement et affiche l'aide disponible.

### Commandes Principales

Pour voir toutes les commandes disponibles :
```prolog
?- help.
```

#### Rapport Complet d'Enquête
```prolog
?- rapport_enquete.
```
Génère un rapport détaillé avec l'analyse de tous les suspects, le suspect principal, les preuves et recommandations.

#### Liste des Suspects
```prolog
?- tous_suspects.
```
Affiche tous les suspects avec leurs scores de suspicion et niveaux.

#### Analyse Spécifique d'un Suspect
```prolog
?- analyser_suspect(jean_martin).
```
Analyse détaillée d'un suspect avec décomposition des scores.

#### Identification du Suspect Principal
```prolog
?- suspect_principal(X).
```
Identifie le suspect avec le score le plus élevé.

#### Vérification de la Cohérence
```prolog
?- coherence_enquete.
```
Vérifie la cohérence des preuves contre le suspect principal.

#### Analyse des Faiblesses
```prolog
?- faiblesses_enquete.
```
Identifie les points faibles de l'enquête (alibis solides, manque de preuves).

## 📊 Système de Scoring

Le système calcule un score de suspicion basé sur 6 critères principaux :

### 1. Motifs (0-30 points)
- **Héritage** (>100k): 30 points
- **Dettes** (>20k): 25 points  
- **Licenciement**: 20 points
- **Rivalité professionnelle**: 15 points

### 2. Alibis (0-25 points)
- **Alibi non vérifié**: 25 points
- **Pas d'alibi déclaré**: 15 points
- **Alibi vérifié**: 0 point

### 3. Preuves Physiques (0-30+ points par preuve)
- **Haute fiabilité**: 30 points
- **Moyenne fiabilité**: 15 points
- **Faible fiabilité**: 5 points

### 4. Témoignages (20 points par témoignage)
- Chaque témoignage impliquant le suspect ajoute 20 points

### 5. Comportements Suspects (0-20 points)
- **Haute suspicion**: 20 points
- **Moyenne suspicion**: 10 points
- **Faible suspicion**: 5 points

### 6. Antécédents (0-25 points)
- **Violence conjugale**: 25 points
- **Escroquerie**: 10 points
- **Autres**: 5 points

## 📈 Classification des Suspects

- **Très Élevé** (≥80 points): Arrestation recommandée
- **Élevé** (60-79 points): Garde à vue prolongée
- **Modéré** (30-59 points): Surveillance discrète
- **Faible** (<30 points): Élargir les recherches

## 🔍 Cas d'Étude Inclus

Le système inclut une affaire complète avec :
- **Victime**: Marie Dubois
- **5 Suspects**: Jean Martin (époux), Pierre Bernard (médecin), Sophie Laurent (avocate), Thomas Moreau (jardinier), Alice Petit (secrétaire)
- **Relations complexes** entre les personnes
- **Preuves physiques** variées (ADN, empreintes, fibres)
- **Témoignages** de voisins et passants
- **Motifs** financiers et personnels

## 🔧 Requêtes Avancées

### Recherche par Type de Preuve
```prolog
?- preuves_type(empreintes_digitales).
```

### Suspects par Motif
```prolog
?- suspects_par_motif(heritage).
```

### Suspects sans Alibi
```prolog
?- suspects_sans_alibi.
```

### Preuves par Fiabilité
```prolog
?- preuves_par_fiabilite(haute).
```

### Détection de Complices Potentiels
```prolog
?- lien_complice_potentiel(X, Y).
```

## 🛠️ Extension du Système

### Ajouter un Nouveau Suspect
```prolog
% Dans data/personnes.pl
personne(nouveau_suspect).
profession(nouveau_suspect, metier).
motif(nouveau_suspect, type_motif, montant).
```

### Ajouter de Nouveaux Types de Preuves
```prolog
% Dans data/preuves.pl
preuve_physique(nouveau_type, suspect, lieu, fiabilite).
```

### Modifier les Règles de Scoring
Les règles de calcul peuvent être ajustées dans `regles/scoring.pl` selon les besoins spécifiques de l'enquête.

### Ajouter de Nouvelles Analyses
Créez de nouvelles règles dans `regles/analysis.pl` pour des analyses personnalisées.

## 📝 Exemples de Requêtes Utiles

```prolog
% Score d'un suspect spécifique
?- score_suspicion(thomas_moreau, Score).

% Niveau de suspicion
?- niveau_suspicion(jean_martin, Niveau).

% Toutes les preuves contre un suspect
?- preuve_physique(Type, jean_martin, Lieu, Fiabilite).

% Vérification d'alibi
?- alibi_verifie(sophie_laurent, Verifie).

% Relations d'une personne
?- relation(marie_dubois, X, Type).

% Motifs financiers importants
?- motif(X, _, Montant), Montant > 100000.
```

## 🚀 Démarrage Rapide

1. **Charger le système** :
   ```prolog
   ?- [main].
   ```

2. **Voir l'aide** :
   ```prolog
   ?- help.
   ```

3. **Générer un rapport complet** :
   ```prolog
   ?- rapport_enquete.
   ```

4. **Analyser le suspect principal** :
   ```prolog
   ?- suspect_principal(X), analyser_suspect(X).
   ```

## 📋 Résultats Attendus

Avec les données incluses, le système devrait identifier **Jean Martin** comme suspect principal avec un score élevé basé sur :
- Motif d'héritage important (500k€)
- Alibi non vérifié
- Preuves ADN de haute fiabilité
- Témoignage de dispute
- Comportement nerveux

## 🔍 Structure des Données

### Types de Relations
- `epoux` : Relations conjugales
- `ami` : Relations d'amitié
- `collegue` : Relations professionnelles
- `employe` : Relations employeur/employé

### Niveaux de Fiabilité des Preuves
- `haute` : Preuves irréfutables (ADN, empreintes claires)
- `moyenne` : Preuves probantes mais contestables
- `faible` : Indices légers, présomptions

### Types de Comportements Suspects
- `nervosite_interrogatoire`
- `contradictions_recit`
- `fuite_interrogatoire`
- `calme_inhabituel`

## 🤝 Contribution

Pour contribuer au projet :
1. Forkez le repository
2. Créez une branche pour votre fonctionnalité
3. Respectez l'architecture modulaire existante
4. Ajoutez des tests dans les modules appropriés
5. Documentez les nouvelles règles et prédicats
6. Soumettez une pull request

### Conventions de Code
- Utilisez des noms explicites pour les prédicats
- Commentez les règles complexes
- Respectez la séparation des responsabilités par module
- Testez avec `?- help.` après modifications
