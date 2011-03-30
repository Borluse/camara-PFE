//
//  ModuleRF.h
//  camera
//
//  Created by Fan ZHAO on 11-1-13.
//  Copyright 2011 Personne. All rights reserved.
//
#include <opencv2/opencv.hpp>
//#include <opencv/cv.h>
//#include <opencv/cxcore.hpp>
#include <opencv2/core/types_c.h>
#include <opencv2/core/mat.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#import <Foundation/Foundation.h>
#import "keypoint.h"

@interface ModuleRF : NSObject {
	IplImage * imgRequet;
	UIImage * imgRequetFiniCal;
	IplImage * imgIplSource;
	int algochoix;
	std::vector<cv::KeyPoint> keypoints;
	std::vector<float> descrpitors;
	cv::Mat descripSift;
	int num;
	int nbKeyPoints;
}

@property (assign) int algochoix;
@property (assign) int nbKeyPoints;
@property (assign) std::vector<cv::KeyPoint> keypoints;
@property (assign) std::vector<float> descrpitors;
@property (assign) int num;
@property (retain) UIImage * imgRequetFiniCal;
//@property (copy) 	IplImage * imgRequetFiniCal;
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image;

-(std::vector<cv::KeyPoint> *) returnKeypoint;
-(std::vector<float> *) returnDescrpitor;
@end
