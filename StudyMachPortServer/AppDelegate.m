//
//  AppDelegate.m
//  StudyMachPortServer
//
//  Created by Sei Takayuki on 2021/11/06.
//

#import "AppDelegate.h"
#import "Server.h"

@interface AppDelegate ()

@property (strong, nonatomic) Server *server;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _server = [[Server alloc] init];
    [_server run];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
