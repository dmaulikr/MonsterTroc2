//
//  Tour.h
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RIEN,
    DEPLACER,
    INVOQUER,
    ATTAQUER
} TypeTour;

@interface Tour : NSObject
{
    int pause;
    int joueur;
    TypeTour type;
    int ID;
    int num;
}

- (id)init;
- (void)finDuTour;
- (void)reprendre;
- (void)pauseDe:(int)temps;

@property (readonly) int pause, joueur, num;
@property (readwrite) TypeTour type;
@property (readwrite) int ID;

@end
