//
//  keypoint.h
//  camera
//
//  Created by Fan ZHAO on 11-1-27.
//  Copyright 2011 Personne. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface keypoint : NSObject {
	float x;
	float y;
	NSArray * descrpitors;
	float angle;
	float size;
}
@property (retain) NSArray * descrpitors;
@property (assign) float x;
@property (assign) float y;
@property (assign) float angle;
@property (assign) float size;



@end
