//
//  CreateTaskView.h
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreateTaskView : UIViewController {
	IBOutlet UITextView* body;
	IBOutlet UITextField* header;
	IBOutlet UILabel* dateText;
	IBOutlet UIDatePicker* datePick;
}
-(IBAction)creatingTaskDone;
@property(nonatomic,retain)UITextView* body;
@property(nonatomic,retain)UITextField* header;
@property(nonatomic,retain)UIDatePicker* datePick;
@property(nonatomic,retain)UILabel* dateText;
@end
