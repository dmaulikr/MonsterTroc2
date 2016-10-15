//
//  Tour.m
//  Monster Troc 2
//
//  Created by Thibault Dardinier on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tour.h"

@implementation Tour

@synthesize pause, joueur, num, type, ID;

- (id)init
{
    self = [super init];
    
    pause = 0;
    joueur = 1;
    type = RIEN;
    num = 1;
    ID = 0;
    
    return self;
}

- (void)finDuTour
{
    if (joueur == 1) {
        joueur = 2;
    }
    else if(joueur == 2)
    {
        joueur = 1;
        num++;
    }
    type = RIEN;
    ID = 0;
}

- (void)reprendre
{
    pause = 0;
}

- (void)pauseDe:(int)temps
{
    pause = 1;
    NSTimer *Timer = [NSTimer scheduledTimerWithTimeInterval:temps target:self selector:@selector(reprendre) userInfo:nil repeats:NO];
}

@end
