    //
//  TaskDetailsViewController.m
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import "SOAP.h"
#import "Task.h"


@implementation TaskDetailsViewController
@synthesize task, date,status,body ,header;
-(IBAction)backToTasksList
{

	[[self navigationController]popViewControllerAnimated:YES];
}
-(void)initWithTask:(Task*)incommingTask
{
	[super init];
	task = incommingTask ;
	if([[task finishDate] compare:@""]!=NSOrderedSame)

		date.text =[[[task finishDate]stringByReplacingOccurrencesOfString:@"T" withString:@"  "] 
		stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	else {
		date.text = @"None";
	}

	header.text = [task header];
	[body loadHTMLString:[task body] baseURL:[NSURL URLWithString:@""]];
	status.text = [task status];

}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[task release];
    [super dealloc];
}


@end
