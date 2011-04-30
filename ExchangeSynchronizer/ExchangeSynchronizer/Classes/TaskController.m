//
//  TaskController.m
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskController.h"
#import "Database.h"
#import "ConnectInfo.h"
#import "SOAP.h"
#import "Task.h"
#import <sqlite3.h>
@implementation TaskController
@synthesize tasks, database, changed,deleteTasks;

// изменение состояния задачи и одновременно обновление бд
-(void)refresh:(NSInteger)pKey:(NSString*)stat
{

	[database update:@"STATE" :stat :pKey];
	[database update:@"CHANGED" :@"YES" :pKey];
	changed = YES;
	for(int i=0;i<[tasks count];i++)
		if([[tasks objectAtIndex:i] primaryKey] == pKey)
		{
			[[tasks objectAtIndex:i] setNewState:stat];
			break;
		}
}
-(NSMutableArray*)getFolderTasks:(NSString*)folder
{
	NSMutableArray* currentTasks = [[NSMutableArray alloc]init];
	for(int i=0;i<[tasks count];i++)
		if([[[tasks objectAtIndex:i] folder]compare:folder]==NSOrderedSame)
			[currentTasks addObject:[tasks objectAtIndex:i]];
	[currentTasks autorelease];
	return currentTasks;
}
-(void)deleteTask:(NSInteger)taskKey
{
	NSInteger index=-1;
	for(int i=0;i<[tasks count];i++)
		if([[tasks objectAtIndex:i] primaryKey] == taskKey)
		{
			index = i;
			break;
		}
	if(index!=-1)
	{
		[self.deleteTasks addObject:[[tasks objectAtIndex:index]pKeyFromXML]];
		[database deleteTask:[[tasks objectAtIndex:index]primaryKey]];
		[tasks removeObjectAtIndex:index];
		changed = YES;
	}
}

// загрузка задач из базы 
-(void)initTasks
{
    connInfo = [[ConnectInfo alloc]init];
    [connInfo initNames];
	deleteTasks = [[NSMutableArray alloc]init];
	if(database == nil)
	{
		database = [[Database alloc]init];
		[database createDatabase];
	}
	//tasks = [[NSMutableArray alloc]init];
	tasks = [database loadTasks:connInfo.login];
}


//автоматическая синхронизация (взаимный обмен)
-(void)autoSynchronize
{	
	NSMutableArray* copyTask;//= [[NSMutableArray alloc]init];
	SOAP * soap = [[SOAP alloc]init];

	copyTask = [soap synchronize:tasks :changed :deleteTasks];
	changed = NO;
	if(copyTask != nil)
	{
		
		for(int i=0;i<[tasks count];i++)
			[database deleteTask:[[tasks objectAtIndex:i]primaryKey]];
		tasks = nil;
		tasks = copyTask;
		for(int i=0;i<[tasks count];i++)
			[[tasks objectAtIndex:i] setKey:[database insert:[tasks objectAtIndex:i]:[connInfo login]] ];
	}
	copyTask = nil;
    [soap release];	
}
-(void)createTask:(NSString*)header:(NSString*)body:(NSString*)dateFinish:(NSString*)folder
{
	if(header!=nil)
	{
		changed = YES;
		Task* task = [[Task alloc]init];
		
		task.finishDate = [[dateFinish stringByReplacingOccurrencesOfString:@" " withString:@"T"]stringByAppendingString:@"Z"];
		task.header = header;
		task.body = body;
		task.folder = folder;
		NSDate *now = [NSDate date];
		NSString *strNow = [now description];
		task.dateCreated = strNow;
		task.status = @"NotStarted";
		task.changed = YES;
		task.pKeyFromXML =@"";
        task.changeKey =@"";
		NSInteger pKey = [database insert:task :[connInfo login]];
		task.primaryKey = pKey;
		task.type = 1;       
		
		[tasks addObject:task];
		[task release];
	}
}
-(void)dealloc
{
	[tasks release];
    [deleteTasks release];
  
	[super dealloc];
}
@end
