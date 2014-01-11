//
//  IGJavaScriptConsoleServer.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGJavaScriptConsoleServer.h"
#import "IGJSConsoleConnection.h"

#import "DDLog.h"
#undef LOG_LEVEL_DEF
#define LOG_LEVEL_DEF jsConsoleLogLevel
static const int jsConsoleLogLevel = LOG_LEVEL_VERBOSE;

@implementation IGJavaScriptConsoleServer

-(instancetype) initWithContext:(JSContext*)context {
    self = [super init];

    self.context = context;
    self.connectionClass = [IGJSConsoleConnection class];
    self.type = @"_http._tcp.";

    NSString* root = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"public"];
    DDLogInfo(@"Setting document root: %@", root);
    self.documentRoot = root;

    return self;
}

-(instancetype) init {
    return [self initWithContext:[[JSContext alloc] init]];
}

@end
