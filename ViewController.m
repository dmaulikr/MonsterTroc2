//
//  ViewController.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)AlerteWithTitre:(NSString*)title andTexte:(NSString*)texte
{
    UIAlertView* alerte = [[UIAlertView alloc] initWithTitle:title message:texte delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
    [alerte show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dormir:(double)secondes
{
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:secondes];
    [NSThread sleepUntilDate:future];
}

#pragma mark - Gestion des vues

- (void)retourMenuPrincipal
{
    [self.view addSubview:Menu_principal];
}

- (void)optionsCombat
{
    [Menu_principal removeFromSuperview];
    [self.view addSubview:Options_de_combat];
}

- (void)selectionCombattants
{
    [Menu_principal removeFromSuperview];
    [Options_de_combat removeFromSuperview];
    [self.view addSubview:Selection_des_combattants];
}

- (void)plateauDeJeu
{
    [Menu_principal removeFromSuperview];
    [Options_de_combat removeFromSuperview];
    [Selection_des_combattants removeFromSuperview];
    
    [self initCombat];
}

#pragma mark - Coeur du jeu

- (void)afficher_catalog:(UIButton*)sender
{
    Tour_actuel.type = INVOQUER;
    Tour_actuel.ID = sender.tag;

    [Tableau_de_bord addSubview:Monstre_Invoc];
    
    MonstreBase *temp = [MonstresDeBase objectAtIndex:sender.tag];
    
    IM_nom.text = temp.Nom;
    IM_image.image = [UIImage imageNamed:[temp getImage]];
    //IM_type.image = [UIImage imageNamed:[NSString stringWithFormat:@"type_%d.png", temp.Spe]];
    IM_attaque.text = [NSString stringWithFormat:@"%d - %d", temp.Attaque_Min, temp.Attaque_Max];
    IM_vie.text = [NSString stringWithFormat:@"%d", temp.Vie];
    IM_PA.text = [NSString stringWithFormat:@"%d", temp.PA];
    IM_PM.text = [NSString stringWithFormat:@"%d", temp.PM];
    IM_prix.text = [NSString stringWithFormat:@"%d %@", [temp getPrix], @"%"];
}

- (void)ToucherCase:(UIButton*)sender
{
    if (!Tour_actuel.pause)
    {
        int ligne = ((sender.tag - 1) / 7) + 1;
        int colonne = sender.tag - ((ligne - 1) * 7);
        [self toucher_caseLigne:ligne andColonne:colonne];
    }
}

- (void)toucher_caseLigne:(int)ligne andColonne:(int)colonne
{
    Cellule *cellule_temp = [[Cellules objectAtIndex:ligne] objectAtIndex:colonne];
    if (!Tour_actuel.pause)
    {
        if (Tour_actuel.type == RIEN)
        {
            if (cellule_temp.etat == MONSTRE)
            {
                [Chargeur_View removeFromSuperview];
                [Tableau_de_bord addSubview:Monstre_View];
                
                Monstre *temp = [Monstres objectAtIndex:cellule_temp.ID];
                
                TBM_image.image = [UIImage imageNamed:[temp getImage]];
                TBM_nom.text = temp.Nom;
                TBM_joueur.image = [UIImage imageNamed:[NSString stringWithFormat:@"J%d.png", temp.Appartenance]];
                TBM_attaque.text = [NSString stringWithFormat:@"%d - %d", temp.Attaque_Min, temp.Attaque_Max];
                TBM_vie.text = [NSString stringWithFormat:@"%d / %d", temp.Vie, temp.Vie_Max];
                TBM_PA.text = [NSString stringWithFormat:@"%d / %d", temp.PA, temp.PA_Max];
                TBM_PM.text = [NSString stringWithFormat:@"%d / %d", temp.PM, temp.PM_Max];
                TBM_coordonnees.text = [NSString stringWithFormat:@"[ %d ; %d ]", temp.Ligne, temp.Colonne];
                TBM_jauge.frame = CGRectMake(9, 124, 90 * temp.Vie / temp.Vie_Max, 15);
                //TYPE
                Monstre *ceMonstre = [Monstres objectAtIndex:cellule_temp.ID];
                if (ceMonstre.Appartenance == Tour_actuel.joueur)
                {
                    Tour_actuel.ID = cellule_temp.ID;
                    Tour_actuel.type = DEPLACER;
                    TBM_bouton_attaque.alpha = 1;
                    TBM_bouton_deplacement.alpha = 1;
                    TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer.png"];
                    TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer_on.png"];
                    if (ceMonstre.PM <= 0) {
                        Tour_actuel.type = ATTAQUER;
                        TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer.png"];
                        TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer_on.png"];
                        if (ceMonstre.PA <= 0) {
                            Tour_actuel.type = RIEN;
                            TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer.png"];
                        }
                    }
                }
                else
                {
                    TBM_bouton_attaque.alpha = 0;
                    TBM_bouton_deplacement.alpha = 0;
                }
            }
            else if (cellule_temp.etat == CHARGEUR)
            {
                [Tableau_de_bord addSubview:Chargeur_View];
                
                if (cellule_temp.ligne == 1)
                {
                    Joueur* player = [Joueurs objectAtIndex:2];
                    if (cellule_temp.colonne == 1)
                    {
                        CV_vie.text = [NSString stringWithFormat:@"%d %@", player.Chargeur_1 * 2, @"PV"];
                        CV_joueur.image = [UIImage imageNamed:@"J2.png"];
                        CV_jauge.frame = CGRectMake(9, 124, 90 * player.Chargeur_1 / 80, 15);
                        CV_gain.text = [NSString stringWithFormat:@"+ %.f %@", (round((84 - player.Chargeur_1) / 8) + 5), @"%"];
                        if (player.Chargeur_1 <= 0)
                        {
                            CV_gain.text = [NSString stringWithFormat:@"+ 0 %@", @"%"];
                        }
                    }
                    else if (cellule_temp.colonne == 7)
                    {
                        CV_vie.text = [NSString stringWithFormat:@"%d %@", player.Chargeur_2 * 2, @"PV"];
                        CV_joueur.image = [UIImage imageNamed:@"J2.png"];
                        CV_jauge.frame = CGRectMake(9, 124, 90 * player.Chargeur_2 / 80, 15);
                        CV_gain.text = [NSString stringWithFormat:@"+ %.f %@", (round((84 - player.Chargeur_2) / 8) + 5), @"%"];
                        if (player.Chargeur_2 <= 0)
                        {
                            CV_gain.text = [NSString stringWithFormat:@"+ 0 %@", @"%"];
                        }
                    }
                }
                else if (cellule_temp.ligne == 10)
                {
                    Joueur* player = [Joueurs objectAtIndex:1];
                    if (cellule_temp.colonne == 1)
                    {
                        CV_vie.text = [NSString stringWithFormat:@"%d %@", player.Chargeur_1 * 2, @"PV"];
                        CV_joueur.image = [UIImage imageNamed:@"J1.png"];
                        CV_jauge.frame = CGRectMake(9, 124, 90 * player.Chargeur_1 / 80, 15);
                        CV_gain.text = [NSString stringWithFormat:@"+ %.f %@", (round((84 - player.Chargeur_1) / 8) + 5), @"%"];
                        if (player.Chargeur_1 <= 0)
                        {
                            CV_gain.text = [NSString stringWithFormat:@"+ 0 %@", @"%"];
                        }
                    }
                    else if (cellule_temp.colonne == 7)
                    {
                        CV_vie.text = [NSString stringWithFormat:@"%d %@", player.Chargeur_2 * 2, @"PV"];
                        CV_joueur.image = [UIImage imageNamed:@"J1.png"];
                        CV_jauge.frame = CGRectMake(9, 124, 90 * player.Chargeur_2 / 80, 15);
                        CV_gain.text = [NSString stringWithFormat:@"+ %.f %@", (round((84 - player.Chargeur_2) / 8) + 5), @"%"];
                        if (player.Chargeur_2 <= 0)
                        {
                            CV_gain.text = [NSString stringWithFormat:@"+ 0 %@", @"%"];
                        }
                    }
                }
            }
            else
            {
                [self Annuler_Invoc:[NSNumber numberWithInt:7]];
                if (cellule_temp.couleur == BLEU)
                {
                    if (Tour_actuel.joueur == 1)
                    {    
                        Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
                        
                        if (player.nb_invoc > 0)
                        {
                            [Catalog_Monstres setContentSize:CGSizeMake(110, 50 * ([MonstresDeBase count] - 1))];
                            
                            int i = 1;
                            while (i < [MonstresDeBase count])
                            {
                                MonstreBase *temp = [MonstresDeBase objectAtIndex:i];
                                UIButton* noms_bouton = [[UIButton alloc] initWithFrame:CGRectMake(5, (i - 1) * 50 + 10, 100, 30)];
                                [noms_bouton setTitle:[NSString stringWithFormat:@"%@ (%d)", temp.Nom, [temp getPrix]] forState:UIControlStateNormal];
                                 noms_bouton.tag = i;
                                noms_bouton.backgroundColor = [UIColor blueColor];
                                [noms_bouton addTarget:self action:@selector(afficher_catalog:) forControlEvents:UIControlEventTouchUpInside];
                                noms_bouton.titleLabel.font = [UIFont fontWithName:@"" size:10];
                                [Catalog_Monstres addSubview:noms_bouton];
                                i++;
                            }
                            [Tableau_de_bord addSubview:Choix_Invoc];
                        }
                    }
                }
                else if (cellule_temp.couleur == ROUGE)
                {
                    if (Tour_actuel.joueur == 2)
                    {    
                        Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
                        
                        if (player.nb_invoc > 0)
                        {
                            [Catalog_Monstres setContentSize:CGSizeMake(110, 50 * ([MonstresDeBase count] - 1))];
                            
                            int i = 1;
                            while (i < [MonstresDeBase count]) {
                                MonstreBase *temp = [MonstresDeBase objectAtIndex:i];
                                UIButton* noms_bouton = [[UIButton alloc] initWithFrame:CGRectMake(5, (i - 1) * 50 + 10, 100, 30)];
                                [noms_bouton setTitle:[NSString stringWithFormat:@"%@ (%d)", temp.Nom, [temp getPrix]] forState:UIControlStateNormal];
                                noms_bouton.tag = i;
                                noms_bouton.backgroundColor = [UIColor blueColor];
                                [noms_bouton addTarget:self action:@selector(afficher_catalog:) forControlEvents:UIControlEventTouchUpInside];
                                noms_bouton.titleLabel.font = [UIFont fontWithName:@"" size:10];
                                [Catalog_Monstres addSubview:noms_bouton];
                                i++;
                            }
                            [Tableau_de_bord addSubview:Choix_Invoc];
                        }
                    }
                }
            }
        }
        else if(Tour_actuel.type == INVOQUER)
        {
            if (Tour_actuel.joueur == 1) {
                if (cellule_temp.couleur == BLEU)
                {
                    if (cellule_temp.etat == VIDE) {
                        [Monstres addObject:[[Monstre alloc] initWithJoueur:Tour_actuel.joueur andIDBase:Tour_actuel.ID avecListeDesMonstresDeBase:MonstresDeBase]];
                        Monstre *monstre_temp = [Monstres objectAtIndex:([Monstres count] - 1)];
                        monstre_temp.Ligne = ligne;
                        monstre_temp.Colonne = colonne;
                        [cellule_temp occuperAvecEtat:MONSTRE andID:([Monstres count] - 1)];
                        [[Joueurs objectAtIndex:Tour_actuel.joueur] perdreBatterie:[[MonstresDeBase objectAtIndex:Tour_actuel.ID] getPrix]];
                        Tour_actuel.type = RIEN;
                        Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
                        player.nb_invoc--;
                        [self actualiser_batterie];
                        
                        monstre_temp.image = [[UIImageView alloc] initWithFrame:CGRectMake((monstre_temp.Colonne - 1) * 30, (monstre_temp.Ligne - 1) * 36, 30, 30)];
                        monstre_temp.image.image = [UIImage imageNamed:[monstre_temp getImage]];
                        if (monstre_temp.Appartenance == 2)
                        {
                            [monstre_temp.image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                        }
                        [Plateau addSubview:monstre_temp.image];

                        monstre_temp.jauge = [[UIImageView alloc] initWithFrame:CGRectMake((monstre_temp.Colonne - 1) * 30 + 2, (monstre_temp.Ligne - 1) * 36 + 30, 26, 6)];
                        monstre_temp.jauge.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
                        [Plateau addSubview:monstre_temp.jauge];
                        
                        Cadre_nb_invoc.text = [NSString stringWithFormat:@"%d In.", player.nb_invoc];

                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez toucher une cellule VIDE pour invoquer un monstre."];
                    }
                }
                else
                {
                    [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez toucher une cellule BLEUE pour invoquer un monstre."];
                }
            }
            else
            {
                if (cellule_temp.couleur == ROUGE) {
                    if (cellule_temp.etat == VIDE) {
                        [Monstres addObject:[[Monstre alloc] initWithJoueur:Tour_actuel.joueur andIDBase:Tour_actuel.ID avecListeDesMonstresDeBase:MonstresDeBase]];
                        Monstre *monstre_temp = [Monstres objectAtIndex:([Monstres count] - 1)];
                        monstre_temp.Ligne = ligne;
                        monstre_temp.Colonne = colonne;
                        [cellule_temp occuperAvecEtat:MONSTRE andID:([Monstres count] - 1)];
                        [[Joueurs objectAtIndex:Tour_actuel.joueur] perdreBatterie:[[MonstresDeBase objectAtIndex:Tour_actuel.ID] getPrix]];
                        Tour_actuel.type = RIEN;
                        Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
                        player.nb_invoc--;
                        [self actualiser_batterie];
                        
                        monstre_temp.image = [[UIImageView alloc] initWithFrame:CGRectMake((monstre_temp.Colonne - 1) * 30, (monstre_temp.Ligne - 1) * 36, 30, 30)];
                        monstre_temp.image.image = [UIImage imageNamed:[monstre_temp getImage]];
                        if (monstre_temp.Appartenance == 2)
                        {
                            [monstre_temp.image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                        }
                        [Plateau addSubview:monstre_temp.image];
                        
                        monstre_temp.jauge = [[UIImageView alloc] initWithFrame:CGRectMake((monstre_temp.Colonne - 1) * 30 + 2, (monstre_temp.Ligne - 1) * 36 + 30, 26, 6)];
                        monstre_temp.jauge.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
                        [Plateau addSubview:monstre_temp.jauge];
                        
                        Cadre_nb_invoc.text = [NSString stringWithFormat:@"%d In.", player.nb_invoc];
                        
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez toucher une cellule VIDE pour invoquer un monstre."];
                    }                
                }
                else
                {
                    [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez toucher une cellule ROUGE pour invoquer un monstre."];
                }
            }
        }
        else if (Tour_actuel.type == DEPLACER)
        {
            if (cellule_temp.etat == MONSTRE)
            {
                if (cellule_temp.ID == Tour_actuel.ID)
                {
                    Tour_actuel.type = ATTAQUER;
                    TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer_on.png"];
                    TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer.png"];
                    Monstre *ceMonstre = [Monstres objectAtIndex:cellule_temp.ID];
                    if (ceMonstre.PA <= 0)
                    {
                        Tour_actuel.type = DEPLACER;
                        TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer_on.png"];
                        TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer.png"];
                        if (ceMonstre.PM <= 0)
                        {
                            Tour_actuel.type = RIEN;
                            TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer.png"];
                        }
                    }
                }
                else
                {
                    Tour_actuel.type = RIEN;
                    [self toucher_caseLigne:ligne andColonne:colonne];
                }
            }
            else if (cellule_temp.etat == VIDE)
            {
                Monstre *ceMonstre = [Monstres objectAtIndex:Tour_actuel.ID];
                if (abs(ligne - ceMonstre.Ligne) + abs(colonne - ceMonstre.Colonne) == 1)
                {

                    //DÉPLACEMENT
                    
                    [[[Cellules objectAtIndex:ceMonstre.Ligne] objectAtIndex:ceMonstre.Colonne] vider];
                    int ancienne_ligne = ceMonstre.Ligne + 1;
                    int ancienne_colonne = ceMonstre.Colonne + 1;
                    ceMonstre.Ligne = ligne;
                    ceMonstre.Colonne = colonne;
                    [cellule_temp occuperAvecEtat:MONSTRE andID:Tour_actuel.ID];
                    [ceMonstre Deplacer];
                    Tour_actuel.type = RIEN;
                                        
                    CGPoint depart_ = CGPointMake((ancienne_colonne - 2) * 30, (ancienne_ligne - 2) * 36);
                    CGPoint arrivee_ = CGPointMake((ceMonstre.Colonne - 1) * 30, (ceMonstre.Ligne - 1) * 36);
                    [self deplacerMonstre:ceMonstre from:depart_ to:arrivee_];
                }
                else
                {
                    Tour_actuel.type = RIEN;
                    [self toucher_caseLigne:ligne andColonne:colonne];
                }
            }
            else if (cellule_temp.etat == GLACE)
            {
                Monstre *ceMonstre = [Monstres objectAtIndex:Tour_actuel.ID];
                if (abs(ligne - ceMonstre.Ligne) + abs(colonne - ceMonstre.Colonne) == 1)
                {
                    
                    //DÉPLACEMENT
                    int continuer = 1;
                    int tour = 2;
                    int deplacer = 0;
                    CGPoint arrivee;
                    while (continuer)
                    {
                        continuer = 0;
                        CGPoint vecteur = CGPointMake(ligne - ceMonstre.Ligne, colonne - ceMonstre.Colonne);
                        arrivee = CGPointMake(ceMonstre.Ligne + tour * vecteur.x, ceMonstre.Colonne + tour * vecteur.y);
                        
                        if (arrivee.x >= 1)
                        {
                            if (arrivee.x <= 10) {
                                if (arrivee.y >= 1) {
                                    if (arrivee.y <= 7)
                                    {
                                        Cellule *actu = [[Cellules objectAtIndex:arrivee.x] objectAtIndex:arrivee.y];
                                        if ([actu estVide])
                                        {
                                            if (actu.etat == VIDE)
                                            {
                                                deplacer = 1;
                                            }
                                            else
                                            {
                                                tour++;
                                                continuer = 1;
                                            }
                                        }
                                        else
                                        {
                                            deplacer = 0;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if (deplacer == 1)
                    {
                        [[[Cellules objectAtIndex:ceMonstre.Ligne] objectAtIndex:ceMonstre.Colonne] vider];
                        int ancienne_ligne = ceMonstre.Ligne + 1;
                        int ancienne_colonne = ceMonstre.Colonne + 1;
                        ceMonstre.Ligne = arrivee.x;
                        ceMonstre.Colonne = arrivee.y;
                        [[[Cellules objectAtIndex:arrivee.x] objectAtIndex:arrivee.y] occuperAvecEtat:MONSTRE andID:Tour_actuel.ID];
                        [ceMonstre Deplacer];
                        Tour_actuel.type = RIEN;
                        
                        CGPoint depart_ = CGPointMake((ancienne_colonne - 2) * 30, (ancienne_ligne - 2) * 36);
                        CGPoint arrivee_ = CGPointMake((ceMonstre.Colonne - 1) * 30, (ceMonstre.Ligne - 1) * 36);
                        [self deplacerMonstre:ceMonstre from:depart_ to:arrivee_];
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous ne pouvez pas glisser car la cellule d'arrivée n'est pas VIDE."];
                    }
                }
                else
                {
                    Tour_actuel.type = RIEN;
                    [self toucher_caseLigne:ligne andColonne:colonne];
                }
            }
            else
            {
                Tour_actuel.type = RIEN;
                [self toucher_caseLigne:ligne andColonne:colonne];
            }
        }
        else if (Tour_actuel.type == ATTAQUER)
        {
            if (cellule_temp.etat == MONSTRE)
            {
                if (cellule_temp.ID == Tour_actuel.ID)
                {                    
                    Tour_actuel.type = DEPLACER;
                    TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer.png"];
                    TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer_on.png"];
                    Monstre *ceMonstre = [Monstres objectAtIndex:cellule_temp.ID];
                    if (ceMonstre.PM <= 0)
                    {
                        Tour_actuel.type = ATTAQUER;
                        TBM_bouton_deplacement.image = [UIImage imageNamed:@"deplacer.png"];
                        TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer_on.png"];
                        if (ceMonstre.PA <= 0)
                        {
                            Tour_actuel.type = RIEN;
                            TBM_bouton_attaque.image = [UIImage imageNamed:@"attaquer.png"];
                        }
                    }
                }
                else
                {
                    Monstre *Attaquant = [Monstres objectAtIndex:Tour_actuel.ID];
                    Monstre *Victime = [Monstres objectAtIndex:cellule_temp.ID];
                    int test_jauge = 1;
                    
                    if (Attaquant.Spe == CORPS_A_CORPS)
                    {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            valide = 1;
                        }
                        else if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 2)
                        {
                            if ((Attaquant.Ligne + 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Ligne - 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne + 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne - 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else
                            {
                                if ((Attaquant.Ligne + 2) == Victime.Ligne) {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne + 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Ligne - 2) == Victime.Ligne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne - 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne - 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne - 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne + 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                            }
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2 / valide;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer] / valide;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == SOIGNEUR)
                    {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            valide = 1;
                        }
                        else if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 2)
                        {
                            if ((Attaquant.Ligne + 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Ligne - 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne + 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne - 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else
                            {
                                if ((Attaquant.Ligne + 2) == Victime.Ligne) {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne + 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Ligne - 2) == Victime.Ligne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne - 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne - 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne - 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne + 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                            }
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2 * (-1);
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ gagne %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, -attaque]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer] * (-1);
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ gagne %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, (-1) * attaque]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == MECANO)
                    {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            valide = 1;
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer];
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == BERSERKER)
                    {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            valide = 1;
                        }
                        else if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 2)
                        {
                            if ((Attaquant.Ligne + 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Ligne - 1) == Victime.Ligne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne + 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne - 1) == Victime.Colonne)
                            {
                                valide = 2;
                            }
                            else
                            {
                                if ((Attaquant.Ligne + 2) == Victime.Ligne) {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne + 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Ligne - 2) == Victime.Ligne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne - 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne - 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne - 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne + 2) == Victime.Colonne)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                            }
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2 / valide;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer] / valide;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == DISTANCE)
                    {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        else if (Attaquant.Ligne == Victime.Ligne)
                        {  
                            if (Attaquant.Colonne > Victime.Colonne)
                            {
                                int i = 1;
                                int valider = 1;
                                while (i < Attaquant.Colonne - Victime.Colonne)
                                {
                                    if (![[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Victime.Colonne + i] estVide]) {
                                        valider = 0;
                                    }
                                    i++;
                                }
                                if (valider) {
                                    valide = 1;
                                }
                            }
                            else if (Attaquant.Colonne < Victime.Colonne)
                            {
                                int i = 1;
                                int valider = 1;
                                while (i < Victime.Colonne - Attaquant.Colonne)
                                {
                                    if (![[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + i] estVide]) {
                                        valider = 0;
                                    }
                                    i++;
                                }
                                if (valider)
                                {
                                    valide = 1;
                                }
                            }
                        }
                        else if (Attaquant.Colonne == Victime.Colonne)
                        {
                            if (Attaquant.Ligne > Victime.Ligne)
                            {
                                int i = 1;
                                int valider = 1;
                                while (i < Attaquant.Ligne - Victime.Ligne)
                                {
                                    if (![[[Cellules objectAtIndex:Victime.Ligne + i] objectAtIndex:Victime.Colonne] estVide]) {
                                        valider = 0;
                                    }
                                    i++;
                                }
                                if (valider) {
                                    valide = 1;
                                }
                            }
                            else if (Attaquant.Ligne < Victime.Ligne)
                            {
                                int i = 1;
                                int valider = 1;
                                while (i < Victime.Ligne - Attaquant.Ligne)
                                {
                                    if (![[[Cellules objectAtIndex:Attaquant.Ligne + i] objectAtIndex:Attaquant.Colonne] estVide]) {
                                        valider = 0;
                                    }
                                    i++;
                                }
                                if (valider)
                                {
                                    valide = 1;
                                }
                            }
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2;
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer];
                                [Victime SubirDegats:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque %@ !\n%@ perd %d PV", Attaquant.Nom, Victime.Nom, Victime.Nom, attaque]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == POUSSEUR)
                    {
                        test_jauge = 0;
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.Ligne) + abs(Attaquant.Colonne - Victime.Colonne) == 1)
                        {
                            valide = 1;
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (Victime.ID_Base == 3)
                        {
                            valide = 0;
                            [self AlerteWithTitre:@"Erreur" andTexte:@"Ce monstre est trop lourd pour être déplacé..."];
                        }
                        if (valide)
                        {
                            //DÉPLACEMENT
                            int continuer = 1;
                            int tour = 1;
                            int deplacer = 0;
                            CGPoint arrivee;
                            while (continuer)
                            {
                                continuer = 0;
                                CGPoint vecteur = CGPointMake(Victime.Ligne - Attaquant.Ligne, Victime.Colonne - Attaquant.Colonne);
                                arrivee = CGPointMake(Victime.Ligne + tour * vecteur.x, Victime.Colonne + tour * vecteur.y);
                                
                                if (arrivee.x >= 1)
                                {
                                    if (arrivee.x <= 10) {
                                        if (arrivee.y >= 1) {
                                            if (arrivee.y <= 7)
                                            {
                                                Cellule *actu = [[Cellules objectAtIndex:arrivee.x] objectAtIndex:arrivee.y];
                                                if ([actu estVide])
                                                {
                                                    if (actu.etat == VIDE)
                                                    {
                                                        deplacer = 1;
                                                    }
                                                    else
                                                    {
                                                        tour++;
                                                        continuer = 1;
                                                    }
                                                }
                                                else
                                                {
                                                    deplacer = 0;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if (deplacer == 1)
                            {
                                [Attaquant Attaquer];
                                
                                
                                int ancienne_ligne = Victime.Ligne + 1;
                                int ancienne_colonne = Victime.Colonne + 1;
                                [[[Cellules objectAtIndex:arrivee.x] objectAtIndex:arrivee.y] occuperAvecEtat:MONSTRE andID:cellule_temp.ID];
                                [[[Cellules objectAtIndex:Victime.Ligne] objectAtIndex:Victime.Colonne] vider];
                                Victime.Ligne = arrivee.x; 
                                Victime.Colonne = arrivee.y;
                                Tour_actuel.type = RIEN;
                                
                                CGPoint depart_ = CGPointMake((ancienne_colonne - 2) * 30, (ancienne_ligne - 2) * 36);
                                CGPoint arrivee_ = CGPointMake((Victime.Colonne - 1) * 30, (Victime.Ligne - 1) * 36);
                                [self deplacerMonstre:Victime from:depart_ to:arrivee_];
                            }
                            else
                            {
                                [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous ne pouvez pas pousser ce monstre car la cellule d'arrivée n'est pas VIDE."];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                        }
                    }
                    else if (Attaquant.Spe == TELEPORTEUR)
                    {
                        test_jauge = 0;
                        int valide = 0;
                        if (cellule_temp.couleur == TRANSPARENT)
                        {
                            valide = 1;
                        }
                        if (Victime.ID_Base == 3)
                        {
                            valide = 0;
                            [self AlerteWithTitre:@"Erreur" andTexte:@"Ce monstre est trop lourd pour être déplacé..."];
                        }
                        if (valide)
                        {
                            [Attaquant Attaquer];
                            // ATTAQUANT <=> VICTIME
                            
                            CGPoint depart_TP = CGPointMake(Attaquant.Ligne, Attaquant.Colonne);
                            CGPoint arrivee_TP = CGPointMake(Victime.Ligne, Victime.Colonne);
                            
                            [[[Cellules objectAtIndex:depart_TP.x] objectAtIndex:depart_TP.y] occuperAvecEtat:MONSTRE andID:cellule_temp.ID];
                            Victime.Ligne = depart_TP.x;
                            Victime.Colonne = depart_TP.y;
                            [[[Cellules objectAtIndex:arrivee_TP.x] objectAtIndex:arrivee_TP.y] occuperAvecEtat:MONSTRE andID:Tour_actuel.ID];
                            Attaquant.Ligne = arrivee_TP.x;
                            Attaquant.Colonne = arrivee_TP.y;
                            
                            [Attaquant.image removeFromSuperview];
                            [Victime.image removeFromSuperview];
                            [Attaquant.jauge removeFromSuperview];
                            [Victime.jauge removeFromSuperview];
                            
                            Victime.image = [[UIImageView alloc] initWithFrame:CGRectMake((Victime.Colonne - 1) * 30, (Victime.Ligne - 1) * 36, 30, 30)];
                            Victime.image.image = [UIImage imageNamed:[Victime getImage]];
                            if (Victime.Appartenance == 2)
                            {
                                [Victime.image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                            }
                            [Plateau addSubview:Victime.image];
                            Victime.jauge = [[UIImageView alloc] initWithFrame:CGRectMake((Victime.Colonne - 1) * 30 + 2, (Victime.Ligne - 1) * 36 + 30, 26 * Victime.Vie / Victime.Vie_Max, 6)];
                            Victime.jauge.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
                            [Plateau addSubview:Victime.jauge];
                            
                            Attaquant.image = [[UIImageView alloc] initWithFrame:CGRectMake((Attaquant.Colonne - 1) * 30, (Attaquant.Ligne - 1) * 36, 30, 30)];
                            Attaquant.image.image = [UIImage imageNamed:[Attaquant getImage]];
                            if (Attaquant.Appartenance == 2)
                            {
                                [Attaquant.image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                            }
                            [Plateau addSubview:Attaquant.image];
                            Attaquant.jauge = [[UIImageView alloc] initWithFrame:CGRectMake((Attaquant.Colonne - 1) * 30 + 2, (Attaquant.Ligne - 1) * 36 + 30, 26 * Attaquant.Vie / Attaquant.Vie_Max, 6)];
                            Attaquant.jauge.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
                            [Plateau addSubview:Attaquant.jauge];
                        }
                    }
                    
                    if (test_jauge)
                    {
                        //ATTAQUE mais test d'abord !                    
                        [Victime.jauge removeFromSuperview];
                        Victime.jauge = [[UIImageView alloc] initWithFrame:CGRectMake((Victime.Colonne - 1) * 30 + 2, (Victime.Ligne - 1) * 36 + 30, 26 * Victime.Vie / Victime.Vie_Max, 6)];
                        Victime.jauge.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
                        [Plateau addSubview:Victime.jauge];
                        
                        if (Victime.Mort == 1)
                        {
                            [self AlerteWithTitre:@"Rubrique nécrologique" andTexte:[NSString stringWithFormat:@"%@ est mort tragiquement...", Victime.Nom]];
                            [Victime.jauge removeFromSuperview];
                            [Victime.image removeFromSuperview];
                            [Victime.vie_sur_jauge removeFromSuperview];
                            [[[Cellules objectAtIndex:Victime.Ligne] objectAtIndex:Victime.Colonne] vider];
                        }
                    }
                    
                    Tour_actuel.type = RIEN;
                    [self toucher_caseLigne:Attaquant.Ligne andColonne:Attaquant.Colonne];
                }
            }
            else if (cellule_temp.etat == CHARGEUR)
            {
                Monstre *Attaquant = [Monstres objectAtIndex:Tour_actuel.ID];                
                CGPoint Victime = CGPointMake(cellule_temp.ligne, cellule_temp.colonne);
                int vie_chargeur;
                int ID_chargeur = 3;          
                Joueur *player;
                if (cellule_temp.ligne == 1)
                {
                    player = [Joueurs objectAtIndex:2];
                    if (cellule_temp.colonne == 1)
                    {
                        vie_chargeur = player.Chargeur_1;
                        ID_chargeur = 1;
                    }
                    else if (cellule_temp.colonne == 7)
                    {
                        vie_chargeur = player.Chargeur_2;
                        ID_chargeur = 2;
                    }
                }
                else if (cellule_temp.ligne == 10)
                {
                    player = [Joueurs objectAtIndex:1];
                    if (cellule_temp.colonne == 1)
                    {
                        vie_chargeur = player.Chargeur_1;
                        ID_chargeur = 1;
                    }
                    else if (cellule_temp.colonne == 7)
                    {
                        vie_chargeur = player.Chargeur_2;
                        ID_chargeur = 2;
                    }
                }
                
                if (Attaquant.Spe == CORPS_A_CORPS)
                {
                        int valide = 0;
                        //Test ligne de vue
                        if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 1)
                        {
                            valide = 1;
                        }
                        else if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 2)
                        {
                            if ((Attaquant.Ligne + 1) == Victime.x)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Ligne - 1) == Victime.x)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne + 1) == Victime.y)
                            {
                                valide = 2;
                            }
                            else if ((Attaquant.Colonne - 1) == Victime.y)
                            {
                                valide = 2;
                            }
                            else
                            {
                                if ((Attaquant.Ligne + 2) == Victime.x) {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne + 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Ligne - 2) == Victime.x)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne - 1] objectAtIndex:Attaquant.Colonne] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne - 2) == Victime.y)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne - 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                                else if ((Attaquant.Colonne + 2) == Victime.y)
                                {
                                    if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + 1] estVide])
                                    {
                                        valide = 2;
                                    }
                                }
                            }
                        }
                        else
                        {
                            Tour_actuel.type = RIEN;
                            [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                        }
                        if (valide)
                        {
                            int echec = arc4random() % 20;
                            int CC = arc4random() % 20;
                            if (echec == 15)
                            {
                                [Attaquant Attaquer];
                                [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                            }
                            else if (CC == 7)
                            {
                                int attaque = [Attaquant Attaquer] * 2 / valide / 2;
                                [player attaqueChargeur:ID_chargeur andValeur:attaque];
                                [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                            }
                            else
                            {
                                int attaque = [Attaquant Attaquer] / valide / 2;
                                [player attaqueChargeur:ID_chargeur andValeur:attaque];
                                [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                            }
                        }
                        else
                        {
                            [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce chargeur n'est pas dans votre ligne de vue."];
                        }
                    }
                else if (Attaquant.Spe == MECANO)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 1)
                    {
                        valide = 1;
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            int attaque = [Attaquant Attaquer] * 2 / valide * 10;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] / valide * 10;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                    }
                }
                else if (Attaquant.Spe == BERSERKER)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 1)
                    {
                        valide = 1;
                    }
                    else if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 2)
                    {
                        if ((Attaquant.Ligne + 1) == Victime.x)
                        {
                            valide = 2;
                        }
                        else if ((Attaquant.Ligne - 1) == Victime.x)
                        {
                            valide = 2;
                        }
                        else if ((Attaquant.Colonne + 1) == Victime.y)
                        {
                            valide = 2;
                        }
                        else if ((Attaquant.Colonne - 1) == Victime.y)
                        {
                            valide = 2;
                        }
                        else
                        {
                            if ((Attaquant.Ligne + 2) == Victime.x) {
                                if ([[[Cellules objectAtIndex:Attaquant.Ligne + 1] objectAtIndex:Attaquant.Colonne] estVide])
                                {
                                    valide = 2;
                                }
                            }
                            else if ((Attaquant.Ligne - 2) == Victime.x)
                            {
                                if ([[[Cellules objectAtIndex:Attaquant.Ligne - 1] objectAtIndex:Attaquant.Colonne] estVide])
                                {
                                    valide = 2;
                                }
                            }
                            else if ((Attaquant.Colonne - 2) == Victime.y)
                            {
                                if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne - 1] estVide])
                                {
                                    valide = 2;
                                }
                            }
                            else if ((Attaquant.Colonne + 2) == Victime.y)
                            {
                                if ([[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + 1] estVide])
                                {
                                    valide = 2;
                                }
                            }
                        }
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            int attaque = [Attaquant Attaquer] * 2 / valide / 2;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] / valide / 2;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                    }
                }
                else if (Attaquant.Spe == DISTANCE)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if (abs(Attaquant.Ligne - Victime.x) + abs(Attaquant.Colonne - Victime.y) == 1)
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    else if (Attaquant.Ligne == Victime.x)
                    {  
                        if (Attaquant.Colonne > Victime.y)
                        {
                            int i = 1;
                            int valider = 1;
                            while (i < Attaquant.Colonne - Victime.y)
                            {
                                if (![[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Victime.y + i] estVide]) {
                                    valider = 0;
                                }
                                i++;
                            }
                            if (valider) {
                                valide = 1;
                                }
                        }
                        else if (Attaquant.Colonne < Victime.y)
                        {
                            int i = 1;
                            int valider = 1;
                            while (i < Victime.y - Attaquant.Colonne)
                            {
                                if (![[[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne + i] estVide]) {
                                    valider = 0;
                                }
                                i++;
                            }
                            if (valider)
                            {
                                valide = 1;
                            }
                        }
                    }
                    else if (Attaquant.Colonne == Victime.y)
                    {
                        if (Attaquant.Ligne > Victime.x)
                        {
                            int i = 1;
                            int valider = 1;
                            while (i < Attaquant.Ligne - Victime.x)
                            {
                                if (![[[Cellules objectAtIndex:Victime.x + i] objectAtIndex:Victime.y] estVide]) {
                                    valider = 0;
                                }
                                i++;
                            }
                            if (valider) {
                                valide = 1;
                            }
                        }
                        else if (Attaquant.Ligne < Victime.x)
                        {
                            int i = 1;
                            int valider = 1;
                            while (i < Victime.x - Attaquant.Ligne)
                            {
                                if (![[[Cellules objectAtIndex:Attaquant.Ligne + i] objectAtIndex:Attaquant.Colonne] estVide]) {
                                    valider = 0;
                                }
                                i++;
                            }
                            if (valider)
                            {
                                valide = 1;
                            }
                        }
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            int attaque = [Attaquant Attaquer] * 2 / 2;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] / 2;
                            [player attaqueChargeur:ID_chargeur andValeur:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque le chargeur %d de J%d !\nCe chargeur perd %d %@", Attaquant.Nom, ID_chargeur, player.ID, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Ce monstre n'est pas dans votre ligne de vue."];
                    }
                }
                
                player = [Joueurs objectAtIndex:2];
                
                UIImageView *Jauge_chargeur_1_1 = [[Jauge_chargeurs objectAtIndex:1] objectAtIndex:1];
                [Jauge_chargeur_1_1 removeFromSuperview];
                Jauge_chargeur_1_1.frame = CGRectMake(2, 30, 26 * player.Chargeur_1 / 80, 6);
                [Plateau addSubview:Jauge_chargeur_1_1];
                
                UIImageView *Jauge_chargeur_1_7 = [[Jauge_chargeurs objectAtIndex:1] objectAtIndex:2];
                [Jauge_chargeur_1_7 removeFromSuperview];
                Jauge_chargeur_1_7.frame = CGRectMake(182, 30, 26 * player.Chargeur_2 / 80, 6);
                [Plateau addSubview:Jauge_chargeur_1_7];
                
                player = [Joueurs objectAtIndex:1];
                
                UIImageView *Jauge_chargeur_10_1 = [[Jauge_chargeurs objectAtIndex:2] objectAtIndex:1];
                [Jauge_chargeur_10_1 removeFromSuperview];
                Jauge_chargeur_10_1.frame = CGRectMake(2, 354, 26 * player.Chargeur_1 / 80, 6);
                [Plateau addSubview:Jauge_chargeur_10_1];
                
                UIImageView *Jauge_chargeur_10_7 = [[Jauge_chargeurs objectAtIndex:2] objectAtIndex:2];
                [Jauge_chargeur_10_7 removeFromSuperview];
                Jauge_chargeur_10_7.frame = CGRectMake(182, 354, 26 * player.Chargeur_2 / 80, 6);
                [Plateau addSubview:Jauge_chargeur_10_7];
                
                Tour_actuel.type = RIEN;
                [self toucher_caseLigne:Attaquant.Ligne andColonne:Attaquant.Colonne];
            }
            else if (cellule_temp.etat == GENERATEUR)
            {
                Monstre *Attaquant = [Monstres objectAtIndex:Tour_actuel.ID];
                Cellule *position_attaquant = [[Cellules objectAtIndex:Attaquant.Ligne] objectAtIndex:Attaquant.Colonne];
                CGPoint batterie = CGPointMake(cellule_temp.ligne, cellule_temp.colonne);
                if (Attaquant.Spe == CORPS_A_CORPS)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if ((position_attaquant.couleur == ROUGE) || (position_attaquant.couleur == BLEU))
                    {
                        valide = 1;
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        Joueur *J_victime = [Joueurs objectAtIndex:1];
                        if (position_attaquant.couleur == ROUGE)
                        {
                             J_victime = [Joueurs objectAtIndex:2];

                        }
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            
                            int attaque = [Attaquant Attaquer] * 2 / 2;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] / 2;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez être sur une case colorée pour attaquer une batterie."];
                    }
                }
                else if (Attaquant.Spe == MECANO)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if (abs(Attaquant.Ligne - batterie.x) + abs(Attaquant.Colonne - batterie.y) == 1)
                    {
                        valide = 1;
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        Joueur *J_victime = [Joueurs objectAtIndex:1];
                        if (position_attaquant.couleur == ROUGE)
                        {
                            J_victime = [Joueurs objectAtIndex:2];
                            
                        }
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            
                            int attaque = [Attaquant Attaquer] * 2 * 10;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] * 10;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez être sur une case colorée pour attaquer une batterie."];
                    }                    
                }
                else if (Attaquant.Spe == BERSERKER)
                {
                    int valide = 0;
                    //Test ligne de vue
                    if ((position_attaquant.couleur == ROUGE) || (position_attaquant.couleur == BLEU))
                    {
                        valide = 1;
                    }
                    else
                    {
                        Tour_actuel.type = RIEN;
                        [self toucher_caseLigne:cellule_temp.ligne andColonne:cellule_temp.colonne];
                    }
                    if (valide)
                    {
                        Joueur *J_victime = [Joueurs objectAtIndex:1];
                        if (position_attaquant.couleur == ROUGE)
                        {
                            J_victime = [Joueurs objectAtIndex:2];
                            
                        }
                        int echec = arc4random() % 20;
                        int CC = arc4random() % 20;
                        if (echec == 15)
                        {
                            [Attaquant Attaquer];
                            [self AlerteWithTitre:@"Échec critique !" andTexte:@"L'attaque a échoué !"];
                        }
                        else if (CC == 7)
                        {
                            
                            int attaque = [Attaquant Attaquer] * 2 / 2;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Coup critique !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                        else
                        {
                            int attaque = [Attaquant Attaquer] / 2;
                            [J_victime perdreBatterie:attaque];
                            [self AlerteWithTitre:@"Attaque !" andTexte:[NSString stringWithFormat:@"%@ attaque la batterie de %@ !\nLa batterie de %@ perd %d %@", Attaquant.Nom, J_victime.Nom, J_victime.Nom, attaque, @"%"]];
                        }
                    }
                    else
                    {
                        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous devez être sur une case colorée pour attaquer une batterie."];
                    }
                }
                [self actualiser_batterie];
                Tour_actuel.type = RIEN;
                [self toucher_caseLigne:Attaquant.Ligne andColonne:Attaquant.Colonne];
            }
            else
            {
                Tour_actuel.type = RIEN;
                [self toucher_caseLigne:ligne andColonne:colonne];
            }
        }
    }
    if (Tour_actuel.type == DEPLACER)
    {
        Monstre *ceMonstre = [Monstres objectAtIndex:Tour_actuel.ID];
        [self PO_deplacementLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
    }
    else if (Tour_actuel.type == ATTAQUER)
    {
        Monstre *ceMonstre = [Monstres objectAtIndex:Tour_actuel.ID];
        if ((ceMonstre.Spe == MECANO) || (ceMonstre.Spe == POUSSEUR))
        {
            [self PO_attaqueCacLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
        }
        else if (ceMonstre.Spe == DISTANCE)
        {
            [self PO_attaqueCroixLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
        }
        else if (ceMonstre.Spe == SOIGNEUR)
        {
            [self PO_attaqueSoigneurLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
        }
        else if (ceMonstre.Spe == TELEPORTEUR)
        {
            [self PO_Telep:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
        }
        else
        {
            [self PO_attaqueLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
        }
    }
    else
    {
        [self resetColors];
    }
}

- (void)deplacerMonstre:(Monstre*)monster from:(CGPoint)depart to:(CGPoint)arrivee
{ 
    [Tour_actuel pauseDe:0.5];
    int i = 0;
    while (i < 10)
    {
        i++;
        [NSTimer scheduledTimerWithTimeInterval:(0.05 * i) target:self selector:@selector(bougerMonstre:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:monster, @"Monstre", [NSValue valueWithCGPoint:depart], @"Depart", [NSValue valueWithCGPoint:arrivee], @"Arrivee", [NSNumber numberWithInt:i], @"i", nil] repeats:NO];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(toucherCaseActuelle) userInfo:nil repeats:NO];
}

- (void)toucherCaseActuelle
{
    Monstre* ceMonstre = [Monstres objectAtIndex:Tour_actuel.ID];
    [self toucher_caseLigne:ceMonstre.Ligne andColonne:ceMonstre.Colonne];
}

- (void)bougerMonstre:(NSTimer*)theTimer
{
    Monstre *monster = [[theTimer userInfo] objectForKey:@"Monstre"];
    NSValue *depart_ = [[theTimer userInfo] objectForKey:@"Depart"];
    NSValue *arrivee_ = [[theTimer userInfo] objectForKey:@"Arrivee"];
    NSNumber *i_ = [[theTimer userInfo] objectForKey:@"i"];
    int i = [i_ intValue];
    CGPoint depart = [depart_ CGPointValue];
    CGPoint arrivee = [arrivee_ CGPointValue];
    CGPoint vecteur_ = CGPointMake(arrivee.x - depart.x, arrivee.y - depart.y);

    monster.image.center = CGPointMake(depart.x + vecteur_.x * i / 10 + 15, depart.y + vecteur_.y * i / 10 + 15);
    monster.jauge.frame = CGRectMake(depart.x + vecteur_.x * i / 10 + 2, depart.y + vecteur_.y * i / 10 + 30, monster.jauge.frame.size.width, monster.jauge.frame.size.height);
}

- (void)actualiser
{
    [self resetColors];
    int i = 0;
    while (i < 10) {
        i++;
        int j = 0;
        while (j < 7)
        {
            j++;
            Cellule *temp_cellule = [[Cellules objectAtIndex:i] objectAtIndex:j];
            if (temp_cellule.etat == ROCHER)
            {
                UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 36)];
                image.image = [UIImage imageNamed:@"rocher.png"];
                [Plateau addSubview:image];
            }
            else if (temp_cellule.etat == GLACE)
            {
                UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 36)];
                image.image = [UIImage imageNamed:@"glace.png"];
                [Plateau addSubview:image];
            }
            else if (temp_cellule.etat == CHARGEUR)
            {
                UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 30)];
                image.image = [UIImage imageNamed:@"Chargeur.png"];
                if (i == 1)
                {
                    [image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                }
                [Plateau addSubview:image];
            }
            else if (temp_cellule.etat == GENERATEUR)
            {
                UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 36)];
                image.image = [UIImage imageNamed:@"Generateur.png"];
                if (i == 1)
                {
                    [image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                }
                [Plateau addSubview:image];
            }
            else if (temp_cellule.etat == MONSTRE)
            {
                Monstre *ceMonstre = [Monstres objectAtIndex:temp_cellule.ID];
                [ceMonstre.image removeFromSuperview];
                ceMonstre.image = [[UIImageView alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 30)];
                ceMonstre.image.image = [UIImage imageNamed:[ceMonstre getImage]];
                if (ceMonstre.Appartenance == 2)
                {
                    [ceMonstre.image setTransform:CGAffineTransformMakeRotation(3.14159265)];
                }
                [Plateau addSubview:ceMonstre.image];
            }
        }
    }
    
    [Chargeur_View removeFromSuperview];
    [Choix_Invoc removeFromSuperview];
    [Monstre_Invoc removeFromSuperview];
    [Monstre_View removeFromSuperview];
    
    if (Tour_actuel.joueur == 1) {
        PlayerColor.backgroundColor = [UIColor blueColor];
    }
    else
    {
        PlayerColor.backgroundColor = [UIColor redColor];
    }
    Jx.text = [NSString stringWithFormat:@"J%d", Tour_actuel.joueur];
    Cadre_Num_Tour.text = [NSString stringWithFormat:@"Tour %d", Tour_actuel.num];
    Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
    Cadre_nb_invoc.text = [NSString stringWithFormat:@"%d In.", player.nb_invoc];
    Cadre_Batterie.text = [NSString stringWithFormat:@"%d %@", player.Batterie, @"%"];
    
    
    //Jauges des chargeurs
    Jauge_chargeurs = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:7], [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:7], [[UIImageView alloc] initWithFrame:CGRectMake(2, 30, 26, 6)], [[UIImageView alloc] initWithFrame:CGRectMake(182, 30, 26, 6)], nil], [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:7], [[UIImageView alloc] initWithFrame:CGRectMake(2, 354, 26, 6)], [[UIImageView alloc] initWithFrame:CGRectMake(182, 354, 26, 6)], nil], nil];
    
    UIImageView *Jauge_chargeur_1_1 = [[Jauge_chargeurs objectAtIndex:1] objectAtIndex:1];
    Jauge_chargeur_1_1.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
    [Plateau addSubview:Jauge_chargeur_1_1];
    
    UIImageView *Jauge_chargeur_1_7 = [[Jauge_chargeurs objectAtIndex:1] objectAtIndex:2];
    Jauge_chargeur_1_7.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
    [Plateau addSubview:Jauge_chargeur_1_7];

    UIImageView *Jauge_chargeur_10_1 = [[Jauge_chargeurs objectAtIndex:2] objectAtIndex:1];
    Jauge_chargeur_10_1.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
    [Plateau addSubview:Jauge_chargeur_10_1];

    UIImageView *Jauge_chargeur_10_7 = [[Jauge_chargeurs objectAtIndex:2] objectAtIndex:2];
    Jauge_chargeur_10_7.image = [UIImage imageNamed:@"jauge_de_vie_tableau.png"];
    [Plateau addSubview:Jauge_chargeur_10_7];
}

