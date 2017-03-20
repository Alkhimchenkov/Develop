//
//  UserIsSigned.h
//  Urbo_iOS
//
//  Created by Андрей on 11.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@import Firebase;

#define GLOBAL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

typedef enum {
    ERequestFalse,
    ERequestTrue,
}ERequestResult;

typedef enum {
    ETypePassword,
    ETypeFacebook,
    ETypeGmail,
}ETypeAuth;


@protocol UserIsSignedDelegate;


@interface UserIsSigned : NSObject

@property (strong, nonatomic) id <UserIsSignedDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dataRequest;

-(ERequestResult)sendRequest:(NSString*)login password:(NSString*)password;
//-(ERequestResult)createUserFireBase:(NSString*)login password:(NSString*)password displayName:(NSString*)displayName;
-(void)createUserFireBase:(NSString*)login password:(NSString*)password displayName:(NSString*)displayName;
-(BOOL)createUserFireBaseOther:(NSString*)login password:(NSString*)password displayName:(NSString*)displayName;

-(void)authentication:(NSString*)login password:(NSString*)password;
-(void)authCredential:(FIRAuthCredential*)credential;


-(void)updateIsSigned:(BOOL)status;
+(void)saveUserDataLogin:(NSDictionary*)requestJSON;

+(NSURL*)getUrlUserSearch:(NSString*)user uid:(NSString*)uid;
-(void)requestFromServer:(NSURL*)urlString;

//-(void)saveUserInfo:(BOOL)statusIsSigned;
//-(BOOL)getIsUserSigned;

@end

@protocol UserIsSignedDelegate <NSObject>

@required
-(void) userSignIn:(NSError*)isSign user:(FIRUser*)userAuth type:(ETypeAuth)userAuth;

@optional
-(void) alertMessageHTTP:(NSString*)message;

@end
