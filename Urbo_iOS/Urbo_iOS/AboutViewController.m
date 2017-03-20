//
//  AboutViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 16.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "AboutViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@import Firebase;


@interface AboutViewController () <GIDSignInUIDelegate, GIDSignInDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnGoogleLink;
@property (strong, nonatomic) IBOutlet UIButton *btnFBSDLink;

@property (strong, nonatomic) IBOutlet UILabel *labelGoogleLink;
@property (strong, nonatomic) IBOutlet UILabel *labelFBSDLink;

@property (strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    [self linkDisplayName:[FIRAuth auth].currentUser];
    
    self.handle = [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        
        NSLog(@"dfdfd");
    }];
}

- (void)firebaseLoginWithCredential:(FIRAuthCredential *)credential {
    if ([FIRAuth auth].currentUser) {
        [[FIRAuth auth].currentUser linkWithCredential:credential
                                            completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
             if (error) {
                 NSLog(@"Error %@", error.localizedDescription);
                 return;
             } else {
                [self linkDisplayName:user];
             }
        }];
    } 
    
}


- (IBAction)signInTouch:(id)sender {
//    if (![[[GIDSignIn sharedInstance] currentUser] authentication]) {
        [GIDSignIn sharedInstance].uiDelegate = self;
        [[GIDSignIn sharedInstance] signIn];
//    } else {
//        [[FIRAuth auth].currentUser unlinkFromProvider:
//         [[FIRAuth auth].currentUser.providerData[[self indexUserInfo:FIRGoogleAuthProviderID] ] providerID]
//                                            completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//                                                    [self.btnGoogleLink setTitle:@"LINK" forState:UIControlStateNormal];
//                                            }];
//    }
}

- (IBAction)logInTouch:(id)sender {
    
//    if ([FBSDKAccessToken currentAccessToken]){
//        [[FIRAuth auth].currentUser unlinkFromProvider:
//         [[FIRAuth auth].currentUser.providerData[[self indexUserInfo:FIRFacebookAuthProviderID] ] providerID]
//                                           completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//            [self.btnFBSDLink setTitle:@"LINK" forState:UIControlStateNormal];
//        }];
//    } else {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager
     logInWithReadPermissions:@[ @"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"%@", error.localizedDescription);
         } else if (result.isCancelled) {
             NSLog(@"FBLogin cancelled");
         } else {
             FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                              credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                              .tokenString];
             [self firebaseLoginWithCredential:credential];
         }
     }];
  //  }
}


#pragma mark - GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:[user.authentication idToken]
                                                                         accessToken:[user.authentication accessToken]];
        [self firebaseLoginWithCredential:credential];
    }
}


-(void)linkDisplayName:(FIRUser*)userSign{

    for (id<FIRUserInfo> userInfo in [FIRAuth auth].currentUser.providerData) {
        if ([userInfo.providerID isEqualToString:FIRFacebookAuthProviderID]) {
            [self.labelFBSDLink setText:userInfo.displayName];
            [self.btnFBSDLink setHidden:YES];
        } else if ([userInfo.providerID isEqualToString:FIRGoogleAuthProviderID]){
            [self.labelGoogleLink setText:userInfo.displayName];
            [self.btnGoogleLink setHidden:YES];
        }
    }
}


@end
