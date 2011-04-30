//
//  Database.m
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "Task.h"
#import "ConnectInfo.h"
@implementation Database

// создаем базу, если еще не существует
-(void)createDatabase
{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	pathToDB = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",documentDirectory,@"TaskDB.db"]];
	if (sqlite3_open([pathToDB UTF8String], &db) != SQLITE_OK) {
		sqlite3_close(db);
	}
	char *tempErrorMsg;
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS Tasks (ID INTEGER PRIMARY KEY, TYPETASK INT, HEADER VARCHAR(100), BODY VARCHAR(200), DATE VARCHAR(30),FOLDER VARCHAR(20), STATE VARCHAR(15),PKEYXML VARCHAR(100), CHANGEKEY VARCHAR(100), DATEFINISH VARCHAR(50),CHANGED VARCHAR(10), USER VARCHAR(20));";
	if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &tempErrorMsg) != SQLITE_OK) {
		sqlite3_close(db);
		NSLog(@"create table fail!");
	}
}

// выполнение выборок конкретных полей тасков (для создания)
-(NSString *) performRequest: (NSString *)query :(NSInteger)key :(sqlite3 *) database
{
	db = database;
	const char *sql = [query UTF8String];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
		NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	
	// Подставляем значение в запрос
	sqlite3_bind_int(statement, 1, key);
	
	// Получаем результаты выборки
	if (sqlite3_step(statement) == SQLITE_ROW) {
		retStr= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
	} else {
		retStr = @"";
	}
	
	
	sqlite3_finalize(statement);	
	return retStr;
}

// вытаскиваем из базы все ИД нашего текущего юзера
-(NSMutableArray*)loadTasks:(NSString*)login
{
	
	if (listOfIds != nil) { [listOfIds release];}
	listOfIds = [[NSMutableArray alloc]init];
	
	if (sqlite3_open([pathToDB UTF8String], &db) == SQLITE_OK) {
        NSString* sqlStr = [[NSString alloc]init];
        sqlStr = [NSString stringWithFormat:@"%@%@%@", @"SELECT ID FROM Tasks WHERE USER='",login,@"';"];
		const char *sql = [sqlStr UTF8String];
        //[sqlStr release];
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSInteger pKey = sqlite3_column_int(statement, 0);				
				
				Task *task = [[Task alloc] initWithIdentifier:pKey: db];
				
				[listOfIds addObject:task];
				
				[task release];
				
			}
		}else
        { NSLog(@"Error with IDs!");}
		
		
		sqlite3_finalize(statement);
	} else {
		sqlite3_close(db);
	}
	sqlite3_close(db);
	return listOfIds;
}

// вставка задачи в базу
-(NSInteger)insert:(Task*)task:(NSString*)login
{
	if (sqlite3_open([pathToDB UTF8String], &db) == SQLITE_OK) {
		sqlite3_stmt *insert_stmt;
		if([task dateCreated]==nil)
		{
			NSDate *now = [NSDate date];
			task.dateCreated = [now description];
		}
		NSString* chg;
		if([task changed])
			chg = @"YES";
		else chg = @"NO";
		const char* sql = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"INSERT INTO Tasks VALUES (NULL ,?, ?, ?,'",[task dateCreated],@"','",[task folder],@"',?,'",[task pKeyFromXML],@"','",[task changeKey] ,@"','",[task finishDate],@"','",chg,@"','",login,@"');"] UTF8String];
		printf("%s",sql);
			
		if (sqlite3_prepare_v2(db, sql, -1, &insert_stmt, NULL) != SQLITE_OK) {
			NSLog(@"Fail with insert request");
		}
		if([task body]==nil)
			task.body = @" ";
		if([[task status]compare:@"-" ]==NSOrderedSame)
			task.status = @"NotStarted";
        sqlite3_bind_int(insert_stmt, 1, [task type]);
		sqlite3_bind_text(insert_stmt, 2, [[task header] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insert_stmt, 3, [[task body]  UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insert_stmt, 4, [[task status]  UTF8String], -1, SQLITE_TRANSIENT);
		if (sqlite3_step(insert_stmt) != SQLITE_DONE) {
			NSLog(@"Fail with ending stmt");
		}
		sqlite3_step(insert_stmt);
		sqlite3_reset(insert_stmt);
		const char *sql2 = [@"SELECT MAX(ID) FROM TASKS order by ID" UTF8String];
		if (sqlite3_prepare_v2(db, sql2, -1, &insert_stmt, NULL) != SQLITE_OK) {
			NSLog(@"Can't take ID");
		}
		NSInteger pKey=0;
		if (sqlite3_step(insert_stmt) == SQLITE_ROW) {
			pKey = sqlite3_column_int(insert_stmt, 0);
		}
		sqlite3_finalize(insert_stmt);
		return pKey;
	}
	sqlite3_close(db);
	return -1;
}

//обновление свойств задачи
-(void)update:(NSString*)property:(NSString*)value:(NSInteger)pKey
{
	if (sqlite3_open([pathToDB UTF8String], &db) == SQLITE_OK) {
		sqlite3_stmt *update_stmt;
		const char* sql = [[NSString stringWithFormat:@"%@%@%@%@%@",@"UPDATE TASKS Set ",property,@"=\"",value,@"\"  WHERE ID=?"] UTF8String];
	
		if (sqlite3_prepare_v2(db, sql, -1, &update_stmt, NULL) != SQLITE_OK) {
			NSLog(@"Fail with insert request");
		}
		sqlite3_bind_int(update_stmt, 1, pKey);

		if (sqlite3_step(update_stmt) != SQLITE_DONE) {
			NSLog(@"Fail with ending stmt");
		}
		sqlite3_step(update_stmt);
		sqlite3_reset(update_stmt);
		sqlite3_finalize(update_stmt);
	}
}
// удаление задачи с заданым ИД
-(void)deleteTask:(NSInteger)pKey
{
	if (sqlite3_open([pathToDB UTF8String], &db) == SQLITE_OK) {
		sqlite3_stmt *delete_stmt;
		const char* sql = [[NSString stringWithFormat:@"DELETE FROM TASKS  WHERE ID=?"] UTF8String];
		
		if (sqlite3_prepare_v2(db, sql, -1, &delete_stmt, NULL) != SQLITE_OK) {
			NSLog(@"Fail with DELETE request");
		}
		sqlite3_bind_int(delete_stmt, 1, pKey);
		
		if (sqlite3_step(delete_stmt) != SQLITE_DONE) {
			NSLog(@"Fail with ending stmt");
		}
		sqlite3_step(delete_stmt);
		sqlite3_reset(delete_stmt);
		sqlite3_finalize(delete_stmt);
	}
}
@end
