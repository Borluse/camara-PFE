//
//  cameraAppDelegate.h
//  camera
//
//  Created by Borluse on 25/11/10.
//  Copyright Personne 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cameraViewController;

@interface cameraAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	cameraViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet cameraViewController *viewController;



@end

