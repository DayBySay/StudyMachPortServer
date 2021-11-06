//
//  Server.h
//  StudyMachPortServer
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import <Foundation/Foundation.h>

@class Server;

@protocol ServerDelegate <NSObject>
@optional
- (void)server:(nullable Server *)server didReceiveMessage:(nullable NSPortMessage *)message;
@end

@interface Server : NSObject
@property (nullable, weak) id <ServerDelegate> delegate;

- (void)run;

@end
