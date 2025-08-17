% Personnes impliquees dans l'affaire
personne(marie_dubois).
personne(jean_martin).
personne(pierre_bernard).
personne(sophie_laurent).
personne(thomas_moreau).
personne(alice_petit).

% Victimes
victime(marie_dubois).

% Professions
profession(jean_martin, comptable).
profession(pierre_bernard, medecin).
profession(sophie_laurent, avocate).
profession(thomas_moreau, jardinier).
profession(alice_petit, secretaire).

% Relations entre les personnes
relation(marie_dubois, jean_martin, epoux).
relation(jean_martin, marie_dubois, epoux).
relation(marie_dubois, pierre_bernard, ami).
relation(pierre_bernard, marie_dubois, ami).
relation(sophie_laurent, marie_dubois, collegue).
relation(thomas_moreau, marie_dubois, employe).
relation(alice_petit, jean_martin, secretaire).

% Motifs potentiels
motif(jean_martin, heritage, 500000).
motif(pierre_bernard, dette, 50000).
motif(sophie_laurent, rivalite_professionnelle, 0).
motif(thomas_moreau, licenciement, 0).

% Capacites physiques et acces
% jean_martin a la clés de la maison
% Jardinier connaît les lieux
acces_lieu_crime(jean_martin, haute).     
acces_lieu_crime(thomas_moreau, moyenne).
acces_lieu_crime(sophie_laurent, faible).
acces_lieu_crime(pierre_bernard, faible).

% Situation financiere
situation_financiere(jean_martin, difficile).
situation_financiere(pierre_bernard, stable).
situation_financiere(sophie_laurent, excellente).
situation_financiere(thomas_moreau, precaire).