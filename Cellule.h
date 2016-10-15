//
//  Cellule.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MONSTRE,
    ROCHER,
    VIDE,
    CHARGEUR,
    GENERATEUR,
    GLACE
} TypeCase;

typedef enum {
    TRANSPARENT,
    BLEU,
    ROUGE
} TypeCouleur;

@interface Cellule : NSObject
{
    int ligne;
    int colonne;
    TypeCase etat;
    int ID;
    TypeCouleur couleur;
    
    UIButton *bouton;
}

- (id)initWithLigne:(int)ligne_ andColonne:(int)colonne_;
- (void)occuperAvecEtat:(TypeCase)etat_ andID:(int)ID_;
- (void)vider;
- (int)distanceAvec:(Cellule*)cellule_;
- (int)ligneDeVueAvec:(Cellule*)cellule_;
- (void)mettreCouleur:(TypeCouleur)color;
- (int)estVide;

@property (readonly) int ligne, colonne, ID;
@property (readonly) TypeCase etat;
@property (readwrite) TypeCouleur couleur;
@property (readwrite, retain) UIButton *bouton;

@end
