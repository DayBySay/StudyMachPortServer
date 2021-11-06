//
//  ViewController.m
//  StudyMachPortServer
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import "ViewController.h"
#import "Server.h"
#import "ServerProtocol.h"

@interface ViewController () <ServerDelegate>
@property (weak) IBOutlet NSTextField *label;
@property (strong, nonatomic) Server *server;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _server = [[Server alloc] init];
    _server.delegate = self;
    [_server run];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)server:(Server *)server didReceiveMessage:(NSPortMessage *)message {
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
            [self.label setStringValue:[NSString stringWithFormat:@"受信メッセージ: %@", text]];
        }
            break;
        default:
            NSLog(@"Unexpected message ID %u", (unsigned)message.msgid);
            break;
    }
}

@end
