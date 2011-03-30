//
//  ModuleCom.m
//  camera
//
//  Created by Fan ZHAO on 11-1-27.
//  Copyright 2011 Personne. All rights reserved.
//

#import "ModuleCom.h"


@implementation ModuleCom

+(NSString *) communiquerCaractsAvecKeypoints:(NSArray *) keypoints{
	BOOL success = YES;
	NSMutableString * xml = [self createXMLWithKeypoints:keypoints];
	
	NSMutableData * postBody = [[NSMutableData alloc] init];
	
    
	NSURL* url = [NSURL URLWithString:@"http://localhost/PFE/read.php"];
	
    
    
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:postBody];
	
    
    NSString *boundary = [NSString stringWithString:@"--------------------1dsafdsa"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"xml\"; filename=\"test.xml\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    
	NSURLResponse * response;
	NSError * err;
	
	NSData * responsedata;
	NSString *responseString = nil;
    
    NSLog(@"%d",[postBody length]);
    
    [urlRequest setTimeoutInterval:30];
    responsedata = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&err];
	
    
    
    
	if (response == nil || responsedata == nil) {
		/*
		 this is how to use UIAlertView. 
		 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; pour responde.
		 */
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Echouer" 
														message:@"Ne pouvoir pas communiquer avec le serveur"
													   delegate:self 
											  cancelButtonTitle:@"Okey" 
											  otherButtonTitles:nil];
        
        NSLog(@"%@", err);
		[alert show];
		
	}else {
        responseString = [[NSString alloc] initWithData:responsedata encoding:NSUTF8StringEncoding];
		NSLog(@"%@",responseString);
    }

	
    NSRange idx = [responseString rangeOfString:@"<Information>"];
    responseString = [responseString substringFromIndex:idx.location];
    NSLog(@"%@",responseString);
	return responseString;
}



+(NSMutableString *)createXMLWithKeypoints:(NSArray *)keypoints{
	NSMutableString * xml = [[NSMutableString alloc] init];
	[xml appendString:@"<caract>"];
	for (int i=0; i<[keypoints count]; i++) {
		keypoint * kp = [keypoints objectAtIndex:i];
		[xml appendFormat:@"<point><x>%f</x><y>%f</y>",[kp x],[kp y]];
		for (int j = 0; j<[[kp descrpitors] count]; j++) {
			[xml appendFormat:@"<d>%f</d>",[[[kp descrpitors] objectAtIndex:j]floatValue]];
		}
		[xml appendString:@"</point>"];
	}
	
	[xml appendString:@"</caract>"];
	
	
	return xml;
}
@end
