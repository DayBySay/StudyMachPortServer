//
//  ServerProtocol.h
//  StudyMachPortServer
//
//  Created by Sei Takayuki on 2021/11/06.
//

#ifndef ServerProtocol_h
#define ServerProtocol_h

#define SERVER_NAME @"net.daybysay.StudyMachPortServer"

typedef NS_ENUM(uint32_t, ServerMsgType) {
    ServerMsgTypeNotify = 1,
    ServerMsgTypeNeedsResponse = 2,
    ServerMsgTypeText = 3
};

#endif /* ServerProtocol_h */
