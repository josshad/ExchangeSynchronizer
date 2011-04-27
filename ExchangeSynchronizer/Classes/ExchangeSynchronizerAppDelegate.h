//
//  ExchangeSynchronizerAppDelegate.h
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExchangeSynchronizerViewController;

@interface ExchangeSynchronizerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UINavigationController* navController;
    ExchangeSynchronizerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ExchangeSynchronizerViewController *viewController;

@end

