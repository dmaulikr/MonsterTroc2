//
//  Cellule.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cellule.h"

@implementation Cellule

@synthesize ligne, colonne, ID, etat;
@synthesize couleur;
@synthesize bouton;

- (id)initWithLigne:(int)ligne_ andColonne:(int)colonne_
{
    self = [super init];
    
    ligne = ligne_;
    colonne = colonne_;
    etat = VIDE;
    ID = 0;
    couleur = TRANSPARENT;
    
    return self;
}

- (void)mettreCouleur:(TypeCouleur)color
{
    couleur = color;
}

- (void)occuperAvecEtat:(TypeCase)etat_ andID:(int)ID_
{
    etat = etat_;
    ID = ID_;
}

- (void)vider
{
    etat = VIDE;
    ID = 0;
}

- (int)distanceAvec:(Cellule*)cellule_
{
    return (abs(ligne - cellule_.ligne) + abs(colonne - cellule_.colonne));
}

- (int)estVide
{
    if (etat == VIDE) {
        return 1;
    }
    else if (etat == GLACE)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

- (int)ligneDeVueAvec:(Cellule*)cellule_
{
    if (ligne == cellule_.ligne) {
        return 1;
    }
    else if (colonne == cellule_.colonne)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

@end
