//
//  Server.m
//  StudyMachPortServer
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import "Server.h"
#import "ServerProtocol.h"

@interface Server () <NSPortDelegate>
@property NSPort *port;
@end

@implementation Server

- (void)run {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.port = [[NSMachBootstrapServer sharedInstance] servicePortWithName:SERVER_NAME];
#pragma clang diagnostic pop

    if (self.port == nil) {
        NSLog(@"Unable to open server port.");
        return;
    }

    self.port.delegate = self;
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:self.port forMode:NSDefaultRunLoopMode];
}

- (void)handlePortMessage:(NSPortMessage *)message {
    switch (message.msgid) {
        case ServerMsgTypeNotify:
            NSLog(@"Received Notify message");
            break;
        case ServerMsgTypeNeedsResponse: {
            NSPort *responsePort = message.sendPort;
            if (responsePort == nil) {
                return;
                
            }
            NSPortMessage *response = [[NSPortMessage alloc] initWithSendPort:responsePort
                                                                  receivePort:nil
                                                                   components:nil];
            response.msgid = ServerMsgTypeNeedsResponse;
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            [response sendBeforeDate:date];
            NSLog(@"Sent response");
        }
            break;
        case ServerMsgTypeText: {
            NSArray *components = message.components;
            if (components.count <= 0) {
                return;
            }
            
            NSData *data = components[0];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", text);
        }
            break;
        default:
            NSLog(@"Unexpected message ID %u", (unsigned)message.msgid);
            break;
    }
}

@end
