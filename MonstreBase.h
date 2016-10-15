//
//  MonstreBase.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CORPS_A_CORPS,
    DISTANCE,
    SOIGNEUR,
    BERSERKER,
    MECANO,
    POUSSEUR,
    TELEPORTEUR
} SpecialiteMonstre;

@interface MonstreBase : NSObject
{
    int ID;
    int Vie;
    int PA;
    int PM;
    int Attaque_Min;
    int Attaque_Max;
    SpecialiteMonstre Spe;
    NSString *Nom;
}

@property (readonly) int ID;
@property (readonly) int Vie;
@property (readonly) int PA;
@property (readonly) int PM;
@property (readonly) int Attaque_Min;
@property (readonly) int Attaque_Max;
@property (readonly) SpecialiteMonstre Spe;
@property (readonly) NSString *Nom;

- (id)initWithID:(int)ID_ andVie:(int)Vie_ andPA:(int)PA_ andPM:(int)PM_ andSpe:(SpecialiteMonstre)Spe_ andMin:(int)Attaque_Min_ andMax:(int)Attaque_Max_ andNom:(NSString*)Nom_;
- (int)getPrix;
- (NSString*)getImage;
- (NSString*)description;

@end
