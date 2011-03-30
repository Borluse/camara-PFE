//
//  cameraViewController.h
//  camera
//
//  Created by Borluse on 25/11/10.
//  Copyright Personne 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ModuleRF.h"

@class ModuleRF;

@interface cameraViewController : UIViewController<UIImagePickerControllerDelegate> {
	UIImageView *imgView;
	UIButton *buttonCamera;
    UIImage *image;
	UIImage *imageFini;
    IBOutlet UISegmentedControl *algoChoixSegment;
	ModuleRF *rf;
	NSDate *timer1;
	NSDate *timer2;
}
@property (nonatomic, retain) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) IBOutlet UIButton *buttonCamera;
@property (retain) IBOutlet UISegmentedControl *algoChoixSegment;
@property (retain) NSDate * timer1;
@property (retain) NSDate * timer2;
@property (nonatomic, retain) ModuleRF *rf;

-(IBAction) prendrePhotoAvecCamera;
-(IBAction) prendrePhotoExiste;
-(IBAction) makeChoix;
- (void)photoPres:(NSNotification *)notification;
@end

