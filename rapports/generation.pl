% Generation du rapport de synthese
rapport_enquete :-
    write('RAPPORT D\'ENQUETE CRIMINELLE'), nl, nl,
    write('1. ANALYSE DES SUSPECTS:'), nl,
    forall((personne(P), \+ victime(P)), 
           (write('   '), write(P), 
            write(' - Score: '), score_suspicion(P, S), write(S),
            write(' - Niveau: '), niveau_suspicion(P, N), write(N), nl)),
    nl,
    write('2. SUSPECT PRINCIPAL:'), nl,
    suspect_principal(Principal),
    write('   '), write(Principal), nl,
    nl,
    write('3. PREUVES CONTRE LE SUSPECT PRINCIPAL:'), nl,
    forall(preuve_physique(Type, Principal, Lieu, Fiabilite),
           (write('   '), write(Type), write(' ('), write(Lieu), write(') - '), 
            write('Fiabilite: '), write(Fiabilite), nl)),
    nl,
    write('4. TEMOIGNAGES IMPLIQUANT LE SUSPECT:'), nl,
    forall(temoignage(Temoin, Heure, Description, _, Principal),
           (write('   '), write(Temoin), write(' ('), write(Heure), write('): '), 
            write(Description), nl)),
    nl,
    write('5. RECOMMANDATIONS:'), nl,
    recommandations_enquete(Principal).

% Recommandations basees sur l'analyse
recommandations_enquete(Suspect) :-
    score_suspicion(Suspect, Score),
    (   Score >= 80 ->
        write('   - ARRESTATION IMMEDIATE recommandee'), nl,
        write('   - Preuves suffisantes pour inculpation'), nl
    ;   Score >= 60 ->
        write('   - GARDE A VUE prolongee recommandee'), nl,
        write('   - Recherche de preuves supplémentaires'), nl
    ;   Score >= 30 ->
        write('   - Surveillance discrete recommandee'), nl,
        write('   - Approfondissement de l\'enquete'), nl
    ;   write('   - Elargir les recherches à d\'autres suspects'), nl
    ).