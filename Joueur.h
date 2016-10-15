//
//  Joueur.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Joueur : NSObject
{
    int ID;
    NSString* Nom;
    int Batterie;
    int Chargeur_1;
    int Chargeur_2;
    int nb_invoc;
}

- (id)initWithID:(int)ID_ andNom:(NSString*)Nom_;
- (void)gagnerBatterie;
- (int)perdreBatterie:(int)valeur;
- (void)attaqueChargeur:(int)ID_ andValeur:(int)valeur;

@property (readonly) NSString* Nom;
@property (readonly) int Batterie, Chargeur_1, Chargeur_2, ID;
@property (readwrite) int nb_invoc;

@end
