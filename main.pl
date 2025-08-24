:- consult('data/personnes.pl').
:- consult('data/preuves.pl').
:- consult('data/comportements.pl').
:- consult('regles/scoring.pl').
:- consult('regles/classification.pl').
:- consult('regles/analysis.pl').
:- consult('rapports/generation.pl').
:- consult('rapports/queries.pl').


init_system :-
    write(' SYSTEME D\'ENQUETE POLICIERE PROLOG '), nl,
    write('Systeme initialise avec succes.'), nl,
    write('Tapez help. pour voir les commandes disponibles.'), nl, nl.


help :-
    write('INFORMATIONS GÉNÉRALES:                                  '), nl,
    write('1. victime.                         - Info victime       '), nl,
    write('2. toutes_relations.                - Toutes relations   '), nl,
    write('3. tous_temoignages.                - Tous témoignages   '), nl,
    write('4. tous_comportements.              - Comportements      '), nl,
    write('ANALYSE DES SUSPECTS:                                    '), nl,
    write('5. tous_suspects.                   - Liste suspects     '), nl,
    write('6. analyser_suspect(Nom).           - Analyse détaillée  '), nl,
    write('7. suspect_principal(X).            - Suspect principal  '), nl,
    write('8. suspects_sans_alibi.             - Sans alibi vérifié '), nl,
    write('9. types_motifs.                    - Types de motifs    '), nl,
    write('10. suspects_par_motif(Type).       - Par type de motif  '), nl,
    write('PREUVES ET TÉMOIGNAGES:                                  '), nl,
    write('11. toutes_preuves.                 - Toutes les preuves '), nl,
    write('12. types_preuves.                  - Types de preuves   '), nl,
    write('13. niveaux_fiabilite.              - Niveaux fiabilité  '), nl,
    write('14. preuves_type(Type).             - Preuves par type   '), nl,
    write('15. preuves_par_fiabilite(Niveau).  - Par fiabilité     '), nl,
    write('ANALYSE AVANCÉE:                                         '), nl,
    write('16. coherence_enquete.              - Cohérence globale  '), nl,
    write('17. faiblesses_enquete.             - Faiblesses         '), nl,
    write('18. lien_complice_potentiel(X,Y).   - Complices          '), nl,
    write('RAPPORT COMPLET:                                         '), nl,
    write('19. rapport_enquete.                - Rapport complet    '), nl,
    write('EXEMPLES D\'UTILISATION:                                  '), nl,
    write('- analyser_suspect(jean_martin).                        '), nl,
    write('- types_motifs.                                         '), nl,
    write('- types_preuves.                                        '), nl,
    write('- niveaux_fiabilite.                                    '), nl,
    write('- preuves_type(adn).                                    '), nl,
    write('- suspects_par_motif(heritage).                         '), nl,
    write('- lien_complice_potentiel(jean_martin,alice_petit).     '), nl,


:- initialization(init_system).