//
//  AppDelegate.h
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSContext;
@class IGJavaScriptConsoleServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IGJavaScriptConsoleServer* server;
@property (strong, nonatomic) JSContext* context;

@end
