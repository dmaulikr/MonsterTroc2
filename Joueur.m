//
//  Joueur.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Joueur.h"

@implementation Joueur

@synthesize Nom, Batterie, Chargeur_2, Chargeur_1, nb_invoc, ID;

- (id)initWithID:(int)ID_ andNom:(NSString*)Nom_
{
    self = [super init];
    
    ID = ID_;
    Nom = Nom_;
    Batterie = 100;
    Chargeur_1 = 80;
    Chargeur_2 = 80;
    nb_invoc = 1;
    
    return self;
}

- (void)gagnerBatterie
{
    int Bonus = 0;
    if (Chargeur_1 > 0)
    {
        Bonus += 5;
        double quotient = round((84 - Chargeur_1) / 8);
        Bonus += quotient;
    }
    if (Chargeur_2 > 0)
    {
        Bonus += 5;
        double quotient = round((84 - Chargeur_2) / 8);
        Bonus += quotient;
    }
    Batterie += Bonus;
    if (Batterie > 100)
    {
        Batterie = 100;
    }
}

- (int)perdreBatterie:(int)valeur
{
    Batterie -= valeur;
    if (Batterie > 0) {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (void)attaqueChargeur:(int)ID_ andValeur:(int)valeur
{
    if (ID_ == 1)
    {
        Chargeur_1 -= valeur;
        if (Chargeur_1 <= 0)
        {
            Chargeur_1 = 0;
        }
    }
    else if (ID_ == 2)
    {
        Chargeur_2 -= valeur;
        if (Chargeur_2 <= 0)
        {
            Chargeur_2 = 0;
        }
    }
}

@end
