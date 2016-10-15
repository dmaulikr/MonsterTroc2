//
//  MonstreBase.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonstreBase.h"

@implementation MonstreBase

@synthesize ID, Vie, PA, PM, Attaque_Min, Attaque_Max, Spe;
@synthesize Nom;

- (id)initWithID:(int)ID_ andVie:(int)Vie_ andPA:(int)PA_ andPM:(int)PM_ andSpe:(SpecialiteMonstre)Spe_ andMin:(int)Attaque_Min_ andMax:(int)Attaque_Max_ andNom:(NSString*)Nom_
{
    self = [super init];
    
    ID = ID_;
    Vie = Vie_;
    PA = PA_;
    PM = PM_;
    Attaque_Min = Attaque_Min_;
    Attaque_Max = Attaque_Max_;
    Nom = Nom_;
    Spe = Spe_;
    
    return self;
}

- (int)getPrix
{
    //Coeff de prix
    double coeff_prix = 0.5;
    
    double coeff_cac = 1;
    double coeff_soin = 1;
    double coeff_distance = 1.5;
    double coeff_berserker = 1.4;
    double coeff_mecano = 2;
    double coeff_pousseur = 1.2;
    double coeff_teleporteur = 5;
    
    NSArray *coeff_PA = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:0.2], [NSNumber numberWithDouble:1], [NSNumber numberWithDouble:1.15], [NSNumber numberWithDouble:1.4], nil];
    NSArray* coeff_PM = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:0.2], [NSNumber numberWithDouble:0.5], [NSNumber numberWithDouble:0.8], [NSNumber numberWithDouble:1], [NSNumber numberWithDouble:1.25], [NSNumber numberWithDouble:1.5], [NSNumber numberWithDouble:1.8], nil];

    double prix = coeff_prix * (0.5 * ((Attaque_Min + Attaque_Max) / 2) + 0.5 * Vie) * [[coeff_PA objectAtIndex:PA] doubleValue] * [[coeff_PM objectAtIndex:PM] doubleValue];
    
    if (Spe == CORPS_A_CORPS)
    {
        return prix * coeff_cac;
    }
    else if (Spe == DISTANCE)
    {
        return prix * coeff_distance;
    }
    else if (Spe == SOIGNEUR)
    {
        return prix * coeff_soin;
    }
    else if (Spe == BERSERKER)
    {
        return prix * coeff_berserker;
    }
    else if (Spe == MECANO)
    {
        return prix * coeff_mecano;
    }
    else if (Spe == POUSSEUR)
    {
        return prix * coeff_pousseur;
    }
    else if (Spe == TELEPORTEUR)
    {
        return prix * coeff_teleporteur;
    }
    else
    {
        return prix;
    }
}

- (NSString*)getImage
{
    return [NSString stringWithFormat:@"monstre_%d.png", ID];
}

- (NSString*)description
{
    NSString* texte = [NSString stringWithFormat:@"\nMonstre : %@\nID : %d\nType : %d\nVie : %d\nAttaque : %d - %d\nPA : %d\nPM : %d\nPrix : %d", Nom, ID, Spe, Vie, Attaque_Min, Attaque_Max, PA, PM, [self getPrix]];
    return  texte;
}

@end
