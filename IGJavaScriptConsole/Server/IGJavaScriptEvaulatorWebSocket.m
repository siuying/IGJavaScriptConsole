//
//  IGJavaScriptEvaulatorWebSocket.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGJavaScriptEvaulatorWebSocket.h"

#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF jsConsoleLogLevel
static const int jsConsoleLogLevel = LOG_LEVEL_ERROR;

@implementation IGJavaScriptEvaulatorWebSocket

-(instancetype) initWithRequest:(HTTPMessage *)theRequest socket:(GCDAsyncSocket *)theSocket context:(JSContext*)context {
    self = [super initWithRequest:theRequest socket:theSocket];
    self.context = context;
    return self;
}

- (void)didOpen {
    DDLogDebug(@"open websocket connection");

    [super didOpen];
}

- (void)didReceiveMessage:(NSString *)msg {
    NSError* error;
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:&error];
    if (data) {
        DDLogVerbose(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, data);
        if (data[@"command"]) {
            NSString* command = data[@"command"];
            if ([command isEqualToString:@"eval"]) {
                NSString* source = data[@"source"];
                NSString* language = data[@"language"];
                if (source) {
                    [self didReceiveEvaulateWithSource:source language:language];
                } else {
                    [self sendErrorMessage:[NSString stringWithFormat:@"Missing source or language: %@", data]];
                }
                return;
            }
        }
        [self sendErrorMessage:@"unknown command"];
        return;
    }
    
    if (error) {
        [self sendErrorMessage:[NSString stringWithFormat:@"Cannot parse command: %@", [error description]]];
    } else {
        [self sendErrorMessage:@"Cannot parse command, unknown error."];
    }
}

- (void)didClose {
    DDLogDebug(@"close websocket connection");

    [super didClose];
}

- (NSString*) evaulateSource:(NSString*)source {
    __block NSString* value;
    dispatch_sync(dispatch_get_main_queue(), ^{
        value = [[self.context evaluateScript:source] toString];
    });
    return value;
}

#pragma mark - Private

- (void) didReceiveEvaulateWithSource:(NSString*)source language:(NSString*)language {
    @synchronized(self.context) {
        self.context.exception = nil;
        NSString* value = [self evaulateSource:source];
        if (!self.context.exception) {
            NSString* valueString = value;
            NSDictionary* message = @{@"status": @"ok", @"result": valueString ? valueString : @"(null)"};
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
            if (error) {
                DDLogError(@"error serializing data to json: %@", message);
            }
            [self sendMessage:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        } else {
            NSString* error = self.context.exception ? [self.context.exception toString] : @"Unknown error";
            DDLogError(@"error evaulate: %@", error);
            [self sendErrorMessage:error];
        }
    }
}

-(void) sendErrorMessage:(NSString*)message {
    DDLogError(@"send error message: %@", message);
    NSError* error;
    NSDictionary* data = @{@"status": @"error", @"message": message ? message : @""};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if (error) {
        DDLogError(@"error serializing data to json: %@", message);
    }
    [self sendMessage:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
}

@end
