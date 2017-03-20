//
//  UserIsSigned.m
//  Urbo_iOS
//
//  Created by Андрей on 11.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "UserIsSigned.h"

NSString *const MyUrlStr = @"http://unknow.com/UApi/urboLogin";

static NSString *const kApiLinkcreateUser = @"http://unknow.com/api/user.create";
static NSString *const kApiLinksearchUser = @"http://unknow.com/api/users.search";

@implementation UserIsSigned

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataRequest = nil;
    }
    return self;
}



-(void)requestFromServer:(NSURL*)urlString{
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    
        [request setHTTPMethod:@"GET"];
    
        NSData *data = [UserIsSigned sendSynchronousRequest:request];
    
        self.dataRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
        if ([NSJSONSerialization isValidJSONObject:self.dataRequest]){
    
            if ([self.dataRequest objectForKey:@"code"]){
               // [self.delegate alertMessageHTTP:[self.dataRequest objectForKey:@"code"]];
            } else {
               // [self authentication:login password:password];
            }
    
        } else [self.delegate alertMessageHTTP:@"Server error"];
    
}




+(NSURL*)getUrlUserSearch:(NSString*)user uid:(NSString*)uid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@&value=%@",kApiLinksearchUser, uid ,[user stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];
}


+(NSURL*)getUrlSignIN:(NSString*)user password:(NSString*)password displayName:(NSString*)displayName{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?email=%@&password=%@&displayname=%@",kApiLinkcreateUser,user, password,
                                 [displayName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];

}


-(void)createUserFireBase:(NSString*)login password:(NSString*)password displayName:(NSString*)displayName{

    NSString *urlRequest = [NSString stringWithFormat:@"%@?email=%@&password=%@&displayname=%@",kApiLinkcreateUser,login, password, [displayName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];

    [request setHTTPMethod:@"GET"];

    NSData *data = [UserIsSigned sendSynchronousRequest:request];

    self.dataRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];


    if ([NSJSONSerialization isValidJSONObject:self.dataRequest]){
        
        if ([self.dataRequest objectForKey:@"code"]){
            [self.delegate alertMessageHTTP:[self.dataRequest objectForKey:@"code"]];
        } else {
            [self authentication:login password:password];
        }
    
    } else [self.delegate alertMessageHTTP:@"Server error"];
}


-(BOOL)createUserFireBaseOther:(NSString*)login password:(NSString*)password displayName:(NSString*)displayName{
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@?email=%@&password=%@&displayname=%@&custom=0",kApiLinkcreateUser,login, password, [displayName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    
    [request setHTTPMethod:@"GET"];
    
    NSData *data = [UserIsSigned sendSynchronousRequest:request];
    
    self.dataRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    if ([NSJSONSerialization isValidJSONObject:self.dataRequest]){
        
        if ([self.dataRequest objectForKey:@"code"]){
            [self.delegate alertMessageHTTP:[self.dataRequest objectForKey:@"code"]];
            return YES;
        } else {
            return NO;
        }
        
    } else {
        [self.delegate alertMessageHTTP:@"Server error"];
        return YES;
    }
}




-(ERequestResult)sendRequest:(NSString*)login password:(NSString*)password {
    
    if ((login) && (password)){
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MyUrlStr]];
        
        NSString *params = [NSString stringWithFormat:@"emailbox=%@&passcode=%@", login, password];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *data = [UserIsSigned sendSynchronousRequest:request];
        
        self.dataRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
    }
    return [[self.dataRequest objectForKey:@"response"] isEqualToString:@"OK"] ? ERequestTrue: ERequestFalse;
    ;
}

#pragma mark - Conntect to Firebase passoword authentication
-(void)authentication:(NSString*)login password:(NSString*)password{
    [[FIRAuth auth] signInWithEmail:login password:password
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             [self.delegate userSignIn:error user:user type:ETypePassword];
                         }];
}


#pragma mark Connect To FireBase with Facebook and Google
-(void)authCredential:(FIRAuthCredential*)credential{
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                  [self.delegate userSignIn:error user:user type:ETypeFacebook];
                              }];
}


# pragma mark - save/read default user
+(void)saveUserDataLogin:(NSDictionary*)requestJSON{
        
    [[requestJSON objectForKey:@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"id"]        forKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"username"]  forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"email"]     forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"full_name"] forKey:@"full_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"avatar"]    forKey:@"avatar"];
        
     }];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)updateIsSigned:(BOOL)status{

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:status]  forKey:@"isUserSigned"];
    [GLOBAL_APP_DELEGATE setIsSigned:status];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self signOut:status];
}

-(void)signOut:(BOOL)exit{
    if (!exit) {
        NSError *signOutError;
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        if (!status) {
            NSLog(@"Error signing out: %@", signOutError);
            return;
        }
    }
}


+(NSData*)sendSynchronousRequest:(NSURLRequest*)request{
    
    dispatch_semaphore_t sem;
    
    __block NSData *result;
    
    result = nil;
    
    sem = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         
                                         if (error) {
                                           //  NSLog(@"dataTaskWithRequest errors: %@", error);
                                             return;
                                         }
                                         
                                         if ([response isKindOfClass:[NSHTTPURLResponse class]]){
                                             NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
                                             // "https://ru.wikipedia.org/wiki/Список_кодов_состояния_HTTP
                                             
                                             if(statusCode == 200) result = data;
                                         }
                                         
                                         dispatch_semaphore_signal(sem);
                                     }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return result;
}

@end
