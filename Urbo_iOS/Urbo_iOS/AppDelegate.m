//
//  AppDelegate.m
//  Urbo_iOS
//
//  Created by Андрей on 11.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "DataProvider.h"
#import "RootWireframe.h"

@import Firebase;
@import GoogleSignIn;
//@import FirebaseMessaging;
//@import UserNotifications;


@interface AppDelegate ()
@property (strong, nonatomic) RootWireframe *rootWireframe;

//, FIRMessagingDelegate>//<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    
    self.isSigned = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isUserSigned"] boolValue] ? YES: NO;
    
//    [GMSServices provideAPIKey:@"AIzaSyDG0B7YlQuRTQxlp6iJ5G_hgp2_xAuFFas"];
//    [GMSPlacesClient provideAPIKey:@"AIzaSyDG0B7YlQuRTQxlp6iJ5G_hgp2_xAuFFas"];
    
    [GMSServices provideAPIKey:@"AIzaSyDCds3pntUDh_voHpAxWE9csPKaMHKt6Mg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDCds3pntUDh_voHpAxWE9csPKaMHKt6Mg"];
    
//    
//    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
//    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//    }];
    
    // For iOS 10 display notification (sent via APNS)
 //   [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    // For iOS 10 data message (sent via FCM)
    //    [[FIRMessaging messaging] subscribeToTopic:@"/topics/business-notifications"];
   // [FIRMessaging messaging].remoteMessageDelegate = self;
    
    
 //   [application registerForRemoteNotifications];
    // [END register_for_notifications]
    
    // [START configure_firebase]
    //[FIRApp configure];
    // [END configure_firebase]
    // [START add_token_refresh_observer]
    // Add observer for InstanceID token refresh callback.
    

    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
 //   [GIDSignIn sharedInstance].delegate = self;
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshCallback:)
//                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    // [END add_token_refresh_observer]
    
    
    
    [[DataProvider sharedInstance] loadData];
   
    _rootWireframe = [[RootWireframe alloc] init];
    return [self.rootWireframe application:self.window didFinishLaunchingWithOptions:launchOptions];
    
    // return YES;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    
    if ([url.scheme hasPrefix:@"fb"]){
        return  [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url
                                                     sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    } else {
    
      return [[GIDSignIn sharedInstance] handleURL:url
                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
    
//    
//    if ([[GIDSignIn sharedInstance] handleURL:url
//                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) {
//        return YES;
//    }
//
//    
//    return  [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url
//                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[DataProvider sharedInstance] saveData];
    
//    [[FIRMessaging messaging] disconnect];
//    NSLog(@"Disconnect from FCM");

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // [self connectToFirebase];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    //Print message ID
//    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
//    
//    //Print full message
//    NSLog(@"%@",userInfo);
    
}

#pragma mark - Delegate Message Cloud Firebase
/// The callback to handle data message received via FCM for devices running iOS 10 or above.
//- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{
//    // Print full message
////    [self.delegate reciveDataSubscribe: [NSDictionary dictionaryWithObjectsAndKeys:[NSJSONSerialization JSONObjectWithData:[[remoteMessage.appData objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], @"message", [NSNumber numberWithInt:1], @"type", nil]];
//}


//#pragma mark - Custom Firebase code
//-(void)tokenRefreshCallback:(NSNotification*)notification{
//    NSString* refreshedToken = [[FIRInstanceID instanceID] token];
//    NSLog(@"InstanceID token: %@", refreshedToken);
//    
//    [self connectToFirebase];
//}
//
//
//- (void)connectToFirebase {
//    
//    // Won't connect since there is no token
//    if (![[FIRInstanceID instanceID] token]) {
//        return;
//    }
//    //
//    //    // Disconnect previous FCM connection if it exists.
//    //    [[FIRMessaging messaging] disconnect];
//    
//    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Unable to connect to FCM. %@", error);
//        } else {
//            NSLog(@"Connected to FCM.");
//            [[FIRMessaging messaging] subscribeToTopic:@"/topics/business-notifications"];
//        }
//    }];
//    
//}

@end
