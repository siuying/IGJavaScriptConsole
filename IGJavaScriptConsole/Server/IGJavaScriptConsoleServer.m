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
static const int jsConsoleLogLevel = LOG_LEVEL_ERROR;

@implementation IGJavaScriptConsoleServer

-(instancetype) initWithContext:(JSContext*)context language:(IGJavaScriptConsoleServerLanguage)language{
    self = [super init];

    self.context = context;
    self.language = language;
    self.connectionClass = [IGJSConsoleConnection class];
    self.type = @"_http._tcp.";
    self.port = 3300;

    NSString* webBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"JavaScriptConsoleWeb" ofType:@"bundle"];
    DDLogInfo(@"Setting document root: %@", webBundlePath);
    self.documentRoot = webBundlePath;

    return self;
}

-(instancetype) init {
    return [self initWithContext:[[JSContext alloc] init] language:IGJavaScriptConsoleServerLanguageRuby];
}

@end