- (void)actualiser_batterie
{
    Joueur *J1 = [Joueurs objectAtIndex:1];
    Joueur *J2 = [Joueurs objectAtIndex:2];
    J1_batterie.text = [NSString stringWithFormat:@"%d %@", J1.Batterie, @"%"];
    J2_batterie.text = [NSString stringWithFormat:@"%d %@", J2.Batterie, @"%"];
    
    J1_jauge.frame = CGRectMake(42, 10, (int) (J1.Batterie * 125 * 0.01), 22);
    J2_jauge.frame = CGRectMake(43, 28, (int) (J2.Batterie * 125 * 0.01), 22);
    
    Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
    Cadre_Batterie.text = [NSString stringWithFormat:@"%d %@", player.Batterie, @"%"];
    
    if (J1.Batterie <= 0) {
        [self AlerteWithTitre:@"Fin du jeu !" andTexte:@"J2 a gagné."];
        [self initCombat];
    }
    else if (J2.Batterie <= 0)
    {
        [self AlerteWithTitre:@"Fin du jeu !" andTexte:@"J1 a gagné."];
        [self initCombat];
    }
    
    if (J1.Batterie <= 20) {
        J1_jauge.image = [UIImage imageNamed:@"vie_grand_rouge.png"];
    }
    else
    {
        J1_jauge.image = [UIImage imageNamed:@"vie_grand.png"];
    }
    
    if (J2.Batterie <= 20) {
        J2_jauge.image = [UIImage imageNamed:@"vie_grand_rouge.png"];
    }
    else
    {
        J2_jauge.image = [UIImage imageNamed:@"vie_grand.png"];
    }
}

