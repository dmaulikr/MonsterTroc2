//
//  ViewController.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Monstre.h"
#include "Joueur.h"
#include "Tour.h"
#include "Cellule.h"

@interface ViewController : UIViewController
{    
    //Options
    int nb_combattants,
    rocher_active,
    glace_active;
    
    //Vues
    UIView *Menu_principal,
    *Options_de_combat,
    *Selection_des_combattants,
    *Plateau_de_jeu;
    
    NSMutableArray* MonstresDeBase;
    NSMutableArray* Monstres;
    NSMutableArray* Joueurs;
    NSMutableArray* Cellules;
    Tour *Tour_actuel;
    
    IBOutlet UIView *Plateau;
    
    IBOutlet UIView *Tableau_de_bord;
    
    IBOutlet UIView *Base;
    IBOutlet UIView *Choix_Invoc;
    IBOutlet UIView *Monstre_Invoc;
    IBOutlet UIView *Monstre_View;
    IBOutlet UIView *Chargeur_View;
    
    IBOutlet UIView *PlayerColor;
    IBOutlet UILabel *Jx;
    IBOutlet UILabel *Cadre_nb_invoc;
    IBOutlet UILabel *Cadre_Num_Tour;
    IBOutlet UILabel *Cadre_Batterie;
    
    IBOutlet UIScrollView *Liste_des_monstres;
    IBOutlet UIScrollView *Catalog_Monstres;
    
    
    IBOutlet UIImageView *IM_image;
    IBOutlet UILabel *IM_nom;
    IBOutlet UIImageView *IM_type;
    IBOutlet UILabel *IM_attaque;
    IBOutlet UILabel *IM_vie;
    IBOutlet UILabel *IM_PA;
    IBOutlet UILabel *IM_PM;
    IBOutlet UILabel *IM_prix;
    
    IBOutlet UIImageView *CV_jauge;
    IBOutlet UIImageView *CV_joueur;
    IBOutlet UILabel *CV_vie;
    IBOutlet UILabel *CV_gain;
    
    
    IBOutlet UIImageView *TBM_image;
    IBOutlet UILabel *TBM_nom;
    IBOutlet UIImageView *TBM_jauge;
    IBOutlet UIImageView *TBM_joueur;
    IBOutlet UIImageView *TBM_type;
    IBOutlet UILabel *TBM_attaque;
    IBOutlet UILabel *TBM_vie;
    IBOutlet UILabel *TBM_PA;
    IBOutlet UILabel *TBM_PM;
    IBOutlet UILabel *TBM_coordonnees;
    IBOutlet UIImageView *TBM_bouton_attaque;
    IBOutlet UIImageView *TBM_bouton_deplacement;
    
    IBOutlet UIImageView *J2_jauge;
    IBOutlet UILabel *J2_texte;
    IBOutlet UILabel *J2_batterie;
    IBOutlet UIImageView *J1_jauge;
    IBOutlet UILabel *J1_texte;
    IBOutlet UILabel *J1_batterie;
    
    IBOutlet UIImageView *Cache;
    
    NSArray *Jauge_chargeurs;
}

//Gestion des vues
- (void)retourMenuPrincipal;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)optionsCombat;
- (void)selectionCombattants;
- (void)plateauDeJeu;
- (void)initCombat;
- (void)resetColors;
- (void)toucherCaseActuelle;
- (void)deplacerMonstre:(Monstre*)monster from:(CGPoint)depart to:(CGPoint)arrivee;
- (void)bougerMonstre:(NSTimer*)theTimer;
- (void)AlerteWithTitre:(NSString*)title andTexte:(NSString*)texte;
- (void)PO_deplacementLigne:(int)ligne andColonne:(int)colonne;
- (void)PO_attaqueLigne:(int)ligne andColonne:(int)colonne;
- (void)PO_Telep:(int)ligne andColonne:(int)colonne;
- (void)PO_attaqueSoigneurLigne:(int)ligne andColonne:(int)colonne;
- (void)PO_attaqueCacLigne:(int)ligne andColonne:(int)colonne;
- (void)PO_attaqueCroixLigne:(int)ligne andColonne:(int)colonne;
- (void)dormir:(double)secondes;
- (void)actualiser;
- (void)actualiser_batterie;
- (void)ToucherCase:(UIButton*)sender;
- (void)toucher_caseLigne:(int)ligne andColonne:(int)colonne;
- (void)afficher_catalog:(UIButton*)sender;
- (void)changerCelluleLigne:(int)ligne andColonne:(int)colonne withColor:(UIColor*)couleur;

- (IBAction)Fin_Tour:(id)sender;
- (IBAction)Quitter:(id)sender;
- (IBAction)Invoquer:(id)sender;
- (IBAction)Annuler_Invoc:(id)sender;
- (IBAction)TBM_switch_attaque:(id)sender;

@end
