
victime :-
    victime(X),
    write('Le victime de l\'assassinat, c\'est Madame '),
    write(X), nl.
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
types_preuves :-
    write('TYPES DE PREUVES DISPONIBLES'), nl,
    findall(Type, preuve_physique(Type, _, _, _), TypesList),
    sort(TypesList, TypesUniques),
    length(TypesUniques, NbTypes),
    write('Nombre total de types: '), write(NbTypes), nl, nl,
    forall(member(TypeUnique, TypesUniques),
           (write('- '), write(TypeUnique), 
            findall(P, preuve_physique(TypeUnique, P, _, _), Personnes),
            length(Personnes, NbOccurrences),
            write(' ('), write(NbOccurrences), write(' occurrence'), 
            (NbOccurrences > 1 -> write('s') ; true), write(')'), nl)),
    nl.
preuves_type(Type) :-
    write(' PREUVES DE TYPE '), write(Type), nl,
    forall(preuve_physique(Type, Personne, Lieu, Fiabilite),
           (write('Contre '), write(Personne), write(' - Lieu: '), write(Lieu),
            write(' - Fiabilite: '), write(Fiabilite), nl)).

toutes_preuves :-
    write('TOUTES LES PREUVES '), nl,
    forall(preuve_physique(Type, Personne, Lieu, Fiabilite),
           (write('• '), write(Type), write(' - '), write(Personne), 
            write(' ('), write(Lieu), write(') - '), write(Fiabilite), nl)),
    nl.
% Recherche avancée par critere
types_motifs :-
    write('TYPES DE MOTIFS DISPONIBLES '), nl,
    findall(Type, motif(_, Type, _), TypesList),
    sort(TypesList, TypesUniques),
    length(TypesUniques, NbTypes),
    write('Nombre total de types: '), write(NbTypes), nl, nl,
    forall(member(TypeUnique, TypesUniques),
           (write('- '), write(TypeUnique), 
            findall(P, motif(P, TypeUnique, _), Personnes),
            length(Personnes, NbOccurrences),
            write(' ('), write(NbOccurrences), write(' suspect'), 
            (NbOccurrences > 1 -> write('s') ; true), write(')'), nl)),
    nl.
suspects_par_motif(TypeMotif) :-
    write('=== SUSPECTS AVEC MOTIF: '), write(TypeMotif), write(' ==='), nl,
    forall(motif(Personne, TypeMotif, Montant),
           (write('- '), write(Personne), 
            (Montant > 0 -> (write(' ('), write(Montant), write(' Ariary)')) ; true), nl)).

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

% Afficher tous les témoignages
tous_temoignages :-
    write('TOUS LES TEMOIGNAGES'), nl,
    forall(temoignage(Temoin, Heure, Description, Victime, Suspect),
           (write('- '), write(Temoin), write(' ('), write(Heure), write('): '), 
            write(Description), write(' - Implique: '), write(Suspect), nl)),
    nl.

% Afficher toutes les relations
toutes_relations :-
    write('TOUTES LES RELATIONS'), nl,
    forall(relation(P1, P2, Type),
           (write('- '), write(P1), write(' - '), write(P2), 
            write(' ('), write(Type), write(')'), nl)),
    nl.

% Afficher tous les comportements suspects
tous_comportements :-
    write('COMPORTEMENTS SUSPECTS'), nl,
    forall(comportement_suspect(Personne, Comportement, Niveau),
           (write('- '), write(Personne), write(': '), write(Comportement), 
            write(' ('), write(Niveau), write(')'), nl)),
    nl.

niveaux_fiabilite :-
    write('NIVEAUX DE FIABILITE DISPONIBLES '), nl,
    findall(Fiabilite, preuve_physique(_, _, _, Fiabilite), FiabilitesList),
    sort(FiabilitesList, FiabilitesUniques),
    length(FiabilitesUniques, NbNiveaux),
    write('Nombre total de niveaux: '), write(NbNiveaux), nl, nl,
    forall(member(NiveauUnique, FiabilitesUniques),
           (write('- '), write(NiveauUnique), 
            findall(Type, preuve_physique(Type, _, _, NiveauUnique), Preuves),
            length(Preuves, NbPreuves),
            write(' ('), write(NbPreuves), write(' preuve'), 
            (NbPreuves > 1 -> write('s') ; true), write(')'), nl)),
    nl.