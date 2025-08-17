% Calcul du score de suspicion global
score_suspicion(Personne, Score) :-
    personne(Personne),
    \+ victime(Personne),
    score_motif(Personne, ScoreMotif),
    score_alibi(Personne, ScoreAlibi),
    score_preuves(Personne, ScorePreuves),
    score_temoignages(Personne, ScoreTemoignages),
    score_comportement(Personne, ScoreComportement),
    score_antecedents(Personne, ScoreAntecedents),
    Score is ScoreMotif + ScoreAlibi + ScorePreuves + ScoreTemoignages + ScoreComportement + ScoreAntecedents.

% Score base sur les motifs
score_motif(Personne, Score) :-
    motif(Personne, Type, Montant),
    (   Type = heritage, Montant > 100000 -> Score = 30
    ;   Type = dette, Montant > 20000 -> Score = 25
    ;   Type = rivalite_professionnelle -> Score = 15
    ;   Type = licenciement -> Score = 20
    ;   Score = 0
    ).
score_motif(Personne, 0) :- personne(Personne), \+ motif(Personne, _, _).

% Score base sur les alibis
score_alibi(Personne, Score) :-
    alibi_verifie(Personne, Verifie),
    (   Verifie = false -> Score = 25
    ;   Score = 0
    ).
score_alibi(Personne, 15) :- personne(Personne), \+ alibi_declare(Personne, _, _, _).

% Score base sur les preuves physiques
score_preuves(Personne, Score) :-
    findall(Fiabilite, preuve_physique(_, Personne, _, Fiabilite), Preuves),
    score_preuves_liste(Preuves, Score).
score_preuves(Personne, 0) :- personne(Personne), \+ preuve_physique(_, Personne, _, _).

score_preuves_liste([], 0).
score_preuves_liste([haute|Rest], Score) :-
    score_preuves_liste(Rest, RestScore),
    Score is RestScore + 30.
score_preuves_liste([moyenne|Rest], Score) :-
    score_preuves_liste(Rest, RestScore),
    Score is RestScore + 15.
score_preuves_liste([faible|Rest], Score) :-
    score_preuves_liste(Rest, RestScore),
    Score is RestScore + 5.

% Score base sur les temoignages
score_temoignages(Personne, Score) :-
    findall(1, temoignage(_, _, _, _, Personne), Temoignages),
    length(Temoignages, NbTemoignages),
    Score is NbTemoignages * 20.
score_temoignages(Personne, 0) :- personne(Personne), \+ temoignage(_, _, _, _, Personne).

% Score base sur les comportements suspects
score_comportement(Personne, Score) :-
    comportement_suspect(Personne, _, Niveau),
    (   Niveau = haute -> Score = 20
    ;   Niveau = moyenne -> Score = 10
    ;   Niveau = faible -> Score = 5
    ).
score_comportement(Personne, 0) :- personne(Personne), \+ comportement_suspect(Personne, _, _).

% Score base sur les antecedents
score_antecedents(Personne, Score) :-
    antecedent(Personne, Type, _),
    (   Type = violence_conjugale -> Score = 25
    ;   Type = escroquerie -> Score = 10
    ;   Score = 5
    ).
score_antecedents(Personne, 0) :- personne(Personne), \+ antecedent(Personne, _, _).