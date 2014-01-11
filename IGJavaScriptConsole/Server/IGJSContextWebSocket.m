//
//  IGJSContextWebSocket.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGJSContextWebSocket.h"

#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF jsConsoleLogLevel
static const int jsConsoleLogLevel = LOG_LEVEL_VERBOSE;

@implementation IGJSContextWebSocket

- (void)didOpen {
    DDLogDebug(@"open websocket connection");
    
    [super didOpen];
}

- (void)didReceiveMessage:(NSString *)msg {
    DDLogDebug(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
    [self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
}

- (void)didClose {
    DDLogDebug(@"close websocket connection");

    [super didClose];
}

@end
