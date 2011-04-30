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
	mark = NO;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskCreated:) 
                                                 name:@"TaskCreated"
                                               object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(folderChanged:) 
                                                 name:@"FolderChanged"
                                               object:nil];
	createTaskView = [[CreateTaskView alloc] init];
	taskController = [[TaskController alloc]init];
	taskDetailsView  = [[TaskDetailsViewController alloc]initWithNibName:@"TaskDetailsViewController" bundle:nil];
	folderTableController = [[FolderTableViewController alloc]init];
	folderTable.delegate = folderTableController;
	folderTable.dataSource = folderTableController;
	folderTableController.view = folderTableController.tableView;
	[folderTableController initFolder];
	[taskController initTasks];
	currentTasks = [[taskController getFolderTasks:[folderTableController currentFolder]]copy ];

    [NSThread detachNewThreadSelector:@selector(synchronizeDate:) 
							 toTarget:self 
						   withObject:nil];
	[super viewDidLoad];


}
-(void) updateTableItems 
{
	[taskTable reloadData];
}
-(void)folderChanged:(NSNotification*)notification
{
	currentTasks = nil;
	currentTasks = [[taskController getFolderTasks:[folderTableController currentFolder]]copy ];
	[taskTable reloadData];
}
-(void)synchronizeDate:(NSThread*)thread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	while(1)
	{
		[NSThread sleepForTimeInterval:1];
		[taskController autoSynchronize];
		if(currentTasks != nil) currentTasks = nil;
			currentTasks = [[taskController getFolderTasks:[folderTableController currentFolder]]copy ];
		[self performSelectorOnMainThread:@selector(updateTableItems) withObject:nil waitUntilDone:NO];
		[NSThread sleepForTimeInterval:15];
	}
	[pool release];
}
-(void)taskCreated:(NSNotification*)notification
{
	[taskController createTask:[createTaskView header].text:[createTaskView body].text:[createTaskView dateText].text:[folderTableController currentFolder]];
	currentTasks = nil;
		currentTasks = [[taskController getFolderTasks:[folderTableController currentFolder]]copy ];
	[createPopover dismissPopoverAnimated:YES];
	[taskTable reloadData];
}

-(IBAction)showCreateTaskWindow
{
	if(createPopover == nil)
	{
		createPopover = [[UIPopoverController alloc]initWithContentViewController:createTaskView];
		[createPopover setDelegate:self];
	}
	[createPopover presentPopoverFromRect:CGRectMake(965, 0, 0, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp  animated:YES];
	[createPopover setPopoverContentSize:CGSizeMake(630, 300)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [currentTasks count];
}

//RootViewController.m
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	mark =YES;
	CellIdentifier = @"taskViewCell";
	TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil)
	{
		
		[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
		cell = tblCell;
		tblCell = nil;
	}
	[cell.header setComplete:NO];
	if([[[currentTasks objectAtIndex:indexPath.row]finishDate] compare:@""]!=NSOrderedSame)
		cell.date.text = [[[[currentTasks objectAtIndex:indexPath.row]finishDate]stringByReplacingOccurrencesOfString:@"T" withString:@"  "] 
						  stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	else {
		cell.date.text = @"None";
	}

	cell.header.text = [[currentTasks objectAtIndex:indexPath.row]header];
	if([[[currentTasks objectAtIndex:indexPath.row]status]compare:@"Completed"]==NSOrderedSame)
    {
		[cell changeState]; 
        [cell.segmentButton setSelectedSegmentIndex:0];
		[cell.header setComplete:YES];
        [cell.segmentButton setEnabled:NO forSegmentAtIndex:2];
    }
    else{
        if([[[currentTasks  objectAtIndex:indexPath.row]status]compare:@"InProgress"]==NSOrderedSame)
        [cell.segmentButton setSelectedSegmentIndex:1];
        else
            [cell.segmentButton setSelectedSegmentIndex:2];
        
    }
	mark = NO;
	
	return cell;

}

-(IBAction)deleteCell:(id)sender
{
	
	if(!mark)
	{
		NSIndexPath *indexPath = [taskTable indexPathForCell:(TaskCell *)[[sender superview] superview]];
		if([sender selectedSegmentIndex]==3){
			[taskController deleteTask:[[currentTasks objectAtIndex:indexPath.row]primaryKey]];
			currentTasks = nil;
			currentTasks = [[taskController getFolderTasks:[folderTableController currentFolder]]copy ];
			[taskTable reloadData];
		}
		if([sender selectedSegmentIndex]==2){
			[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"NotStarted"];
			[[[[sender superview] superview] header]setComplete:NO];
			[[[[sender superview] superview] header]setNeedsDisplay];
		}
		if([sender selectedSegmentIndex]==1){
			[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"InProgress"];
			[[[[sender superview] superview] header]setComplete:NO];
			[[[[sender superview] superview] header]setNeedsDisplay];
		}
		if([sender selectedSegmentIndex]==0){
			[sender setEnabled:NO forSegmentAtIndex:2];
			[taskController refresh:[[[taskController tasks]objectAtIndex:indexPath.row]primaryKey]:@"Completed"];
			[[[[sender superview] superview] header]setComplete:YES];
			[[[[sender superview] superview] header]setNeedsDisplay];
		}
	}
}

- (void)tableView: (UITableView *)tableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	if(detailsPopover == nil)
	{
		detailsPopover = [[UIPopoverController alloc]initWithContentViewController:taskDetailsView];
		[detailsPopover setDelegate:self];
	}
	[taskDetailsView initWithTask:[currentTasks objectAtIndex:indexPath.row]];
	[detailsPopover presentPopoverFromRect:CGRectMake(0, 80, 385, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[detailsPopover setPopoverContentSize:CGSizeMake(320, 590)];

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
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		return YES;
	if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
    return NO;
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
	[createPopover release];
	[detailsPopover release];
	[createTaskView release];
	[currentTasks release];
	[taskDetailsView release];
	[folderTableController release];
	[taskController release];
    [super dealloc];
}

@end
