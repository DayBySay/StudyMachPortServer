//
//  Client.h
//  StudyMachPortServerCLI
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

- (void)sendNotifyMessage;
- (void)sendNeedsResponseMessage;

@end
