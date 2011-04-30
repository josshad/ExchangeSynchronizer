//
//  Task.m
//  ExchangeSynchronizer
//
//  Created by Илья on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "Database.h"
#import "TouchXML.h"
#import "SOAP.h"
@implementation Task
@synthesize  changed, type,dateCreated,folder,body,header, primaryKey,status,pKeyFromXML,changeKey,finishDate;

// помечаем задачу измененной
-(void)setNewState:(NSString*)stat
{
	self.status = stat;
	self.changed = YES;
}
-(void)setKey:(NSInteger)pKey
{
	self.primaryKey = pKey;
}
-(id)initWithIdentifier:(NSInteger)idKey :(sqlite3 *)db {
    if (self = [super init]) {
		primaryKey = idKey;
		
		Database *database = [[Database alloc] init];	
		self.header = [database performRequest: @"SELECT HEADER FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc] init];	
		self.folder = [database performRequest: @"SELECT FOLDER FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc]init];
		self.body = [database performRequest: @"SELECT BODY FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc]init];
		self.dateCreated = [database performRequest: @"SELECT DATE FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc] init];
		self.status = [database performRequest: @"SELECT STATE FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc] init];
		self.pKeyFromXML = [database performRequest: @"SELECT PKEYXML FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc] init];
		self.changeKey = [database performRequest: @"SELECT CHANGEKEY FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
		database = [[Database alloc] init];
		self.finishDate = [database performRequest: @"SELECT DATEFINISH FROM Tasks WHERE ID=?" :primaryKey :db];
		[database release];
        database = [[Database alloc] init];
		self.type = [[database performRequest: @"SELECT TYPETASK FROM Tasks WHERE ID=?" :primaryKey :db] intValue];
		[database release];
		database = [[Database alloc] init];
		if( [[database performRequest: @"SELECT CHANGED FROM Tasks WHERE ID=?" :primaryKey :db] compare:@"YES"]==NSOrderedSame)
			self.changed = YES;
		else self.changed = NO;
		[database release];
	}
	
	
    return self;
}
-(id)initWithString:(NSString*)response:(NSString*)pKey:(int)type_{
    //NSLog(@"%@", response);
    if (self = [super init]) {
		//NSLog(@"%@", response);
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:response options:0 error:nil] autorelease];
		NSArray *nodes = NULL;
		nodes = [doc nodesForXPath:@"//*[local-name()='Subject']" error:nil];	
		if ([nodes count] != 1)
		{ self.header =@"-";}
		else {
			self.header = [[nodes objectAtIndex:0] stringValue];
			
			}
		nodes = NULL;
		nodes = [doc nodesForXPath:@"//*[local-name()='DateTimeCreated']" error:nil];	
		if ([nodes count] != 1)
		{ self.dateCreated =@"-";}
		else {
			self.dateCreated = [[nodes objectAtIndex:0] stringValue];
		}
		nodes = NULL;
		if (type_ == 1)
		{
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='Body']"
 error:nil];	
		if ([nodes count] != 1)
		{ self.body =@"-";}
		else {
			self.body = [[nodes objectAtIndex:0] stringValue];
		}
		nodes = NULL;
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='Status']" error:nil];	
		if ([nodes count] != 1)
		{ self.status =@"-";}
		else {

			self.status = [[nodes objectAtIndex:0] stringValue];
		}
		nodes = NULL;
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='DueDate']" error:nil];	
		if ([nodes count] != 1)
		{ self.finishDate =@"";}
		else {
			
			self.finishDate = [[nodes objectAtIndex:0] stringValue];
		}
		nodes = NULL;
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='ItemId']" error:nil];	
		if ([nodes count] != 1)
		{ self.changeKey =nil;}
		else {
			
			self.changeKey = [[[nodes objectAtIndex:0] attributeForName:@"ChangeKey"] stringValue];
		}
		}
		else {
			nodes = [doc nodesForXPath:@"//*[local-name()='Message']/*[local-name()='Body']"
								 error:nil];	
			if ([nodes count] != 1)
			{ self.body =@"-";}
			else {
				self.body = [[nodes objectAtIndex:0] stringValue];
			}
			nodes = NULL;
			
			nodes = [doc nodesForXPath:@"//*[local-name()='Message']/*[local-name()='ItemId']" error:nil];	
			if ([nodes count] != 1)
			{ self.changeKey =nil;}
			else {
				
				self.changeKey = [[[nodes objectAtIndex:0] attributeForName:@"ChangeKey"] stringValue];
			}
			nodes = [doc nodesForXPath:@"//*[local-name()='ExtendedProperty']/*[local-name()='Value']" error:nil];	
			if ([nodes count] < 1)
			{ }
			else {
				for (int i=0;i<[nodes count];i++){
				if ([[[nodes objectAtIndex:i] stringValue] isEqualToString :@"2"])
				{
				self.status=@"InProgress";}
				else{
				if ([[[nodes objectAtIndex:i] stringValue] isEqualToString :@"1"])
				{self.status=@"Completed";}
					else self.finishDate = [[nodes objectAtIndex:i] stringValue];				}
				}
			}
		}

        self.type = type_;
		nodes = NULL;
		self.folder = @"ALL";
		self.changed = NO;
		self.pKeyFromXML = pKey;
	}
	
    return self;
}
-(void)dealloc
{

	[header release];
	[body release];
	[finishDate release];
	[status release];
	[folder release];
	[changeKey release];
	[pKeyFromXML release];
	[super dealloc];
}

@end
