//
//  Task.h
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Task : NSObject {
	int type;
	NSInteger primaryKey;
	NSString* header;
	NSString* body;
	NSString* finishDate;
	NSString* dateCreated;
	NSString* status;
	NSString* lastUpdate;
	NSString* mailFrom;
	NSString* mailDate;
	NSString* pKeyFromXML;
	NSString* changeKey;
	BOOL changed;
}
@property(nonatomic, assign)NSInteger primaryKey;
@property(nonatomic, retain)NSString* header;
@property(nonatomic, retain)NSString* body;
@property(nonatomic, retain)NSString* finishDate;
@property(nonatomic, retain)NSString* dateCreated;
@property(nonatomic, retain)NSString* lastUpdate;
@property(nonatomic, retain)NSString* mailFrom;
@property(nonatomic, retain)NSString* mailDate;
@property(nonatomic, retain)NSString* status;
@property(nonatomic, retain)NSString* pKeyFromXML;
@property(nonatomic, retain)NSString* changeKey;
@property(nonatomic, assign)int type;
@property(nonatomic, assign)BOOL changed;
-(id)initWithIdentifier:(NSInteger)idKey :(sqlite3 *)db;
-(void)setKey:(NSInteger)pKey;
-(void)setNewState:(NSString*)stat;
-(id)initWithString:(NSString *)response :(NSString*)pKey :(int)type_;
@end
