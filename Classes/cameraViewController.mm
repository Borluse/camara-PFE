//
//  cameraViewController.m
//  camera
//
//  Created by Borluse on 25/11/10.
//  Copyright Personne 2010. All rights reserved.
//

#import "cameraViewController.h"
#import "ModuleCom.h"
//#import "ModuleRF.h"


@implementation cameraViewController
@synthesize buttonCamera;
@synthesize imgView;
@synthesize algoChoixSegment;
@synthesize timer1,timer2;

//@synthesize rf;


- (id) init{
	if ((self = [super init])){
		rf = [[ModuleRF alloc] init];
		[rf setAlgochoix:1];

//	[rf addObserver:self forKeyPath:@"imgRequetFiniCal" options:NSKeyValueObservingOptionNew context:NULL];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(photoPres:)
													 name:@"LAPHOTOESTPRET"
												   object:nil];
	}
	return self;
}

- (void)photoPres:(NSNotification *)notification{
	ModuleRF *rf1 = [notification object];
	NSLog(@"hello");
	self.imgView.image = [rf1 valueForKey:@"imgRequetFiniCal"];
	timer2 = [NSDate date];
	double temps = [timer2 timeIntervalSinceDate:timer1];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Résultat" message:[NSString stringWithFormat:@"Temps de calcul: %f \n Nombre de points : %d \n Nombre de descrpiteurs: %d", temps ,[rf1 nbKeyPoints], [rf1 num]]
												   delegate:self cancelButtonTitle:@"Okey" otherButtonTitles:nil];
	
	[alert show];
}
-(IBAction) makeChoix{
    if (algoChoixSegment.selectedSegmentIndex == 0){
		NSLog(@"1");
        [rf setAlgochoix:1];
    }else {
		NSLog(@"0");
		[rf setAlgochoix:0];
	}

}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (BOOL)respondsToSelector:(SEL)aSelector {
	NSString *methodName = NSStringFromSelector(aSelector);
	NSLog(@"respondsToSelector:%@", methodName); 
	return [super respondsToSelector:aSelector];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
	[buttonCamera release];
	[rf release];
	[imageFini release];
	[image release];
	[imgView release];
    [algoChoixSegment release];
    [super dealloc];

}


/*-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	NSLog(@"hello");
	UIImage *image1 = [object valueForKey:keyPath];
	self.imgView.image = image1;
}*/


#pragma mark -
#pragma mark User has choosen a photo.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
	
	[picker release];
	[self dismissModalViewControllerAnimated:YES];
	imageFini = [[UIImage alloc] init];
	[rf changerImg:image];
	timer1 = [NSDate date];
	[rf calculerCaractsSurPhoto];
	
	image = [rf valueForKey:@"imgRequetFiniCal"];
		
}
#pragma mark -
#pragma mark prendrePhotoAvecCamera

- (IBAction) prendrePhotoExiste{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
		UIImagePickerController *ip = [[UIImagePickerController alloc] init];
		ip.delegate = self;
		ip.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:ip animated:YES];
	}
}
#pragma mark prendrePhotoExiste 
-(IBAction) prendrePhotoAvecCamera{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		UIImagePickerController *ip = [[UIImagePickerController alloc] init];
		ip.delegate = self;
		ip.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:ip animated:YES];		
	}
	else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera indisponible" message:@"Vrais" delegate:self cancelButtonTitle:@"Retourne" otherButtonTitles:nil];
		[alert show];
	}
}
#pragma mark -
#pragma mark ------delegate--------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"%d",buttonIndex);
    NSString *resultat;
	if ((resultat = [ModuleCom communiquerCaractsAvecKeypoints:[rf getKeyPoints]])!=nil){
        
    }
}

#pragma mark TODO:
/*
	La partie caméra n'est pas encore fini. Il reste un délégate à faire. 
 */

@end
