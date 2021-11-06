//
//  main.m
//  StudyMachPortServerCLI
//
//  Created by Sei Takayuki on 2021/11/07.
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import "ServerProtocol.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Client *client = [[Client alloc] init];
        [client sendText:@"贈る言葉"];
    }
    return 0;
}


