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
    return [self.context evaluateRuby:source irbMode:YES];
}

@end