- (void)changerCelluleLigne:(int)ligne andColonne:(int)colonne withColor:(UIColor*)couleur
{
    if (ligne >= 1) {
        if (ligne <= 10) {
            if (colonne >= 1) {
                if (colonne <= 7) {
                    Cellule *temp_cellule = [[Cellules objectAtIndex:ligne] objectAtIndex:colonne];
                    temp_cellule.bouton.backgroundColor = couleur;
                }
            }
        }
    }
}

- (void)resetColors
{
    [Cache removeFromSuperview];
    int i = 0;
    while (i < 10) {
        i++;
        int j = 0;
        while (j < 7) {
            j++;
            Cellule *temp = [[Cellules objectAtIndex:i] objectAtIndex:j];
            if (temp.couleur == TRANSPARENT) {
                if (((temp.ligne - 1) * 7 + temp.colonne) % 2 == 1) {
                    [self changerCelluleLigne:i andColonne:j withColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
                }
                else
                {
                    [self changerCelluleLigne:i andColonne:j withColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
                }
            }
            else if (temp.couleur == ROUGE)
            {
                [self changerCelluleLigne:i andColonne:j withColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
            }
            else if (temp.couleur == BLEU)
            {
                [self changerCelluleLigne:i andColonne:j withColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1]];    
            }
        }
    }
    [self.view addSubview:Cache];
}

- (void)PO_attaqueSoigneurLigne:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    UIColor *clair = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    UIColor *fonce = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne + 1) withColor:fonce];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne - 1) withColor:fonce];
    
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne + 1) withColor:clair];
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne - 1) withColor:clair];
    [self changerCelluleLigne:(ligne + 2) andColonne:(colonne) withColor:clair];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne + 1) withColor:clair];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne - 1) withColor:clair];
    [self changerCelluleLigne:(ligne - 2) andColonne:(colonne) withColor:clair];
    [self changerCelluleLigne:(ligne) andColonne:(colonne + 2) withColor:clair];
    [self changerCelluleLigne:(ligne) andColonne:(colonne - 2) withColor:clair];
}

