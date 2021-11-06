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
    if ([_delegate respondsToSelector:@selector(server:didReceiveMessage:)]) {
        [_delegate server:self didReceiveMessage:message];
        return;
    }
}

@end
