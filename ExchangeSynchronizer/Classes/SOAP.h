//
//  SOAP.h
//  soapCall
//
//  Created by Jos on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectInfo.h"

@interface SOAP : NSObject {
	NSMutableArray *tasksList;
	NSMutableArray *ids;
	ConnectInfo * info;
}
-(NSMutableArray*)getTaskRequest;
-(NSMutableArray*)parseFolder:(NSString *)soapString;
-(NSMutableArray*)getItemRequest:(NSMutableArray*)itemIds:(int)type_;
-(NSString*)getChKeyForItem:(NSString *)idKey;
-(NSString*)parseChKey:(NSString *)soapString;
-(void)setMessageProperties:(NSString *)idKey :(NSString *)chKey :(NSString *)status;
-(void)requestDeleteItem:(NSString *)itemId;
-(void)setItemProperties:(NSString *)idKey :(NSString *)chKey :(NSString *)subject :(NSString *)dueDate :(NSString *)status :(NSString *)Body;
-(NSMutableArray *)synchronize:(NSMutableArray *)TDB :(BOOL)isChanged;
-(NSMutableArray*)requestCreateItem:(NSString *)subject :(NSString *)dueDate :(NSString *)status :(NSString*)body;
-(NSMutableArray *)synchronize:(NSMutableArray*)TDB :(BOOL)isChanged :(NSMutableArray*) deleted;
-(void)setItemPropertyRequest:(NSString *)idKey :(NSString *)chKey :(NSString *)nS :(NSString *)propertyName :(NSString *)propertyValue :(NSString *)uriNS;
@end
