//
//  ExchangeSynchronizerViewController.h
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailsViewController.h"
#import "TaskCell.h"
#import "TaskController.h"
#import "CreateTaskView.h"
#import "Database.h"
@interface ExchangeSynchronizerViewController : UIViewController {
	IBOutlet UITableView* taskTable;
	IBOutlet TaskCell* tblCell;
	TaskDetailsViewController* taskDetailsView;
	TaskController* taskController;
	CreateTaskView *createTaskView;
	UIPopoverController *popOver;
	IBOutlet UIToolbar* toolbar;
	Database* taskDB;
	
}
-(IBAction)deleteCell:(id)sender;
-(IBAction)synchronize;
-(IBAction)showCreateTaskWindow;
@end

