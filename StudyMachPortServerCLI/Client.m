//
//  Client.m
//  StudyMachPortServerCLI
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import "Client.h"
#import "ServerProtocol.h"

@interface Client () <NSPortDelegate>
@end

@implementation Client {
    BOOL _responseReceived;
}

- (NSPort *)serverPort {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [[NSMachBootstrapServer sharedInstance] portForName:SERVER_NAME];
#pragma clang diagnostic pop
}

- (void)sendNotifyMessage {
    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:sendPort
                              receivePort:nil
                              components:nil];
    message.msgid = ServerMsgTypeNotify;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

- (void)sendNeedsResponseMessage {
    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPort *receivePort = [NSMachPort port];
    receivePort.delegate = self;

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:receivePort forMode:NSDefaultRunLoopMode];

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:sendPort
                              receivePort:receivePort
                              components:nil];
    message.msgid = ServerMsgTypeNeedsResponse;

    _responseReceived = NO;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }

    while (!_responseReceived) {
        [runLoop runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)sendText:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }
    NSArray *components = @[data];
    NSPortMessage *message = [[NSPortMessage alloc] initWithSendPort:sendPort
                                                         receivePort:nil
                                                          components:components];
    message.msgid = ServerMsgTypeText;
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

- (void)handlePortMessage:(NSPortMessage *)message {
    NSLog(@"Received response");
    _responseReceived = YES;
}

@end
