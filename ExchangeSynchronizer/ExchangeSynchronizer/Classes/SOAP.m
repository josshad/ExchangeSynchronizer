//
//  SOAP.m
//  soapCall
//
//  Created by Jos on 14.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SOAP.h"
#import "ASIHTTPRequest.h"
#import "TouchXML.h"
#import "Task.h"
#import "ConnectInfo.h"
@implementation SOAP

//Р РµРєРІРµСЃС‚ Р±РµСЂСѓС‰РёР№ СЃРїРёСЃРѕРє Р°Р№РґРё РІ РїР°РїРєРµ
-(NSMutableArray*) getTaskRequest
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	
	NSString *soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<FindItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\" Traversal=\"Shallow\">"
							 "\n<ItemShape>"
							 "\n<t:BaseShape>IdOnly</t:BaseShape>"
							 "\n</ItemShape>"
							 "\n<ParentFolderIds>"
							 "\n<t:DistinguishedFolderId Id=\"tasks\"/>"
							 "\n</ParentFolderIds>"
							 "\n</FindItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>"];
	
	
	
	ASIHTTPRequest *requestFind = [ASIHTTPRequest requestWithURL:url];
	
	if ([info password] != nil)[requestFind setPassword:[info password]];
	else [requestFind setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [requestFind setUsername:[info login]];
	else [requestFind setUsername:@"gusev.d"];
	
	[requestFind appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[requestFind addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[requestFind startSynchronous];
	NSError *error = [requestFind error];
	if (!error) {
		[error release];
		NSString * response = [requestFind responseString];
		
		NSMutableArray *folderID = [self parseFolder:response];
		NSMutableArray *retTasks = [[NSMutableArray alloc] initWithArray:[[self getItemRequest:folderID:1] copy]];
		
		
		NSString *soapMessageM = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
								 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
								 "\n<soap:Body>"
								 "\n<FindItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\" Traversal=\"Shallow\">"
								 "\n<ItemShape>"
								 "\n<t:BaseShape>IdOnly</t:BaseShape>"
								 "\n</ItemShape>"
								 "\n<ParentFolderIds>"
								 "\n<t:DistinguishedFolderId Id=\"inbox\"/>"
								 "\n</ParentFolderIds>"
								 "\n</FindItem>"
								 "\n</soap:Body>"
								 "\n</soap:Envelope>"];
		
		
		
		ASIHTTPRequest *requestFindM = [ASIHTTPRequest requestWithURL:url];
		if ([info password] != nil)[requestFindM setPassword:[info password]];
		else [requestFind setPassword:@"p@ssw0rd"];
		if ([info login]!= nil) [requestFindM setUsername:[info login]];
		else [requestFind setUsername:@"gusev.d"];
		
		[requestFindM appendPostData:[soapMessageM dataUsingEncoding:NSUTF8StringEncoding]];
		[requestFindM addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
		[requestFindM startSynchronous];
		NSError *error1 = [requestFindM error];
		if(!error1)
		{
			
			NSString * response1 = [requestFindM responseString];
		//	NSLog(response1);
			/*for (NSString * str in [self parseFolder:response1])
			 {
			 [folderID addObject:str];
			 }*/
			NSMutableArray *Mess =  [self getItemRequest:[self parseFolder:response1]:2];
            for (Task * mess in Mess)
            {
                [retTasks addObject:mess];
            }
			// [Mess release];
		}
		
		[url release];
		return retTasks;	
		
	}
	
	else 
	{
		[url release];
		return nil;
	}
}
/*
 idKey - item's Id
 chKey - item's ChangeKey
 nS - item type (Message, Task, Contacts etc.)
 propertyName - name of changed property
 propertyValue - replace value
 uriNS - namespace of uri (message,task,contacts etc.)
 */
-(void) setItemPropertyRequest:(NSString*)idKey :(NSString*)chKey :(NSString*)nS :(NSString*)propertyName :(NSString *)propertyValue :(NSString*)uriNS 
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<UpdateItem MessageDisposition=\"SaveOnly\" ConflictResolution=\"AutoResolve\" xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\">"
							 "\n<ItemChanges>"
							 "\n<t:ItemChange>"
							 "\n<t:ItemId Id=\"%@\" ChangeKey=\"%@\"/>"
							 "\n<t:Updates>"
							 "\n<t:SetItemField>"
							 "\n<t:FieldURI FieldURI=\"%@:%@\"/>"
							 "\n<t:%@>"
							 "\n<t:%@>%@</t:%@>"
							 "\n</t:%@>"
							 "\n</t:SetItemField>"
							 "\n</t:Updates>"
							 "\n</t:ItemChange>"
							 "\n</ItemChanges>"
							 "\n</UpdateItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",idKey,chKey,uriNS, propertyName,nS,propertyName,propertyValue,propertyName,nS];
	
	ASIHTTPRequest *requestSet = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[requestSet setPassword:[info password]];
	else [requestSet setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [requestSet setUsername:[info login]];
	else [requestSet setUsername:@"gusev.d"];
	
	[requestSet appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[requestSet addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[requestSet setDelegate:self];
	//NSLog(@"%@", soapMessage);
	
	[requestSet startAsynchronous];
	[url release];
}
//СЂРµРєРІРµСЃС‚ РґР°СЋС‰РёР№ С‡РєРµР№ Р°Р№С‚РµРјР° РїРѕ Р°Р№РґРё
-(NSString*)getChKeyForItem:(NSString*)idKey
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 // "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<GetItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<ItemShape>"
							 "\n<t:BaseShape>AllProperties</t:BaseShape>"
							 "\n</ItemShape>"
							 "\n<ItemIds>"
							 "\n<t:ItemId Id=\"%@\"/>"
							 "\n</ItemIds>"
							 "\n</GetItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",idKey];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[request setPassword:[info password]];
	else [request setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [request setUsername:[info login]];
	else [request setUsername:@"gusev.d"];
	
	[request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[request startSynchronous];
	NSError *error = [request error];
	
	if (!error) {
		NSString * tasks = [self parseChKey:[request responseString]];
		[url release];
		return tasks;
	}
	
	else {
		[url release];
		return nil;
	}
	
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	//NSString *responseString = [request responseString];
	
	//NSLog(@"executed");
	//NSLog(responseString);
}


//Р РµРєРІРµСЃС‚ РґР»СЏ РІР·СЏС‚РёСЏ Р°Р№С‚РµРјР°
-(NSMutableArray*)getItemRequest:(NSMutableArray*)itemIds:(int)type_
{
	if (tasksList !=nil) [tasksList release];
	tasksList = [[NSMutableArray alloc]init];
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	if (type_ == 1)
	{
		for (NSString *str in itemIds)
		{
			
			NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
									 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
									 "\n<soap:Body>"
									 "\n<GetItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
									 "\n<ItemShape>"
									 "\n<t:BaseShape>AllProperties</t:BaseShape>"
									 "\n</ItemShape>"
									 "\n<ItemIds>"
									 "\n<t:ItemId Id=\"%@\"/>"
									 "\n</ItemIds>"
									 "\n</GetItem>"
									 "\n</soap:Body>"
									 "\n</soap:Envelope>",str];
			
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
			if ([info password] != nil)[request setPassword:[info password]];
			else [request setPassword:@"p@ssw0rd"];
			if ([info login]!= nil) [request setUsername:[info login]];
			else [request setUsername:@"gusev.d"];
			
			[request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
			[request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
			[request startSynchronous];
			NSError *error = [request error];
			
			if (!error) {
				NSString *response = [request responseString];
				
				Task* task = [[Task alloc] initWithString:response:str:type_];
				[tasksList addObject: task];
				[task release];
				
			}
		}
		
	}
	if (type_ == 2)
	{
		for (NSString *str in itemIds)
		{
			NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
									 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
									 "\n<soap:Body>"
									 "\n<GetItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
									 "\n<ItemShape>"
									 "\n<t:BaseShape>AllProperties</t:BaseShape>"
									 "\n<t:AdditionalProperties>"
									 "\n<t:ExtendedFieldURI PropertyTag=\"0x1090\" PropertyType=\"Integer\"/>"
									 "\n<t:ExtendedFieldURI PropertyTag=\"0x1091\" PropertyType=\"SystemTime\"/>"
									 "\n</t:AdditionalProperties>"
									 "\n</ItemShape>"
									 "\n<ItemIds>"
									 "\n<t:ItemId Id=\"%@\"/>"
									 "\n</ItemIds>"
									 "\n</GetItem>"
									 "\n</soap:Body>"
									 "\n</soap:Envelope>",str];
			
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
			if ([info password] != nil)[request setPassword:[info password]];
			else [request setPassword:@"p@ssw0rd"];
			if ([info login]!= nil) [request setUsername:[info login]];
			else [request setUsername:@"gusev.d"];
			
			[request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
			[request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
			[request startSynchronous];
			NSError *error = [request error];
			
			if (!error) {
				NSString *response = [request responseString];
				//NSLog(@"------\n\n\n%@\n\n\n",response);
				CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:response options:0 error:nil] autorelease];
				NSArray *nodes = NULL;
				nodes = [doc nodesForXPath:@"//*[local-name()='ExtendedProperty']/*[local-name()='ExtendedFieldURI']" error:nil];	
				if ([nodes count] < 1)
				{ }
				else {
					//NSLog(@"%@",[[nodes objectAtIndex:0] stringValue]);
					for (int i=0;i<[nodes count]; i++)
					{
						
					 if ([[[[nodes objectAtIndex:i] attributeForName:@"PropertyTag"] stringValue] isEqualToString:@"0x1090"])
					 {
					
						Task* task = [[Task alloc] initWithString:response:str:type_];
						[tasksList addObject: task];
						[task release];
					
					 }
					}
				}
				nodes = NULL;
				
				
			}
		}
		
	}
	[url release];
	return tasksList;
}




//РџР°СЂСЃРёРЅРі РѕС‚РІРµС‚Р°, СЃРѕРґРµСЂР¶Р°С‰РµРіРѕ Р°Р№РґРё Р°Р№С‚РµРјРѕРІ РІ РїР°РїРєРµ
-(NSMutableArray*)parseFolder:(NSString *) soapString
{
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:soapString options:0 error:nil] autorelease];
	NSArray *nodes = NULL;
	//if (ids != nil) [ids release];
	ids = [[NSMutableArray alloc] init];
	nodes = [doc nodesForXPath:@"//*[local-name()='ItemId']" error:nil];	
	for (CXMLElement *node in nodes){
		[ids addObject:[[node attributeForName:@"Id"] stringValue]];
	}
	nodes = NULL;
	return ids;
}




//РџР°СЂСЃРёРЅРі РѕС‚РІРµС‚Р°, СЃРѕРґРµСЂР¶Р°С‰РµРіРѕ Р°Р№С‚РµРј С‡РєРµР№
-(NSString*)parseChKey:(NSString *) soapString
{
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:soapString options:0 error:nil] autorelease];
	NSArray *nodes = NULL;
	nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='ItemId']" error:nil];	
	if ([nodes count] != 1)
	{ return nil;}
	else {
		
		return [[[nodes objectAtIndex:0] attributeForName:@"ChangeKey"] stringValue];
	}
}
//РЈРґР°Р»РµРЅРёРµ С‚Р°СЃРєР°
-(void)requestDeleteItem:(NSString*)itemId
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<DeleteItem DeleteType=\"HardDelete\" AffectedTaskOccurrences=\"AllOccurrences\" xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\">"
							 "\n<ItemIds>"
							 "\n<t:ItemId Id=\"%@\"/>"
							 "\n</ItemIds>"
							 "\n</DeleteItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",itemId];
	
	ASIHTTPRequest *requestDel = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[requestDel setPassword:[info password]];
	else [requestDel setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [requestDel setUsername:[info login]];
	else [requestDel setUsername:@"gusev.d"];
	//NSLog(@"%@",soapMessage);
	[requestDel appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[requestDel addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	
	
	[requestDel startSynchronous];
	NSError *error = [requestDel error];
	
	if (!error) {
		
		NSString *response = [requestDel responseString];
		//NSLog(@"---------%@----",response);
	}
	
	[url release];
	
} 
//CРѕР·РґР°РЅРёРµ РўР°СЃРєР°
-(NSMutableArray*)requestCreateItem:(NSString*)subject :(NSString*)dueDate :(NSString*)status :(NSString *)body
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/...\">"
							 "\n<soap:Header>"
							 "\n<t:RequestServerVersion Version=\"Exchange2007_SP1\"/>"
							 "\n<t:TimeZoneContext>"
							 "\n<t:TimeZoneDefinition Id=\"Eastern Standard Time\"/>"
							 "\n</t:TimeZoneContext>"
							 "\n</soap:Header>"
							 "\n<soap:Body>"
							 "\n<CreateItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\" MessageDisposition=\"SaveOnly\">"
							 "\n<Items>"
							 "\n<t:Task>"
							 "\n<t:Subject>%@</t:Subject>"
							 "\n<t:Body BodyType=\"Text\">%@</t:Body>"
							 "\n<t:DueDate>%@</t:DueDate>"
							 "\n<t:Status>%@</t:Status>"
							 
							 "\n</t:Task>"
							 
							 "\n</Items>"
							 "\n</CreateItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",subject,body,dueDate,status];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[request setPassword:[info password]];
	else [request setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [request setUsername:[info login]];
	else [request setUsername:@"gusev.d"];
	
	[request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[request startSynchronous];
	NSError *error = [request error];
	
	if (!error) {
		
		NSString *response = [request responseString];
		
		NSMutableArray * retDic =  [[NSMutableArray alloc] init];
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithXMLString:response options:0 error:nil] autorelease];
		NSArray *nodes = NULL;
		
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='ItemId']" error:nil];	
		if ([nodes count] != 1)
		{ }
		else {
			
			[retDic addObject:[[[nodes objectAtIndex:0] attributeForName:@"Id"] stringValue]];
		}
		
		
		nodes = [doc nodesForXPath:@"//*[local-name()='Task']/*[local-name()='ItemId']" error:nil];	
		if ([nodes count] != 1)
		{ }
		else {
			
			[retDic addObject:[[[nodes objectAtIndex:0] attributeForName:@"ChangeKey"] stringValue]];
		}
		[url release];
		return retDic;
		
	}
	
	return nil;
	
	
}
-(NSMutableArray *)synchronize:(NSMutableArray*)TDB :(BOOL)isChanged :(NSMutableArray*) deleted 
{
    if (info != nil) [info release];
	info = [[ConnectInfo alloc] init];
	[info initNames];
	NSMutableArray* TService = [self getTaskRequest];
    if (isChanged)
    {
		for (int i=0; i<[TService count];i++)
		{
			for (NSString * tdel in deleted)
			{
				if ([tdel isEqualToString:[[TService objectAtIndex:i] pKeyFromXML]])
				{
					[TService removeObjectAtIndex:i];
					[self requestDeleteItem:tdel];
				}
			}
		}
		for (Task* tserv in TService)
		{ BOOL check = NO;
			
			for (Task* tdb in TDB)
			{
				if ([tdb changed])
				{
					if (([tdb changeKey]!=nil)&&([tdb changeKey]!=@""))
					{
						if ([[tdb pKeyFromXML] isEqualToString:[tserv pKeyFromXML]])
						{   
							tdb.changed = NO;
							check = YES;
							if ([tdb type]==1)
							{
							[self setItemProperties:[tserv pKeyFromXML]
												   :[tserv changeKey]
												   :[tdb header]
												   :[tdb finishDate]
												   :[tdb status]
												   :[tdb body]];
							}
							else {
								[self setMessageProperties:[tserv pKeyFromXML]
													   :[tserv changeKey]
													   :[tdb status]];
							}

						}
					}
					else { //if ([tdb changeKey]!=nil)
						NSMutableArray * temp = [self requestCreateItem:[tdb header] :[tdb finishDate] :[tdb status] :[tdb body]];
						
						tdb.changeKey = [temp  objectAtIndex:1];
						
						tdb.pKeyFromXML = [temp objectAtIndex:0];
						tdb.changed = NO;
						
						[temp release];
					}
				}
				else {//if ([tdb changed])
					if ([[tdb pKeyFromXML] isEqualToString:[tserv pKeyFromXML]])
					{ 
						if ([[tdb changeKey] isEqualToString:[tserv changeKey]])
						{
							check = YES;
						}
						else {//if ([[tdb changeKey] isEqualToString:[tserv changeKey]])
							[tdb release];
							tdb = tserv;
							
						}
						check = YES;
					}
				}
			}
			if (!check)
			{
				[TDB addObject:tserv];
			}
		}
		return TDB;
	}
	else {//if (isChanged) db not changed
		return TService;
	}
	
}
-(void) setItemProperties:(NSString*)idKey :(NSString*)chKey 
						 :(NSString*)subject :(NSString*)dueDate :(NSString*)status :(NSString*)Body
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<UpdateItem MessageDisposition=\"SaveOnly\" ConflictResolution=\"AutoResolve\" xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\">"
							 "\n<ItemChanges>"
							 "\n<t:ItemChange>"
							 "\n<t:ItemId Id=\"%@\" ChangeKey=\"%@\"/>"
							 "\n<t:Updates>"
							 "\n<t:SetItemField>"
							 "\n<t:FieldURI FieldURI=\"item:Body\"/>"
							 "\n<t:Task>"
							 "\n<t:Body BodyType=\"Text\">%@</t:Body>"
							 "\n</t:Task>"
							 "\n</t:SetItemField>"
							 "\n<t:SetItemField>"
							 "\n<t:FieldURI FieldURI=\"task:Status\"/>"
							 "\n<t:Task>"
							 "\n<t:Status>%@</t:Status>"
							 "\n</t:Task>"
							 "\n</t:SetItemField>"
							 "\n<t:SetItemField>"
							 "\n<t:FieldURI FieldURI=\"task:DueDate\"/>"
							 "\n<t:Task>"
							 "\n<t:DueDate>%@</t:DueDate>"
							 "\n</t:Task>"
							 "\n</t:SetItemField>"
							 "\n<t:SetItemField>"
							 "\n<t:FieldURI FieldURI=\"item:Subject\"/>"
							 "\n<t:Task>"
							 "\n<t:Subject>%@</t:Subject>"
							 "\n</t:Task>"
							 "\n</t:SetItemField>"
							 "\n</t:Updates>"
							 "\n</t:ItemChange>"
							 "\n</ItemChanges>"
							 "\n</UpdateItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",idKey,chKey,Body, status,dueDate,subject];
	
	ASIHTTPRequest *requestSet = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[requestSet setPassword:[info password]];
	else [requestSet setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [requestSet setUsername:[info login]];
	else [requestSet setUsername:@"gusev.d"];
	
	[requestSet appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[requestSet addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[requestSet startSynchronous];
	NSError *error = [requestSet error];
	
	if (!error) {
		
		//	NSString *response = [requestSet responseString];
		//NSLog(response);
		
	}
	[requestSet clearDelegatesAndCancel];
	[url release];
}
-(void) setMessageProperties:(NSString*)idKey :(NSString*)chKey 
						 :(NSString*)status
{
	NSURL *url;
	if ([info hostname] != nil){	url = [[NSURL alloc] initWithString: [info hostname]];}
	else {url = [[NSURL alloc] initWithString: @"https://mail.digdes.com/ews/exchange.asmx"];}
	NSString * str;
	if ([status isEqualToString:@"InProgress"])
	{str=@"2";}
	if ([status isEqualToString:@"Completed"])
	{str=@"1";}
	if ([status isEqualToString:@"NotStarted"])
	{str=@"NULL";}
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">"
							 "\n<soap:Body>"
							 "\n<UpdateItem MessageDisposition=\"SaveOnly\" ConflictResolution=\"AutoResolve\" xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\">"
							 "\n<ItemChanges>"
							 "\n<t:ItemChange>"
							 "\n<t:ItemId Id=\"%@\" ChangeKey=\"%@\"/>"
							 "\n<t:Updates>"
							 "\n<t:SetItemField>"
							 "\n<t:ExtendedFieldURI PropertyTag=\"0x1090\" PropertyType=\"Integer\"/>"
							 "\n<t:Message>"
							 "\n<t:ExtendedProperty>"
							 "\n<t:ExtendedFieldURI PropertyTag=\"0x1090\" PropertyType=\"Integer\"/>"
							 "\n<t:Value>%@</t:Value>"
							 "\n</t:ExtendedProperty>"
							 "\n</t:Message>"
							 "\n</t:SetItemField>"
							 "\n</t:Updates>"
							 "\n</t:ItemChange>"
							 "\n</ItemChanges>"
							 "\n</UpdateItem>"
							 "\n</soap:Body>"
							 "\n</soap:Envelope>",idKey,chKey,str];
	[str release];
	//NSLog(soapMessage);
	ASIHTTPRequest *requestSet = [ASIHTTPRequest requestWithURL:url];
	if ([info password] != nil)[requestSet setPassword:[info password]];
	else [requestSet setPassword:@"p@ssw0rd"];
	if ([info login]!= nil) [requestSet setUsername:[info login]];
	else [requestSet setUsername:@"gusev.d"];
	
	[requestSet appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	[requestSet addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
	[requestSet startSynchronous];
	NSError *error = [requestSet error];
	
	if (!error) {
		
			NSString *response = [requestSet responseString];
		//NSLog(response);
		
	}
	[requestSet clearDelegatesAndCancel];
	[url release];
}
-(void)dealloc
{
	[ids release];
	[info release];
	[tasksList release];
	[super dealloc];	
}
@end

