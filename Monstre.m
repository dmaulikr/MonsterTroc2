//
//  Monstre.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Monstre.h"

@implementation Monstre

@synthesize Appartenance, Mort, Spe, ID_Base, Vie, Vie_Max, PM, PA, PA_Max, PM_Max, Attaque_Max, Attaque_Min, Nom, Ligne, Colonne, image, jauge, vie_sur_jauge;


- (id)initWithJoueur:(int)joueur andIDBase:(int)ID avecListeDesMonstresDeBase:(NSArray*)MonstresDeBase
{
    self = [super init];
    
    Mort = 0;
    Appartenance = joueur;
    
    ID_Base = ID;
    MonstreBase* temp = [MonstresDeBase objectAtIndex:ID];
    Nom = temp.Nom;
    Attaque_Min = temp.Attaque_Min;
    Attaque_Max = temp.Attaque_Max;
    Spe = temp.Spe;
    Vie = temp.Vie;
    Vie_Max = temp.Vie;
    PM = temp.PM;
    PM_Max = temp.PM;
    PA = temp.PA;
    PA_Max = temp.PA;
    
    Prix_base = [temp getPrix];
        
    return self;
}

- (int)Sacrifier
{
    Mort = 1;
    int batterie_recup = 0.6 * Prix_base * (Vie / Vie_Max);
    return batterie_recup;
}

- (int)SubirDegats:(int)valeur
{
    Vie = Vie - valeur;
    if (Vie <= 0) {
        Mort = 1;
    }
    else if (Vie >= Vie_Max)
    {
        valeur = valeur + (Vie - Vie_Max);
        Vie = Vie_Max;
    }
    
    if (Spe == BERSERKER) {
        Attaque_Min += valeur;
        Attaque_Max += valeur;
    }
    
    return Mort;
}

- (int)Attaquer
{
    PA = PA - 1;
    if (Attaque_Max > 0) {
        int attaque = (arc4random() % (Attaque_Max - Attaque_Min)) + Attaque_Min;
        return attaque;
    }
    else
    {
        return 0;
    }
}

- (void)Deplacer
{
    PM = PM - 1;
}

- (void)Reset
{
    PA = PA_Max;
    PM = PM_Max;
}

- (NSString*)getImage
{
    if ((ID_Base == 6) && Appartenance == 2) {
        return [NSString stringWithFormat:@"monstre_6_2.png"];
    }
    else
    {
        return [NSString stringWithFormat:@"monstre_%d.png", ID_Base];
    }
}

- (NSString*)description
{
    NSString* texte = [NSString stringWithFormat:@"\nMonstre : %@\nID : %d\nType : %d\nVie : %d / %d\nAttaque : %d - %d\nPA : %d / %d\nPM : %d / %d\nPrix : %d\nMort : %d\nJoueur : %d", Nom, ID_Base, Spe, Vie, Vie_Max, Attaque_Min, Attaque_Max, PA, PA_Max, PM, PM_Max, [self Sacrifier], Mort, Appartenance];
    return  texte;
}

@end
