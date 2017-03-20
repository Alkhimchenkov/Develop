//
//  SWRevealRouting.m
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "SWRevealRouting.h"
#import "SWRevealViewController.h"
#import "LoginRouting.h"
#import "AppDelegate.h"

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface SWRevealRouting ()

@property (strong, nonatomic) SWRevealViewController *mainViewController;
@property (strong, nonatomic) LoginRouting *loginRoutingNavigator;

@end

@implementation SWRevealRouting


-(void) presentMainScreenViewControllerInWindow{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainViewController = (SWRevealViewController*)[storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    self.mainViewController.navigator = self;
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}

-(void) dismissMainViewController{
    [self.mainViewController dismissViewControllerAnimated:YES completion:nil];
    self.loginRoutingNavigator = [LoginRouting sharedInstance];
    [self.loginRoutingNavigator presentLoginWindow];
}

-(void) isUserSignedUpdate{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO]  forKey:@"isUserSigned"];
    [GLOBAL_APP_DELEGATE setIsSigned:NO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
