:- consult('data/personnes.pl').
:- consult('data/preuves.pl').
:- consult('data/comportements.pl').
:- consult('regles/scoring.pl').
:- consult('regles/classification.pl').
:- consult('regles/analysis.pl').
:- consult('rapports/generation.pl').
:- consult('rapports/queries.pl').


init_system :-
    write(' SYSTEME D\'ENQUÊTE POLICIÈRE PROLOG '), nl,
    write('Systeme initialisé avec succes.'), nl,
    write('Tapez help. pour voir les commandes disponibles.'), nl, nl.


help :-
    write('=== COMMANDES DISPONIBLES ==='), nl,
    write('1. rapport_enquete.              - Rapport complet'), nl,
    write('2. tous_suspects.                - Liste tous les suspects'), nl,
    write('3. analyser_suspect(Nom).        - Analyse un suspect'), nl,
    write('4. suspect_principal(X).         - Suspect principal'), nl,
    write('5. coherence_enquete.            - Vérification cohérence'), nl,
    write('6. faiblesses_enquete.           - Analyse des faiblesses'), nl,
    write('7. preuves_type(Type).           - Preuves par type'), nl,
    write('8. lien_complice_potentiel(X,Y). - Complices potentiels'), nl, nl.


:- initialization(init_system).