- (void)PO_Telep:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    UIColor *fonce = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    int i = 0;
    while (i < 10)
    {
        i++;
        int j = 0;
        while (j < 7)
        {
            j++;
            Cellule *temp = [[Cellules objectAtIndex:i] objectAtIndex:j];
            if ((i != ligne) || (j != colonne))
            {
                if (temp.couleur == TRANSPARENT)
                {
                    [self changerCelluleLigne:(i) andColonne:(j) withColor:fonce];
                }
            }
        }
    }
}

- (void)PO_attaqueLigne:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    UIColor *clair = [UIColor colorWithRed:0.7 green:0.7 blue:0 alpha:1];
    UIColor *fonce = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne + 1) withColor:fonce];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne - 1) withColor:fonce];
    
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne + 1) withColor:clair];
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne - 1) withColor:clair];
    [self changerCelluleLigne:(ligne + 2) andColonne:(colonne) withColor:clair];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne + 1) withColor:clair];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne - 1) withColor:clair];
    [self changerCelluleLigne:(ligne - 2) andColonne:(colonne) withColor:clair];
    [self changerCelluleLigne:(ligne) andColonne:(colonne + 2) withColor:clair];
    [self changerCelluleLigne:(ligne) andColonne:(colonne - 2) withColor:clair];
}

