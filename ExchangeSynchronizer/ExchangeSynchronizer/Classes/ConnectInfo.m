//
//  ConnectInfo.m
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectInfo.h"


@implementation ConnectInfo
@synthesize hostname, login, password;
-(id)initNames
{
    hostname = [[NSString alloc]init];
    login = [[NSString alloc]init];
    password = [[NSString alloc]init];
    
    // загружаем данные из общих настроек 
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    hostname = [defaults stringForKey:@"server"];
    login = [defaults objectForKey:@"login"];
    password = [defaults objectForKey:@"password"];
    NSLog(@"%@%@%@",hostname,login,password);
	return self;
}
@end
