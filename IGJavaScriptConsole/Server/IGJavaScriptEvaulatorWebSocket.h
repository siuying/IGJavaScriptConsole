//
//  IGJavaScriptEvaulatorWebSocket.h
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "WebSocket.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface IGJavaScriptEvaulatorWebSocket : WebSocket

@property (nonatomic, strong) JSContext* context;

-(instancetype) initWithRequest:(HTTPMessage *)request socket:(GCDAsyncSocket *)socket context:(JSContext*)context;

-(JSValue*) evaulateSource:(NSString*)source;

@end