- (void)PO_attaqueCacLigne:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    UIColor *fonce = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    [self changerCelluleLigne:(ligne + 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne + 1) withColor:fonce];
    [self changerCelluleLigne:(ligne - 1) andColonne:(colonne) withColor:fonce];
    [self changerCelluleLigne:(ligne) andColonne:(colonne - 1) withColor:fonce];
}

- (void)PO_attaqueCroixLigne:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    UIColor *fonce = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    
    int i = 0;
    while (i < 10)
    {
        i++;
        if (i != ligne)
        {
            if (i != ligne + 1) {
                if (i != ligne - 1) {
                    [self changerCelluleLigne:(i) andColonne:(colonne) withColor:fonce];
                }
            }
        }
    }
    
    i = 0;
    while (i < 7)
    {
        i++;
        if (i != colonne) {
            if (i != colonne + 1) {
                if (i != colonne - 1) {
                    [self changerCelluleLigne:(ligne) andColonne:(i) withColor:fonce];
                }
            }
        }
    }
}

- (void)PO_deplacementLigne:(int)ligne andColonne:(int)colonne
{
    [self resetColors];
    if (ligne + 1 <= 10)
    {
        if ([[[Cellules objectAtIndex:ligne + 1] objectAtIndex:colonne] estVide])
        {
            [self changerCelluleLigne:(ligne + 1) andColonne:(colonne) withColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        }
    }
    if (ligne - 1 >= 1) {
        if ([[[Cellules objectAtIndex:ligne - 1] objectAtIndex:colonne] estVide])
        {
            [self changerCelluleLigne:(ligne - 1) andColonne:(colonne) withColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        }
    }
    if (colonne + 1 <= 7)
    {
        if ([[[Cellules objectAtIndex:ligne] objectAtIndex:colonne + 1] estVide])
        {
            [self changerCelluleLigne:(ligne) andColonne:(colonne + 1) withColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        }
    }
    if (colonne - 1 >= 1)
    {
        if ([[[Cellules objectAtIndex:ligne] objectAtIndex:colonne - 1] estVide])
        {
            [self changerCelluleLigne:(ligne) andColonne:(colonne - 1) withColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
        }
    }
}

- (void)initCombat
{
    while ([Plateau.subviews count] !=  0) {
        [[Plateau.subviews objectAtIndex:[Plateau.subviews count] - 1] removeFromSuperview];
    }
    MonstresDeBase = [[NSMutableArray alloc] init];
    [MonstresDeBase addObject:[NSNumber numberWithInt:7]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:1 andVie:10 andPA:1 andPM:3 andSpe:CORPS_A_CORPS andMin:10 andMax:100 andNom:@"Papillon"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:2 andVie:55 andPA:1 andPM:2 andSpe:CORPS_A_CORPS andMin:50 andMax:70 andNom:@"Bourrin"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:3 andVie:75 andPA:2 andPM:2 andSpe:POUSSEUR andMin:0 andMax:0 andNom:@"Bloqueur"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:4 andVie:20 andPA:1 andPM:5 andSpe:CORPS_A_CORPS andMin:10 andMax:30 andNom:@"Rapide"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:5 andVie:40 andPA:1 andPM:3 andSpe:DISTANCE andMin:10 andMax:40 andNom:@"Distance"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:6 andVie:20 andPA:1 andPM:3 andSpe:CORPS_A_CORPS andMin:10 andMax:30 andNom:@"Cheap"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:7 andVie:30 andPA:1 andPM:3 andSpe:MECANO andMin:5 andMax:10 andNom:@"Mécano"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:8 andVie:85 andPA:1 andPM:3 andSpe:BERSERKER andMin:0 andMax:5 andNom:@"Berserker"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:9 andVie:15 andPA:1 andPM:2 andSpe:TELEPORTEUR andMin:0 andMax:0 andNom:@"Téléporteur"]];
    [MonstresDeBase addObject:[[MonstreBase alloc] initWithID:10 andVie:40 andPA:2 andPM:3 andSpe:SOIGNEUR andMin:20 andMax:40 andNom:@"Soigneur"]];
    
    Monstres = [[NSMutableArray alloc] init];
    
    Joueurs = [[NSMutableArray alloc] init];
    [Joueurs addObject:[NSNumber numberWithInt:7]];
    [Joueurs addObject:[[Joueur alloc] initWithID:1 andNom:@"Cartman"]];
    [Joueurs addObject:[[Joueur alloc] initWithID:2 andNom:@"Thibault"]];
    
    Tour_actuel = [[Tour alloc] init];
    
    Cellules = [[NSMutableArray alloc] init];
    [Cellules addObject:[NSNumber numberWithInt:7]];
    
    int i = 0;
    while (i < 10) {
        i++;
        [Cellules addObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:7], nil]];
        int j = 0;
        while (j < 7) {
            j++;
            Cellule *temp_cellule = [[Cellule alloc] initWithLigne:i andColonne:j];
            temp_cellule.bouton = [[UIButton alloc] initWithFrame:CGRectMake((j - 1) * 30, (i - 1) * 36, 30, 36)];
            temp_cellule.bouton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            temp_cellule.bouton.tag = (i - 1) * 7 + j;            
            [temp_cellule.bouton addTarget:self action:@selector(ToucherCase:) forControlEvents:UIControlEventTouchUpInside];
            [Plateau addSubview:temp_cellule.bouton];
            [[Cellules objectAtIndex:i] addObject:temp_cellule];
        }
    }
    
    [[[Cellules objectAtIndex:1] objectAtIndex:1] occuperAvecEtat:CHARGEUR andID:1];
    [[[Cellules objectAtIndex:1] objectAtIndex:7] occuperAvecEtat:CHARGEUR andID:2];
    [[[Cellules objectAtIndex:10] objectAtIndex:1] occuperAvecEtat:CHARGEUR andID:1];
    [[[Cellules objectAtIndex:10] objectAtIndex:7] occuperAvecEtat:CHARGEUR andID:2];
    [[[Cellules objectAtIndex:1] objectAtIndex:4] occuperAvecEtat:GENERATEUR andID:0];
    [[[Cellules objectAtIndex:10] objectAtIndex:4] occuperAvecEtat:GENERATEUR andID:0];
    
    
    [[[Cellules objectAtIndex:1] objectAtIndex:1] mettreCouleur:ROUGE]; 
    [[[Cellules objectAtIndex:1] objectAtIndex:7] mettreCouleur:ROUGE];
    
    [[[Cellules objectAtIndex:1] objectAtIndex:3] mettreCouleur:ROUGE];
    [[[Cellules objectAtIndex:1] objectAtIndex:4] mettreCouleur:ROUGE];
    [[[Cellules objectAtIndex:1] objectAtIndex:5] mettreCouleur:ROUGE];
    [[[Cellules objectAtIndex:2] objectAtIndex:3] mettreCouleur:ROUGE];
    [[[Cellules objectAtIndex:2] objectAtIndex:4] mettreCouleur:ROUGE];
    [[[Cellules objectAtIndex:2] objectAtIndex:5] mettreCouleur:ROUGE];


    [[[Cellules objectAtIndex:10] objectAtIndex:1] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:10] objectAtIndex:7] mettreCouleur:BLEU];
    
    [[[Cellules objectAtIndex:10] objectAtIndex:3] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:10] objectAtIndex:4] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:10] objectAtIndex:5] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:9] objectAtIndex:3] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:9] objectAtIndex:4] mettreCouleur:BLEU];
    [[[Cellules objectAtIndex:9] objectAtIndex:5] mettreCouleur:BLEU];


    
    i = 0;
    int nb_rochers = (arc4random() % 4) + 2;
    while (i < nb_rochers)
    {
        int continuer = 1;
        while (continuer)
        {
            [self dormir:0.02];
            int ligne = (arc4random() % 6) + 3;
            [self dormir:0.02];
            int colonne = (arc4random() % 7) + 1;
            Cellule *temp = [[Cellules objectAtIndex:ligne]  objectAtIndex:colonne];
            if (temp.etat == VIDE)
            {
                [[[Cellules objectAtIndex:ligne] objectAtIndex:colonne] occuperAvecEtat:ROCHER andID:0];
                continuer = 0;
            }
        }
        i++;
    }
    i = 0;
    int nb_glacees = (arc4random() % 4) + 2;
    while (i < nb_glacees)
    {
        int continuer = 1;
        while (continuer)
        {            
            [self dormir:0.02];
            int ligne = (arc4random() % 6) + 3;
            [self dormir:0.02];
            int colonne = (arc4random() % 7) + 1;
            Cellule *temp = [[Cellules objectAtIndex:ligne]  objectAtIndex:colonne];
            if (temp.etat == VIDE)
            {
                [[[Cellules objectAtIndex:ligne] objectAtIndex:colonne] occuperAvecEtat:GLACE andID:0];
                continuer = 0;
            }
        }
        i++;
    }
    
    Joueur *J1 = [Joueurs objectAtIndex:1];
    Joueur *J2 = [Joueurs objectAtIndex:2];
    J1_texte.text = [NSString stringWithFormat:@"J1 - %@ - Monstres", J1.Nom];
    J2_texte.text = [NSString stringWithFormat:@"J2 - %@ - Monstres", J2.Nom];
    [self actualiser];
    [self actualiser_batterie];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //Vues
    
    //Menu principal
    Menu_principal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    Menu_principal.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *bouton = [[UIButton alloc] initWithFrame:CGRectMake(60, 220, 200, 40)];
    [bouton setTitle:@"Commencer" forState:UIControlStateNormal];
    [bouton addTarget:self action:@selector(optionsCombat) forControlEvents:UIControlEventTouchUpInside];
    bouton.backgroundColor = [UIColor grayColor];
    
    [Menu_principal addSubview:bouton];
    
    //Options de combat
    Options_de_combat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    Options_de_combat.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *bouton_retour = [[UIButton alloc] initWithFrame:CGRectMake(20, 430, 130, 30)];
    bouton_retour.backgroundColor = [UIColor grayColor];
    [bouton_retour setTitle:@"Retour" forState:UIControlStateNormal];
    [bouton_retour addTarget:self action:@selector(retourMenuPrincipal) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bouton_commencer = [[UIButton alloc] initWithFrame:CGRectMake(170, 430, 130, 30)];
    bouton_commencer.backgroundColor = [UIColor grayColor];
    [bouton_commencer setTitle:@"Commencer" forState:UIControlStateNormal];
    [bouton_commencer addTarget:self action:@selector(selectionCombattants) forControlEvents:UIControlEventTouchUpInside];

    [Options_de_combat addSubview:bouton_retour];
    [Options_de_combat addSubview:bouton_commencer];
    
    //Sélection des combattants
    Selection_des_combattants = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    Selection_des_combattants.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *bouton_go_combat = [[UIButton alloc] initWithFrame:CGRectMake(170, 430, 130, 30)];
    bouton_go_combat.backgroundColor = [UIColor grayColor];
    [bouton_go_combat setTitle:@"Combattre" forState:UIControlStateNormal];
    [bouton_go_combat addTarget:self action:@selector(plateauDeJeu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bouton_retour_2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 430, 130, 30)];
    bouton_retour_2.backgroundColor = [UIColor grayColor];
    [bouton_retour_2 setTitle:@"Retour" forState:UIControlStateNormal];
    [bouton_retour_2 addTarget:self action:@selector(optionsCombat) forControlEvents:UIControlEventTouchUpInside];

    [Selection_des_combattants addSubview:bouton_go_combat];
    [Selection_des_combattants addSubview:bouton_retour_2];
    
    //Options
    nb_combattants = 11;
    rocher_active = 1;
    glace_active = 1;
    
    [self retourMenuPrincipal];
}

