//
//  ModuleRF.m
//  camera
//
//  Created by Borluse on 06/12/10.
//  Copyright 2010 Personne. All rights reserved.
//

#import "ModuleRF.h"



using namespace std;
using namespace cv;

@implementation ModuleRF
@synthesize algochoix,imgRequetFiniCal, num, keypoints, nbKeyPoints, descrpitors;



-(id) init{
	[super init];
	algochoix = 0;
	return self;
}

-(void) changerImg: (UIImage* ) img{
	imgIplSource = [self CreateIplImageFromUIImage:img];
}

-(id) initWithImg: (UIImage* ) img{
	if ((self = [super init])){
		imgIplSource = [self CreateIplImageFromUIImage:img];
	}
	return self;
}

-(void) calculerCaractsSurPhoto{
	keypoints.clear();
	IplImage * objGray = cvCreateImage(cvGetSize(imgIplSource), 8, 1);
	cvCvtColor(imgIplSource, objGray, CV_BGR2GRAY);
	Mat img(objGray, 0);
    algochoix = 0;
	if (algochoix == 0){
		NSLog(@"surf");
		SURF surf;
		surf(img, Mat(), keypoints, descrpitors);
		num = surf.descriptorSize();
		NSLog(@"keyPoints   : %d", keypoints.size());
		NSLog(@"Descrpiteur : %d", descrpitors.size());
		NSLog(@"num         : %d", num);
	}
    else {
		NSLog(@"sift");
        //     SIFT sift;
        //sift(img,Mat(), keypoints, descripSift);
        // num = sift.descriptorSize();
		NSLog(@"keyPoints   : %d", keypoints.size());
		NSLog(@"Descrpiteur : %d  %d", descripSift.rows, descripSift.cols);
		NSLog(@"num         : %d", num);
	}
	
	nbKeyPoints = keypoints.size();
	cvReleaseImage(&objGray); 
	[self drawKeyPoint];
 }


-(void) drawKeyPoint{
	if (algochoix == 0){
		for (int i=0; i < keypoints.size(); i++){
			KeyPoint * p = &keypoints.at(i);
			CvPoint center;
			int radius;
			center.x = cvRound(p->pt.x);
			center.y = cvRound(p->pt.y);
			radius = cvRound(p->size*1.2/9.*2);
			cvCircle(imgIplSource, center, radius, cvScalar(0, 0, 255), 1, CV_AA, 0);
//			NSLog(@"%f",p->angle);
			float angle = p->angle;
			CvPoint p2;
			if (angle <=90){
				p2.x = center.x+radius*cos(angle);
				p2.y = center.y-radius*sin(angle);
			}
			else if (angle >90 && angle <= 180){
				p2.x = center.x-radius*cos(180-angle);
				p2.y = center.y-radius*sin(180-angle);
			}
			else if (angle >180 && angle <=270){
				p2.x = center.x-radius*cos(angle-180);
				p2.y = center.y+radius*sin(angle-180);
			}
			else {
				p2.x = center.x+radius*cos(360-angle);
				p2.y = center.y+radius*sin(360-angle);
			}
			cvLine(imgIplSource, center, p2, cvScalar(255, 0, 0), 1, CV_AA, 0);

			
//			CvPoint p1;
//			p1.x = center.x*
		}
	}else{
		for (int i=0; i < keypoints.size(); i++){
			KeyPoint * p = &keypoints.at(i);
			CvPoint center;
			int radius;
			center.x = cvRound(p->pt.x);
			center.y = cvRound(p->pt.y);
			radius = cvRound(p->size*1.2/9.*2);
			cvCircle(imgIplSource, center, radius, cvScalar(0, 0, 255), 1, CV_AA, 0);
			float angle = p->angle;
			CvPoint p2;
			if (angle <=90){
				p2.x = center.x+radius*cos(angle);
				p2.y = center.y-radius*sin(angle);
			}
			else if (angle >90 && angle <= 180){
				p2.x = center.x-radius*cos(180-angle);
				p2.y = center.y-radius*sin(180-angle);
			}
			else if (angle >180 && angle <=270){
				p2.x = center.x-radius*cos(angle-180);
				p2.y = center.y+radius*sin(angle-180);
			}
			else {
				p2.x = center.x+radius*cos(360-angle);
				p2.y = center.y+radius*sin(360-angle);
			}
			cvLine(imgIplSource, center, p2, cvScalar(255, 0, 0), 1, CV_AA, 0);
			
		}
	}

	imgRequetFiniCal = [self UIImageFromIplImage:imgIplSource];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LAPHOTOESTPRET" object:self];
}




#pragma mark -
#pragma mark OpenCV Support Methods


// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);
	
	return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}


#pragma mark ---------getKeyPoints-----------
-(NSArray *)getKeyPoints{
	NSMutableArray *arr = [[NSMutableArray alloc]init];
	for (int i = 0; i<keypoints.size(); i++) {
		keypoint * kp = [[keypoint alloc] init];
		[kp setX: keypoints.at(i).pt.x];
		[kp setY: keypoints.at(i).pt.y];
		NSMutableArray * desc = [[NSMutableArray alloc] init];
		for (int j = i*128; j<(i+1)*128; j++) {
			[desc addObject:[NSNumber numberWithFloat: descrpitors.at(j)]];
		}
		[kp setDescrpitors:desc];
		[kp setSize:keypoints.at(i).size];
		[kp setAngle:keypoints.at(i).angle];
		[arr addObject:kp];
	}
	return arr;
}
@end
