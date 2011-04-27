
//
//  TaskDetailsViewController.h
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskDetailsViewController : UIViewController {
	IBOutlet UILabel* date;
	IBOutlet UILabel* header;
	IBOutlet UIWebView* body;
	IBOutlet UILabel* status;
	IBOutlet UIImageView* state;
	Task* task;
	BOOL changed;
}
@property(nonatomic,retain)Task* task;
-(IBAction)backToTasksList;
-(void)initWithTask:(Task*)incommingTask;

@end
