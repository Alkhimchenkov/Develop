//
//  RootWireframe.m
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "RootWireframe.h"
#import "LoginRouting.h"
#import "SWRevealRouting.h"
#import "AppDelegate.h"

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface RootWireframe ()

@property (strong, nonatomic) LoginRouting *loginRouting;
@property (strong, nonatomic) SWRevealRouting *mainRouting;

@end


@implementation RootWireframe


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginRouting = [LoginRouting sharedInstance];
    }
    return self;
}


- (BOOL)application:(UIWindow*)window didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self.loginRouting setWindow:window];
    
    self.mainRouting = [[SWRevealRouting alloc] init];
    
    [self.mainRouting setWindow:window];
    
    [self checkIfAnyUserConnectToApp];
    
    return YES;
}

-(void)checkIfAnyUserConnectToApp{
    if (![GLOBAL_APP_DELEGATE isSigned]) {
        NSLog(@"Show LoginView");
        [self.loginRouting presentLoginWindow];
    } else {
        NSLog(@"Show MainView");
        [self.mainRouting presentMainScreenViewControllerInWindow];
    }
}


@end
