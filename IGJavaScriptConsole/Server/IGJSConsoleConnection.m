//
//  IGJSConsoleConnection.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "DDLog.h"
#import "IGJSConsoleConnection.h"
#import "IGJSContextWebSocket.h"

#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF jsConsoleLogLevel
static const int jsConsoleLogLevel = LOG_LEVEL_VERBOSE;

@implementation IGJSConsoleConnection

-(NSObject<HTTPResponse>*) httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    DDLogDebug(@"%@ %@", method, path);
    return [super httpResponseForMethod:method URI:path];
}

- (WebSocket *)webSocketForURI:(NSString *)path {
    DDLogDebug(@"%@[%p]: webSocketForURI: %@", THIS_FILE, self, path);
    
    if([path isEqualToString:@"/context"]) {
        DDLogInfo(@"IGJSConsoleConnection: Creating IGJSWebSocket...");
        return [[IGJSContextWebSocket alloc] initWithRequest:request socket:asyncSocket];
    }

    return [super webSocketForURI:path];
}

@end
