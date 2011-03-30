//
//  ModuleCom.h
//  camera
//
//  Created by Fan ZHAO on 11-1-27.
//  Copyright 2011 Personne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "keypoint.h"
@interface ModuleCom : NSObject {

}

+(NSString *) communiquerCaractsAvecKeypoints:(NSArray *) keypoints;
+(NSMutableString *)createXMLWithKeypoints:(NSArray *)keypoints;
@end
