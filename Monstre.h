//
//  Monstre.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MonstreBase.h"

@interface Monstre : NSObject
{
    int Appartenance;
    int Mort;
    
    SpecialiteMonstre Spe;
    
    int ID_Base;
    
    int Vie;
    int Vie_Max;
    
    int PA;
    int PA_Max;
    
    int PM;
    int PM_Max;
    
    int Attaque_Min;
    int Attaque_Max;
    
    int Ligne;
    int Colonne;
    
    int Prix_base;
    
    NSString *Nom;
    
    UIImageView *image;
    UIImageView *jauge;
    UILabel *vie_sur_jauge;
}

- (id)initWithJoueur:(int)joueur andIDBase:(int)ID avecListeDesMonstresDeBase:(NSArray*)MonstresDeBase;
- (int)Sacrifier;
- (int)SubirDegats:(int)valeur;
- (int)Attaquer;
- (void)Deplacer;
- (void)Reset;
- (NSString *)description;
- (NSString*)getImage;

@property (readonly) int Appartenance;
@property (readonly) int Mort;
@property (readonly) SpecialiteMonstre Spe;
@property (readonly) int ID_Base;
@property (readonly) int Vie;
@property (readonly) int Vie_Max;
@property (readonly) int PA;
@property (readonly) int PA_Max;
@property (readonly) int PM;
@property (readonly) int PM_Max;
@property (readonly) int Attaque_Min;
@property (readonly) int Attaque_Max;
@property (readonly) NSString *Nom;

@property (readwrite) int Ligne;
@property (readwrite) int Colonne;
@property (readwrite, retain) UIImageView *image, *jauge;
@property (readwrite, retain) UILabel *vie_sur_jauge;

@end
