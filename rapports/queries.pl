% Lister tous les suspects avec leurs scores
tous_suspects :-
    write('LISTE DES SUSPECTS'), nl,
    forall((personne(P), \+ victime(P)),
           (write(P), write(': '), score_suspicion(P, S), write(S), 
            write(' points ('), niveau_suspicion(P, N), write(N), write(')'), nl)).

% Analyser un suspect specifique
analyser_suspect(Personne) :-
    write('ANALYSE DE '), write(Personne), nl,
    write('Score total: '), score_suspicion(Personne, Score), write(Score), nl,
    write('Niveau de suspicion: '), niveau_suspicion(Personne, Niveau), write(Niveau), nl,
    nl,
    write('Détail des scores:'), nl,
    score_motif(Personne, SM), write('- Motif: '), write(SM), nl,
    score_alibi(Personne, SA), write('- Alibi: '), write(SA), nl,
    score_preuves(Personne, SP), write('- Preuves: '), write(SP), nl,
    score_temoignages(Personne, ST), write('- Temoignages: '), write(ST), nl,
    score_comportement(Personne, SC), write('- Comportement: '), write(SC), nl,
    score_antecedents(Personne, SA2), write('- Antécédents: '), write(SA2), nl.

% Rechercher par type de preuve
preuves_type(Type) :-
    write(' PREUVES DE TYPE '), write(Type), nl,
    forall(preuve_physique(Type, Personne, Lieu, Fiabilite),
           (write('Contre '), write(Personne), write(' - Lieu: '), write(Lieu),
            write(' - Fiabilite: '), write(Fiabilite), nl)).

% Recherche avancée par critere
suspects_par_motif(TypeMotif) :-
    write('=== SUSPECTS AVEC MOTIF: '), write(TypeMotif), write(' ==='), nl,
    forall(motif(Personne, TypeMotif, Montant),
           (write('- '), write(Personne), 
            (Montant > 0 -> (write(' ('), write(Montant), write(' euros)')) ; true), nl)).

% Suspects sans alibi verifie
suspects_sans_alibi :-
    write('SUSPECTS SANS ALIBI VERIFIE'), nl,
    forall((personne(P), \+ victime(P), 
            (alibi_verifie(P, false) ; \+ alibi_declare(P, _, _, _))),
           (write('- '), write(P), nl)).

% Preuves par niveau de fiabilite
preuves_par_fiabilite(Niveau) :-
    write('PREUVES DE FIABILITE'), write(Niveau), nl,
    forall(preuve_physique(Type, Personne, Lieu, Niveau),
           (write('- '), write(Type), write(' contre '), write(Personne), 
            write(' ('), write(Lieu), write(')'), nl)).