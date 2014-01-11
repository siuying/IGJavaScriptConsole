//
//  IGJavaScriptConsoleServer.h
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "HTTPServer.h"

typedef NS_ENUM(NSInteger, IGJavaScriptConsoleServerLanguage) {
    IGJavaScriptConsoleServerLanguageJavaScript,
    IGJavaScriptConsoleServerLanguageRuby
};

@interface IGJavaScriptConsoleServer : HTTPServer

@property (nonatomic, strong) JSContext* context;

/**
 Default language running on the console.
 
 By default `IGJavaScriptConsoleServerLanguageRuby`.
 */
@property (nonatomic, assign) IGJavaScriptConsoleServerLanguage language;

-(instancetype) init;

-(instancetype) initWithContext:(JSContext*)context language:(IGJavaScriptConsoleServerLanguage)language;

@end
