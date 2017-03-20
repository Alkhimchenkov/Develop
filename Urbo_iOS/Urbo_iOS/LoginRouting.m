//
//  LoginRouting.m
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "LoginRouting.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"

static LoginRouting *sharedInstance;

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface LoginRouting()

@property (strong, nonatomic) LoginViewController    *loginViewController;
@property (strong, nonatomic) SWRevealViewController  *mainViewController;

@end

@implementation LoginRouting

#pragma mark Sigleton

+ (instancetype)sharedInstance
{
    if (sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}


#pragma mark - Method Protocol Show Window Login or Main 
-(void) presentLoginWindow{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.loginViewController = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    self.loginViewController.navigator = self;
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
}

-(void) presentMainWindow{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainViewController = (SWRevealViewController*)[storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    self.mainViewController.navigator = [[SWRevealRouting alloc] init];
    [self.mainViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.mainViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.loginViewController presentViewController:self.mainViewController animated:YES completion:nil];
}

-(void) isUserSignedUpdate{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]  forKey:@"isUserSigned"];
    [GLOBAL_APP_DELEGATE setIsSigned:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
