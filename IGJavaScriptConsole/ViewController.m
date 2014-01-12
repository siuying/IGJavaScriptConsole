//
//  ViewController.m
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    if (!delegate.context[@"App"]) {
        delegate.context[@"App"] = @{};
    }
    delegate.context[@"App"][@"viewController"] = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) setGreeting:(NSString*)helloText
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.greetingLabel.text = helloText;
    });
}

-(NSString*) getGreeting
{
    return self.greetingLabel.text;
}

@end
