% Analyse des liens entre suspects
lien_complice_potentiel(Personne1, Personne2) :-
    relation(Personne1, Personne2, Type),
    member(Type, [epoux, ami, collegue, employe]),
    niveau_suspicion(Personne1, Niveau1),
    niveau_suspicion(Personne2, Niveau2),
    member(Niveau1, [eleve, tres_eleve]),
    member(Niveau2, [modere, eleve]).

% Coherence des preuves
preuves_coherentes(Personne) :-
    preuve_physique(_, Personne, _, _),
    temoignage(_, _, _, _, Personne),
    alibi_verifie(Personne, false).

% Verification de la coherence globale
coherence_enquete :-
    suspect_principal(Principal),
    (   preuves_coherentes(Principal) ->
        write('Enquete coherente: preuves convergentes contre '), write(Principal)
    ;   write('ATTENTION: Incoherences dans les preuves')
    ), nl.

% Analyse des faiblesses de l'enquete
faiblesses_enquete :-
    write('FAIBLESSES DE L\'ENQUETE'), nl,
    forall((personne(P), \+ victime(P), alibi_verifie(P, true)),
           (write('- Alibi solide pour '), write(P), nl)),
    forall((personne(P), \+ victime(P), \+ preuve_physique(_, P, _, _)),
           (write('- Aucune preuve physique contre '), write(P), nl)).