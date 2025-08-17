% Alibis déclarés
alibi_declare(jean_martin, '20h-22h', 'reunion_travail', alice_petit).
alibi_declare(pierre_bernard, '19h-23h', 'garde_hopital', infirmiere_chef).
alibi_declare(sophie_laurent, '18h-21h', 'restaurant', serveur).
alibi_declare(thomas_moreau, '20h-21h', 'domicile_seul', aucun).

% Vérification des alibis par les enquêteurs
alibi_verifie(jean_martin, false).    % Alice a menti
alibi_verifie(pierre_bernard, true).
alibi_verifie(sophie_laurent, false). % Pas de trace au restaurant
alibi_verifie(thomas_moreau, false).  % Pas de témoin

% Preuves physiques
preuve_physique(empreintes_digitales, thomas_moreau, scene_crime, haute).
preuve_physique(fibres_textile, sophie_laurent, vetements_victime, moyenne).
preuve_physique(adn, jean_martin, sous_ongles_victime, haute).
preuve_physique(cheveux, pierre_bernard, aspirateur, faible).

% Temoignages
temoignage(voisin_1, '20h30', 'dispute_violente', marie_dubois, jean_martin).
temoignage(voisin_2, '21h00', 'cris_femme', marie_dubois, inconnue).
temoignage(passant, '21h15', 'homme_fuyant', thomas_moreau, scene_crime).