    //
//  CreateTaskView.m
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateTaskView.h"


@implementation CreateTaskView
@synthesize body,header, dateText, datePick;
-(IBAction)creatingTaskDone
{
	if([header.text compare:@""]!=NSOrderedSame)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"TaskCreated" object:self];
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

-(void)viewDidAppear:(BOOL)animated
{
	body.text =@"";
	header.text = @"";
	dateText.text = @"";
	[datePick addTarget:self action:@selector(dateChanged:) 
	 forControlEvents:UIControlEventValueChanged];
	[datePick setDate:[NSDate date]];
	dateText.text = [[[datePick date] description]substringToIndex:19];

}
- (void) dateChanged:(id)sender{
	dateText.text = [[[datePick date] description]substringToIndex:19];
}

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
    [super dealloc];
}


@end
