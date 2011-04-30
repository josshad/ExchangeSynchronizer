//
//  FolderTableViewController.h
//  ExchangeSynchronizer
//
//  Created by Илья on 29.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderTableViewController : UITableViewController {
	NSMutableArray* folders;
	NSString* currentFolder;
}
@property(retain, nonatomic)NSString* currentFolder;
-(void)initFolder;
@end
