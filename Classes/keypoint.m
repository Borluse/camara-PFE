//
//  keypoint.m
//  camera
//
//  Created by Fan ZHAO on 11-1-27.
//  Copyright 2011 Personne. All rights reserved.
//

#import "keypoint.h"


@implementation keypoint
@synthesize x,y, descrpitors, angle, size;

-(void) dealloc{
	[descrpitors release];
	[super dealloc];
}
@end
