//
//  TaskController.h
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Database.h"
#import "ConnectInfo.h"

@interface TaskController : NSObject {
	NSMutableArray* tasks;
	Database* database;
	NSMutableArray *deleteTasks;
	BOOL changed;
    ConnectInfo *connInfo;
}
@property(nonatomic,retain)NSMutableArray* tasks;
@property(nonatomic,retain)NSMutableArray* deleteTasks;
@property(nonatomic,retain)Database* database;
@property(nonatomic,assign)BOOL changed;
-(void)createTask:(NSString*)header:(NSString*)body:(NSString*)dateFinish;
-(void)refresh:(NSInteger)pKey:(NSString*)stat;
-(void)deleteTask:(NSInteger)taskIndex;
-(void)notChanged;
-(void)initTasks;
-(void)synchronize;
-(void)autoSynchronize;
@end
