//
//  IGRubyEvaulatorWebSocket.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGRubyEvaulatorWebSocket.h"
#import "JSContext+OpalAdditions.h"

@interface JSContext (OpalAdditionsPrivate)
@property (nonatomic, retain) JSValue* opalCompiler;
@end

@implementation IGRubyEvaulatorWebSocket

- (JSValue*) evaulateSource:(NSString*)source {
    __block JSValue* value;
    dispatch_sync(dispatch_get_main_queue(), ^{
        value = [self.context evaluateRuby:source irbMode:YES];
    });
    return value;
}

@end
