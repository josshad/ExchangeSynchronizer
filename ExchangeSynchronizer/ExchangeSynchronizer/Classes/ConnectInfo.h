//
//  ConnectInfo.h
//  ExchangeSynchronizer
//
//  Created by Илья on 15.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConnectInfo : NSObject {
	NSString* hostname;
	NSString* login;
	NSString* password;
}
@property(nonatomic,retain)NSString* hostname;
@property(nonatomic,retain)NSString* login;
@property(nonatomic,retain)NSString* password;
-(id)initNames;
@end
