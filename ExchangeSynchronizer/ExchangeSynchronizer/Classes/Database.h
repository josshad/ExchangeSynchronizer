//
//  Database.h
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Task.h"
@interface Database : NSObject {
	sqlite3* db;
	NSString* pathToDB;
	NSString* retStr;
	NSMutableArray* listOfIds;
}
-(void)update:(NSString*)property:(NSString*)value:(NSInteger)pKey;
-(NSString *) performRequest: (NSString *)query :(NSInteger)key :(sqlite3 *) database;
-(NSInteger)insert:(Task*)task:(NSString*)login;
-(NSMutableArray*)loadTasks:(NSString*)login;
-(void)createDatabase;
-(void)deleteTask:(NSInteger)pKey;
@end
