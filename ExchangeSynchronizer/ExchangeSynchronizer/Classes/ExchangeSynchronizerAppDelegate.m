//
//  ExchangeSynchronizerAppDelegate.m
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExchangeSynchronizerAppDelegate.h"
#import "ExchangeSynchronizerViewController.h"
#import "SOAP.h"
#import "ConnectInfo.h"
@implementation ExchangeSynchronizerAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch. 
	//SOAP * soap = [[SOAP alloc]init];
//	NSLog([soap getChKeyForItem:@"AAASAEd1c2V2LkRAZGlnZGVzLmNvbQBGAAAAAAAqiCa8xJmGSJt8ne1TgJuYBwDe/ieowTsXRpVF1by0JhMRAAAAchG9AADe/ieowTsXRpVF1by0JhMRAAAAcmzxAAA="]);
/*	[soap setItemPropertyRequest:@"AAASAEd1c2V2LkRAZGlnZGVzLmNvbQBGAAAAAAAqiCa8xJmGSJt8ne1TgJuYBwDe/ieowTsXRpVF1by0JhMRAAAAchG9AADe/ieowTsXRpVF1by0JhMRAAAAcmzxAAA="
								:@"EwAAABYAAADe/ieowTsXRpVF1by0JhMRAAAAcm8e"
								:@"Task"
								:@"Status" :@"InProgress" :@"task"];
 */
	/*[soap setItemProperties:@"AAASAEd1c2V2LkRAZGlnZGVzLmNvbQBGAAAAAAAqiCa8xJmGSJt8ne1TgJuYBwDe/ieowTsXRpVF1by0JhMRAAAAchG9AADe/ieowTsXRpVF1by0JhMRAAAAcmzxAAA="
						   :[soap getChKeyForItem:@"AAASAEd1c2V2LkRAZGlnZGVzLmNvbQBGAAAAAAAqiCa8xJmGSJt8ne1TgJuYBwDe/ieowTsXRpVF1by0JhMRAAAAchG9AADe/ieowTsXRpVF1by0JhMRAAAAcmzxAAA="] 
						   :@"Test SetRequest" 
						   :@"2001-10-26T21:32:52" :@"WaitingOnOthers" :@"asdfadsfewarUKWYGCBKABVKGFKR"];*/
	
	/*[soap requestCreateItem:@"Create 123" 
						   :@"2001-10-26T21:32:52" :@"WaitingOnOthers" :@"!23asdfadsfewarUKWYGCBKABVKGFKR"];*/
    ConnectInfo *info = [[ConnectInfo alloc]init ];
    [info initNames];
    [info release];
    [navController navigationBar].hidden=YES;
	[window addSubview:navController.view];
    [window makeKeyAndVisible];
	

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	SOAP * soap = [[SOAP alloc]init];
	[soap getTaskRequest];
	[soap release];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