- (void)viewDidUnload
{
    Base = nil;
    Choix_Invoc = nil;
    Monstre_Invoc = nil;
    Jx = nil;
    Cadre_nb_invoc = nil;
    Cadre_Num_Tour = nil;
    Cadre_Batterie = nil;
    Liste_des_monstres = nil;
    Catalog_Monstres = nil;
    IM_image = nil;
    IM_nom = nil;
    IM_type = nil;
    IM_attaque = nil;
    IM_vie = nil;
    IM_PA = nil;
    IM_PM = nil;
    IM_prix = nil;
    TBM_image = nil;
    TBM_nom = nil;
    TBM_jauge = nil;
    TBM_joueur = nil;
    TBM_type = nil;
    TBM_attaque = nil;
    TBM_vie = nil;
    TBM_PA = nil;
    TBM_PM = nil;
    TBM_coordonnees = nil;
    TBM_bouton_attaque = nil;
    TBM_bouton_deplacement = nil;
    Plateau = nil;
    J1_jauge = nil;
    J1_texte = nil;
    J1_batterie = nil;
    J2_jauge = nil;
    J2_texte = nil;
    J2_batterie = nil;
    J2_jauge = nil;
    J2_texte = nil;
    J2_batterie = nil;
    J1_jauge = nil;
    J1_texte = nil;
    J1_batterie = nil;
    Tableau_de_bord = nil;
    Monstre_View = nil;
    Jx = nil;
    PlayerColor = nil;
    Cache = nil;
    Chargeur_View = nil;
    CV_jauge = nil;
    CV_joueur = nil;
    CV_vie = nil;
    CV_gain = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return 1;
    }
    else
    {
        return 0;
    }
}

