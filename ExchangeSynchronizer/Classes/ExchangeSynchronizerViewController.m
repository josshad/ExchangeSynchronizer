//
//  ExchangeSynchronizerViewController.m
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExchangeSynchronizerViewController.h"
#import "TaskDetailsViewController.h"
#import "TaskCell.h"
#import "TaskController.h"
#import "Task.h"
#import "Database.h"
#import "SOAP.h"
@implementation ExchangeSynchronizerViewController

-(void)viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskCreated:) 
                                                 name:@"TaskCreated"
                                               object:nil];
	createTaskView = [[CreateTaskView alloc] init];
	taskController = [[TaskController alloc]init];
	[taskController initTasks];
	//[taskController autoSynchronize];
   [self createSynchThread:nil];	
	[NSTimer scheduledTimerWithTimeInterval:20
									 target:self 
								   selector:@selector(createSynchThread:) 
								   userInfo:nil 
									repeats:YES];	
	[super viewDidLoad];
}
-(void)createSynchThread:(NSTimer*)timer
{
	[NSThread detachNewThreadSelector:@selector(synchronizeDate:) 
							 toTarget:self 
						   withObject:nil];

}
-(void)synchronizeDate:(NSThread*)thread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	
	[taskController autoSynchronize];
    [taskTable reloadData];
        [taskController notChanged];
	[pool release];
}
-(void)taskCreated:(NSNotification*)notification
{
	[taskController createTask:[createTaskView header].text:[createTaskView body].text:[createTaskView dateText].text];
	[popOver dismissPopoverAnimated:YES];
	[taskTable reloadData];
[taskController notChanged];
}

-(IBAction)showCreateTaskWindow
{
	if(popOver == nil)
	{
		popOver = [[UIPopoverController alloc]initWithContentViewController:createTaskView];
		[popOver setDelegate:self];
	}
	[popOver presentPopoverFromRect:CGRectMake(0,0, 300,[toolbar bounds].size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[popOver setPopoverContentSize:CGSizeMake(630, 300)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [[taskController tasks] count];
}
/*
-(void)synchronizeDateMust:(NSThread*)thread
{
    	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	[taskController synchronize];
	[taskTable reloadData];
    [pool release];
}*/

-(IBAction)synchronize
{
    [NSThread detachNewThreadSelector:@selector(synchronizeDate:) 
							 toTarget:self 
						   withObject:nil];

}
//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	CellIdentifier = @"taskViewCell";
	TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
	{
		
		[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
		cell = tblCell;
		tblCell = nil;
	}
	if([[[[taskController tasks] objectAtIndex:indexPath.row]finishDate] compare:@""]!=NSOrderedSame)
		cell.date.text = [[[[[taskController tasks] objectAtIndex:indexPath.row]finishDate]stringByReplacingOccurrencesOfString:@"T" withString:@"  "] 
						  stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	else {
		cell.date.text = @"None";
	}

	cell.header.text = [[[taskController tasks] objectAtIndex:indexPath.row]header];
	if([[[[taskController tasks] objectAtIndex:indexPath.row]status]compare:@"Completed"]==NSOrderedSame)
    {
		[cell changeState]; 
        [cell.segmentButton setSelectedSegmentIndex:0];

        [cell.segmentButton setEnabled:NO forSegmentAtIndex:2];
    }
    else{
        if([[[[taskController tasks] objectAtIndex:indexPath.row]status]compare:@"InProgress"]==NSOrderedSame)
        [cell.segmentButton setSelectedSegmentIndex:1];
        else
            [cell.segmentButton setSelectedSegmentIndex:2];
        
    }
          [taskController notChanged];
	return cell;

}
-(TaskDetailsViewController *)taskDetailsView {
    if (taskDetailsView == nil) {
        taskDetailsView = [[TaskDetailsViewController alloc] initWithNibName:@"TaskDetailsViewController" bundle:nil];
    }
    return taskDetailsView;
}

-(IBAction)deleteCell:(id)sender
{
	NSIndexPath *indexPath = [taskTable indexPathForCell:(TaskCell *)[[sender superview] superview]];
	if([sender selectedSegmentIndex]==3){
    [taskController deleteTask:indexPath.row];
        [taskTable reloadData];
         }
	if([sender selectedSegmentIndex]==2){
		[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"NotStarted"];
        [[[[sender superview] superview] status] setImage:[UIImage imageNamed:@"status_prosroch.png"]]; 
    }
	if([sender selectedSegmentIndex]==1){
		[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"InProgress"];
          [[[[sender superview] superview] status] setImage:[UIImage imageNamed:@"status_prosroch.png"]]; 
   //[sender setSelectedSegmentIndex:1];
    }
	if([sender selectedSegmentIndex]==0){
        [sender setEnabled:NO forSegmentAtIndex:2];
          [[[[sender superview] superview] status] setImage:[UIImage imageNamed:@"status_norm.png"]]; 
		[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"Completed"];
   //[sender setSelectedSegmentIndex:0];
}
}

- (void)tableView: (UITableView *)tableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	[[self navigationController] pushViewController:self.taskDetailsView animated:YES];	
	[self.taskDetailsView initWithTask:[[taskController tasks] objectAtIndex:indexPath.row]];
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



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
	[popOver release];
	[taskController release];
    [super dealloc];
}

@end
