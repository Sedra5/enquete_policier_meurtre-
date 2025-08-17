% Classification du niveau de suspicion
niveau_suspicion(Personne, tres_eleve) :-
    score_suspicion(Personne, Score),
    Score >= 80.

niveau_suspicion(Personne, eleve) :-
    score_suspicion(Personne, Score),
    Score >= 60, Score < 80.

niveau_suspicion(Personne, modere) :-
    score_suspicion(Personne, Score),
    Score >= 30, Score < 60.

niveau_suspicion(Personne, faible) :-
    score_suspicion(Personne, Score),
    Score < 30.

% Identification du suspect principal
suspect_principal(Personne) :-
    score_suspicion(Personne, Score),
    \+ (score_suspicion(AutrePersonne, AutreScore), 
        AutrePersonne \= Personne, 
        AutreScore > Score).