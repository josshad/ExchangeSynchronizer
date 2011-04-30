//
//  TaskCell.h
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TaskCell : UITableViewCell {
	IBOutlet UILabel* header;
	IBOutlet UILabel* date;
	IBOutlet UIImageView* status;
    IBOutlet UISegmentedControl* segmentButton;
}
@property(nonatomic, retain)UILabel* header;
@property(nonatomic, retain)UISegmentedControl* segmentButton;
@property(nonatomic, retain)UILabel* date;
@property(nonatomic, retain)UIImageView* status;
-(void)changeState;


@end
