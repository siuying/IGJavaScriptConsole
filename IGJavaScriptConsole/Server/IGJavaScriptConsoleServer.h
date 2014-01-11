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

@interface IGJavaScriptConsoleServer : HTTPServer

@property (nonatomic, strong) JSContext* context;

-(instancetype) init;

-(instancetype) initWithContext:(JSContext*)context;

@end
