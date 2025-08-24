import asyncio
import websockets
import subprocess
import json
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def query_prolog(query):
    try:
        result = subprocess.run(
            ['swipl', '-q', '-g', query, '-t', 'halt', 'main.pl'],
            capture_output=True, 
            text=True,
            timeout=10
        )
        
        if result.returncode == 0:
            return {
                'success': True,
                'result': result.stdout.strip(),
                'error': None
            }
        else:
            return {
                'success': False,
                'result': None,
                'error': result.stderr.strip() or 'Erreur Prolog inconnue'
            }
    except subprocess.TimeoutExpired:
        return {
            'success': False,
            'result': None,
            'error': 'Timeout: La requête Prolog a pris trop de temps'
        }
    except FileNotFoundError:
        return {
            'success': False,
            'result': None,
            'error': 'SWI-Prolog non trouvé. Assurez-vous qu\'il est installé et dans le PATH'
        }
    except Exception as e:
        return {
            'success': False,
            'result': None,
            'error': f'Erreur lors de l\'exécution: {str(e)}'
        }

async def handle_client(websocket):
    client_address = f"{websocket.remote_address[0]}:{websocket.remote_address[1]}"
    logger.info(f"Nouvelle connexion de {client_address}")
    
    try:
        welcome_msg = {
            'type': 'welcome',
            'message': 'Bienvenue sur l\'enquête policière type assassinat',
            'instruction': 'Tapez help pour voir toutes les commandes',
            'status': 'connected'
        }
        await websocket.send(json.dumps(welcome_msg))
    
        async for message in websocket:
            try:
                logger.info(f"Message reçu de {client_address}: {message}")
                
                message_lower = message.strip().lower()
                
                if message_lower == 'help':
                    data = {'type': 'help'}
                elif message_lower == 'rapport':
                    data = {'type': 'rapport'}
                elif message_lower == 'suspects':
                    data = {'type': 'tous_suspects'}
                elif message_lower == 'principal':
                    data = {'type': 'suspect_principal'}
                elif message_lower == 'coherence':
                    data = {'type': 'coherence_enquete'}
                elif message_lower == 'faiblesses':
                    data = {'type': 'faiblesses_enquete'}
                elif message_lower == 'ping':
                    data = {'type': 'ping'}
            
                elif message_lower == 'victime':
                    data = {'type': 'victime'}
                elif message_lower == 'relations':
                    data = {'type': 'toutes_relations'}
                elif message_lower == 'temoignages':
                    data = {'type': 'tous_temoignages'}
                elif message_lower == 'comportements':
                    data = {'type': 'tous_comportements'}
                elif message_lower == 'sans_alibi':
                    data = {'type': 'suspects_sans_alibi'}
                elif message_lower == 'motifs':
                    data = {'type': 'types_motifs'}
                elif message_lower == 'preuves':
                    data = {'type': 'toutes_preuves'}
                elif message_lower == 'types_preuves':
                    data = {'type': 'types_preuves'}
                elif message_lower == 'fiabilite':
                    data = {'type': 'niveaux_fiabilite'}
                
                elif message_lower.startswith('analyser '):
                    nom = message_lower.replace('analyser ', '').strip()
                    if nom:
                        data = {'type': 'analyser_suspect', 'nom': nom}
                    else:
                        data = {'type': 'unknown'}
                elif message_lower.startswith('preuves '):
                    type_preuve = message_lower.replace('preuves ', '').strip()
                    if type_preuve:
                        data = {'type': 'preuves_type', 'type': type_preuve}
                    else:
                        data = {'type': 'unknown'}
                elif message_lower.startswith('motif '):
                    type_motif = message_lower.replace('motif ', '').strip()
                    if type_motif:
                        data = {'type': 'suspects_par_motif', 'motif': type_motif}
                    else:
                        data = {'type': 'unknown'}
                elif message_lower.startswith('niveau '):
                    niveau = message_lower.replace('niveau ', '').strip()
                    if niveau:
                        data = {'type': 'preuves_par_fiabilite', 'niveau': niveau}
                    else:
                        data = {'type': 'unknown'}
                elif message_lower.startswith('complices '):
                    parts = message_lower.replace('complices ', '').strip().split()
                    if len(parts) >= 2:
                        data = {'type': 'lien_complice_potentiel', 'x': parts[0], 'y': parts[1]}
                    else:
                        data = {'type': 'unknown'}
                else:
                   
                    try:
                        data = json.loads(message)
                    except json.JSONDecodeError:
                        data = {'type': 'unknown'}
                
                request_type = data.get('type', '')
                
                if request_type == 'rapport':
                    logger.info(f"Exécution du rapport pour {client_address}")
                    result = query_prolog('rapport_enquete')
                    response = {
                        'type': 'rapport_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Rapport envoyé à {client_address}")
                    
                elif request_type == 'tous_suspects':
                    logger.info(f"Liste tous les suspects pour {client_address}")
                    result = query_prolog('tous_suspects')
                    response = {
                        'type': 'tous_suspects_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Liste des suspects envoyée à {client_address}")
                    
                elif request_type == 'analyser_suspect':
                    nom = data.get('nom', '')
                    if not nom:
                        error_response = {
                            'type': 'error',
                            'message': 'Le paramètre "nom" est requis pour analyser_suspect'
                        }
                        await websocket.send(json.dumps(error_response))
                    else:
                        logger.info(f"Analyse du suspect '{nom}' pour {client_address}")
                        query = f"analyser_suspect('{nom}')"
                        result = query_prolog(query)
                        response = {
                            'type': 'analyser_suspect_response',
                            'data': result,
                            'suspect': nom
                        }
                        await websocket.send(json.dumps(response))
                        logger.info(f"Analyse du suspect '{nom}' envoyée à {client_address}")
                        
                elif request_type == 'suspect_principal':
                    logger.info(f"Recherche du suspect principal pour {client_address}")
                    result = query_prolog('suspect_principal(X), write(X)')
                    response = {
                        'type': 'suspect_principal_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Suspect principal envoyé à {client_address}")
                    
                elif request_type == 'coherence_enquete':
                    logger.info(f"Vérification de cohérence pour {client_address}")
                    result = query_prolog('coherence_enquete')
                    response = {
                        'type': 'coherence_enquete_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Rapport de cohérence envoyé à {client_address}")
                    
                elif request_type == 'faiblesses_enquete':
                    logger.info(f"Analyse des faiblesses pour {client_address}")
                    result = query_prolog('faiblesses_enquete')
                    response = {
                        'type': 'faiblesses_enquete_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Analyse des faiblesses envoyée à {client_address}")
                    
                elif request_type == 'preuves_type':
                    type_preuve = data.get('type', '')
                    if not type_preuve:
                        error_response = {
                            'type': 'error',
                            'message': 'Le paramètre "type" est requis pour preuves_type'
                        }
                        await websocket.send(json.dumps(error_response))
                    else:
                        logger.info(f"Recherche preuves de type '{type_preuve}' pour {client_address}")
                        query = f"preuves_type('{type_preuve}')"
                        result = query_prolog(query)
                        response = {
                            'type': 'preuves_type_response',
                            'data': result,
                            'type_preuve': type_preuve
                        }
                        await websocket.send(json.dumps(response))
                        logger.info(f"Preuves de type '{type_preuve}' envoyées à {client_address}")
                        
                elif request_type == 'lien_complice_potentiel':
                    x = data.get('x', '')
                    y = data.get('y', '')
                    if not x or not y:
                        error_response = {
                            'type': 'error',
                            'message': 'Les paramètres "x" et "y" sont requis pour lien_complice_potentiel'
                        }
                        await websocket.send(json.dumps(error_response))
                    else:
                        logger.info(f"Recherche lien complice entre '{x}' et '{y}' pour {client_address}")
                        query = f"lien_complice_potentiel('{x}', '{y}')"
                        result = query_prolog(query)
                        response = {
                            'type': 'lien_complice_potentiel_response',
                            'data': result,
                            'x': x,
                            'y': y
                        }
                        await websocket.send(json.dumps(response))
                        logger.info(f"Lien complice entre '{x}' et '{y}' envoyé à {client_address}")

               
                elif request_type == 'victime':
                    logger.info(f"Informations victime pour {client_address}")
                    result = query_prolog('victime')
                    response = {
                        'type': 'victime_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Informations victime envoyées à {client_address}")

                elif request_type == 'toutes_relations':
                    logger.info(f"Toutes relations pour {client_address}")
                    result = query_prolog('toutes_relations')
                    response = {
                        'type': 'toutes_relations_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Toutes relations envoyées à {client_address}")

                elif request_type == 'tous_temoignages':
                    logger.info(f"Tous témoignages pour {client_address}")
                    result = query_prolog('tous_temoignages')
                    response = {
                        'type': 'tous_temoignages_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Tous témoignages envoyés à {client_address}")

                elif request_type == 'tous_comportements':
                    logger.info(f"Tous comportements pour {client_address}")
                    result = query_prolog('tous_comportements')
                    response = {
                        'type': 'tous_comportements_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Tous comportements envoyés à {client_address}")

                elif request_type == 'suspects_sans_alibi':
                    logger.info(f"Suspects sans alibi pour {client_address}")
                    result = query_prolog('suspects_sans_alibi')
                    response = {
                        'type': 'suspects_sans_alibi_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Suspects sans alibi envoyés à {client_address}")

                elif request_type == 'types_motifs':
                    logger.info(f"Types de motifs pour {client_address}")
                    result = query_prolog('types_motifs')
                    response = {
                        'type': 'types_motifs_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Types de motifs envoyés à {client_address}")

                elif request_type == 'suspects_par_motif':
                    motif = data.get('motif', '')
                    if not motif:
                        error_response = {
                            'type': 'error',
                            'message': 'Le paramètre "motif" est requis pour suspects_par_motif'
                        }
                        await websocket.send(json.dumps(error_response))
                    else:
                        logger.info(f"Suspects par motif '{motif}' pour {client_address}")
                        query = f"suspects_par_motif('{motif}')"
                        result = query_prolog(query)
                        response = {
                            'type': 'suspects_par_motif_response',
                            'data': result,
                            'motif': motif
                        }
                        await websocket.send(json.dumps(response))
                        logger.info(f"Suspects par motif '{motif}' envoyés à {client_address}")

                elif request_type == 'toutes_preuves':
                    logger.info(f"Toutes preuves pour {client_address}")
                    result = query_prolog('toutes_preuves')
                    response = {
                        'type': 'toutes_preuves_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Toutes preuves envoyées à {client_address}")

                elif request_type == 'types_preuves':
                    logger.info(f"Types de preuves pour {client_address}")
                    result = query_prolog('types_preuves')
                    response = {
                        'type': 'types_preuves_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Types de preuves envoyés à {client_address}")

                elif request_type == 'niveaux_fiabilite':
                    logger.info(f"Niveaux de fiabilité pour {client_address}")
                    result = query_prolog('niveaux_fiabilite')
                    response = {
                        'type': 'niveaux_fiabilite_response',
                        'data': result
                    }
                    await websocket.send(json.dumps(response))
                    logger.info(f"Niveaux de fiabilité envoyés à {client_address}")

                elif request_type == 'preuves_par_fiabilite':
                    niveau = data.get('niveau', '')
                    if not niveau:
                        error_response = {
                            'type': 'error',
                            'message': 'Le paramètre "niveau" est requis pour preuves_par_fiabilite'
                        }
                        await websocket.send(json.dumps(error_response))
                    else:
                        logger.info(f"Preuves par fiabilité '{niveau}' pour {client_address}")
                        query = f"preuves_par_fiabilite('{niveau}')"
                        result = query_prolog(query)
                        response = {
                            'type': 'preuves_par_fiabilite_response',
                            'data': result,
                            'niveau': niveau
                        }
                        await websocket.send(json.dumps(response))
                        logger.info(f"Preuves par fiabilité '{niveau}' envoyées à {client_address}")
                        
                elif request_type == 'help':
                    logger.info(f"Demande d'aide pour {client_address}")
                    help_info = {
                        'type': 'help_response',
                        'data': {
                            'success': True,
                            'result': '''╔══════════════════════════════════════════════════════════╗
    ║               SYSTÈME D'ENQUÊTE POLICIÈRE                ║
    ║                     TYPE ASSASSINAT                      ║
    ╠══════════════════════════════════════════════════════════╣
    ║                   COMMANDES DISPONIBLES                  ║
    ╠══════════════════════════════════════════════════════════╣
    ║ INFORMATIONS GÉNÉRALES:                                  ║
    ║ 1. victime                    - Info victime             ║
    ║ 2. relations                  - Toutes relations         ║
    ║ 3. temoignages                - Tous témoignages         ║
    ║ 4. comportements              - Comportements            ║
    ║                                                          ║
    ║ ANALYSE DES SUSPECTS:                                    ║
    ║ 5. suspects                   - Liste suspects           ║
    ║ 6. analyser [nom]             - Analyse détaillée        ║
    ║ 7. principal                  - Suspect principal        ║
    ║ 8. sans_alibi                 - Sans alibi vérifié       ║
    ║ 9. motifs                     - Types de motifs          ║
    ║ 10. motif [type]              - Par type de motif        ║
    ║                                                          ║
    ║ PREUVES ET TÉMOIGNAGES:                                  ║
    ║ 11. preuves                   - Toutes les preuves       ║
    ║ 12. types_preuves             - Types de preuves         ║
    ║ 13. fiabilite                 - Niveaux fiabilité        ║
    ║ 14. preuves [type]            - Preuves par type         ║
    ║ 15. niveau [niveau]           - Par fiabilité            ║
    ║                                                          ║
    ║ ANALYSE AVANCÉE:                                         ║
    ║ 16. coherence                 - Cohérence globale        ║
    ║ 17. faiblesses                - Faiblesses               ║
    ║ 18. complices [nom1] [nom2]   - Complices potentiels     ║
    ║                                                          ║
    ║ RAPPORT COMPLET:                                         ║
    ║ 19. rapport                   - Rapport complet          ║
    ╚══════════════════════════════════════════════════════════╝

    EXEMPLES D'UTILISATION:
    • analyser jean_martin
    • preuves physique
    • motif heritage  
    • niveau haute
    • complices jean_martin sophie_laurent''',
                            'error': None
                        }
                    }
                    await websocket.send(json.dumps(help_info))
                    logger.info(f"Aide envoyée à {client_address}")
                    
                elif request_type == 'ping':
                    # Réponse au ping
                    pong_response = {
                        'type': 'pong',
                        'message': 'pong'
                    }
                    await websocket.send(json.dumps(pong_response))
                    logger.info(f"Pong envoyé à {client_address}")
                    
                else:
                    # Commande inconnue - Message d'aide automatique
                    help_msg = {
                        'type': 'unknown_command',
                        'message': 'Commande inconnue.',
                        'instruction': 'Tapez "help" pour voir toutes les commandes disponibles.',
                        'example': 'Exemples: rapport, suspects, victime, relations, motifs'
                    }
                    await websocket.send(json.dumps(help_msg))
                    logger.info(f"Message d'aide envoyé à {client_address} pour commande inconnue")
                    
            except json.JSONDecodeError:
                # Message d'aide pour format invalide
                help_msg = {
                    'type': 'format_error',
                    'message': 'Format de commande invalide.',
                    'instruction': 'Tapez "help" pour voir toutes les commandes disponibles.',
                    'tip': 'Vous pouvez utiliser des commandes simples comme: rapport, suspects, help'
                }
                await websocket.send(json.dumps(help_msg))
                
            except Exception as e:
                logger.error(f"Erreur lors du traitement du message de {client_address}: {e}")
                error_response = {
                    'type': 'error',
                    'message': f'Erreur serveur: {str(e)}'
                }
                try:
                    await websocket.send(json.dumps(error_response))
                except:
                    pass  # La connexion est peut-être fermée
                    
    except websockets.exceptions.ConnectionClosed:
        logger.info(f"Connexion fermée par {client_address}")
    except Exception as e:
        logger.error(f"Erreur avec la connexion {client_address}: {e}")

async def main():
    host = 'localhost'
    port = 8765
    
    logger.info(f"Démarrage du serveur WebSocket sur {host}:{port}")
    
   
    test_result = query_prolog('write("Test Prolog OK"), nl')
    if not test_result['success']:
        logger.warning(f"Test Prolog échoué: {test_result['error']}")
    else:
        logger.info("Test Prolog réussi")
    
    
    server = await websockets.serve(
        handle_client,
        host,
        port,
        ping_interval=20,
        ping_timeout=10
    )

    await server.wait_closed()

if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Arrêt du serveur demandé par l'utilisateur")
    except Exception as e:
        logger.error(f"Erreur fatale: {e}")
        raise