#pragma mark - Interface

- (IBAction)Fin_Tour:(id)sender
{
    [Tour_actuel finDuTour];
    int i = 0;
    while (i < [Monstres count]) {
        [[Monstres objectAtIndex:i] Reset];
        i++;
    }
    Joueur *actuel = [Joueurs objectAtIndex:Tour_actuel.joueur];
    actuel.nb_invoc = 2;
    [actuel gagnerBatterie];
    [self actualiser_batterie];
        
    [self resetColors];
    [Chargeur_View removeFromSuperview];
    [Choix_Invoc removeFromSuperview];
    [Monstre_Invoc removeFromSuperview];
    [Monstre_View removeFromSuperview];
    if (Tour_actuel.joueur == 1) {
        PlayerColor.backgroundColor = [UIColor blueColor];
    }
    else
    {
        PlayerColor.backgroundColor = [UIColor redColor];
    }
    Jx.text = [NSString stringWithFormat:@"J%d", Tour_actuel.joueur];
    Cadre_Num_Tour.text = [NSString stringWithFormat:@"Tour %d", Tour_actuel.num];
    Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];
    Cadre_nb_invoc.text = [NSString stringWithFormat:@"%d In.", player.nb_invoc];
    Cadre_Batterie.text = [NSString stringWithFormat:@"%d %@", player.Batterie, @"%"];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
        [self retourMenuPrincipal];
	}
}

