//
//  IGRubyEvaulatorWebSocket.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGRubyEvaulatorWebSocket.h"
#import "JSContext+OpalAdditions.h"

@implementation IGRubyEvaulatorWebSocket

- (NSString*) evaulateSource:(NSString*)source {
    JSValue* value = [self.context evaluateRuby:source];
    return [value toString];
}

@end
