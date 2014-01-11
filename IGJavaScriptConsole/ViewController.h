//
//  ViewController.h
//  IGJavaScriptConsole
//
//  Created by Francis Chong on 1/11/14.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ViewControllerExport <JSExport>

-(void) setGreeting:(NSString*)helloText;
-(NSString*) getGreeting;

@end

@interface ViewController : UIViewController <ViewControllerExport>

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;

@end