- (IBAction)Quitter:(id)sender
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Confirmation"];
	[alert setMessage:@"Voulez-vous vraiment quitter cette partie ?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Non"];
	[alert addButtonWithTitle:@"Oui"];
	[alert show];
}

- (IBAction)Invoquer:(id)sender
{
    Joueur *player = [Joueurs objectAtIndex:Tour_actuel.joueur];

    if (player.nb_invoc > 0) {
        [Catalog_Monstres setContentSize:CGSizeMake(110, 50 * ([MonstresDeBase count] - 1))];
        
        int i = 1;
        while (i < [MonstresDeBase count]) {
            MonstreBase *temp = [MonstresDeBase objectAtIndex:i];
            UIButton* noms_bouton = [[UIButton alloc] initWithFrame:CGRectMake(5, (i - 1) * 50 + 10, 100, 30)];
            [noms_bouton setTitle:[NSString stringWithFormat:@"%@ (%d)", temp.Nom, [temp getPrix]] forState:UIControlStateNormal];
            noms_bouton.tag = i;
            noms_bouton.backgroundColor = [UIColor blueColor];
            [noms_bouton addTarget:self action:@selector(afficher_catalog:) forControlEvents:UIControlEventTouchUpInside];
            noms_bouton.titleLabel.font = [UIFont fontWithName:@"" size:10];
            [Catalog_Monstres addSubview:noms_bouton];
            i++;
        }
        [Tableau_de_bord addSubview:Choix_Invoc];
    }
    else
    {
        [self AlerteWithTitre:@"Erreur !" andTexte:@"Vous ne pouvez plus invoquer de monstre pour ce tour."];
    }
}

- (IBAction)Annuler_Invoc:(id)sender
{
    Tour_actuel.type = RIEN;
    [self resetColors];
    [Chargeur_View removeFromSuperview];
    [Choix_Invoc removeFromSuperview];
    [Monstre_Invoc removeFromSuperview];
    [Monstre_View removeFromSuperview];
}

- (IBAction)TBM_switch_attaque:(id)sender
{

}

@end
