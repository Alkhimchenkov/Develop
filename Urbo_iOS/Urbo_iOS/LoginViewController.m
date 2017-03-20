//
//  ViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 11.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "LoginViewController.h"
#import "UserIsSigned.h"
#import "CustomIOSAlertView.h"
#import "SingletonImageObject.h"
#import "Constatns.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

NSString *const kStringKey_LayerBottom = @"borderBottom";
NSString *const kStringKey_PasswordDefault = @"Qwert-12";

@import FirebaseAuth;


typedef enum {
    EStateError   = -1,
    EStateUnknown = 0,
    EStateLoading = 1,
    EStateReady   = 2
} viewStateLoad;


@interface LoginViewController () <UITextFieldDelegate, CustomIOSAlertViewDelegate, UserIsSignedDelegate, GIDSignInUIDelegate, GIDSignInDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoad;
@property (strong, nonatomic) IBOutlet UITextField *textLogin;
@property (strong, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;

- (IBAction)signInTouch:(id)sender;


@end


@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegate];
    [GIDSignIn sharedInstance].delegate = self;
        
    [self changeViewLayoutWithStateIndicator:EStateUnknown];
    
}

-(void)viewDidLayoutSubviews{
    [self setSettingComponent];
}


#pragma mark animation StateIndicator
- (void)changeViewLayoutWithStateIndicator:(viewStateLoad)state
{
    switch (state) {
        case EStateUnknown:
            self.indicatorLoad.hidden = YES;
            break;
        case EStateError:
            if (![self.indicatorLoad isHidden])
            {
                self.indicatorLoad.hidden = YES;
            }
            break;
        case EStateLoading:
            if (![self.indicatorLoad isAnimating])
            {
                self.indicatorLoad.hidden = NO;
                [self.indicatorLoad startAnimating];
            }
            break;
        case EStateReady:
            if ([self.indicatorLoad isAnimating])
            {
                [self.indicatorLoad stopAnimating];
                self.indicatorLoad.hidden = YES;
            }
            break;
    }
}


# pragma mark - set delegate for TextField Password and Login
-(void)setDelegate{
    self.textLogin.delegate = self;
    self.textPassword.delegate = self;
}



# pragma mark - set setting button default
-(void)setSettingComponent{
    [self setLayerTextFieldBottom:self.textLogin borderWidth:1.0f];
    [self setLayerTextFieldBottom:self.textPassword borderWidth:1.0f];
    
    [self.headerLabel setTextColor:UIColorFromHEX(COLOR_MAIN)];
    [self.btnLogin.layer setBackgroundColor:UIColorFromHEX(COLOR_MAIN).CGColor];
    [self.btnLogin setTintColor:UIColorFromHEX(COLOR_MAIN_TEXT)];

    
    [self.btnFacebook.layer setBackgroundColor:UIColorFromHEX(COLOR_FACEBOOK_ADD).CGColor];
    [self.btnSignIn.layer setBackgroundColor:UIColorFromHEX(COLOR_GMAIL).CGColor];

    [self setShadowForButton:self.btnSignIn];
    [self setShadowForButton:self.btnFacebook];
    [self setShadowForButton:self.btnLogin];
    
    [self setAligmentImageAndTextButton:self.btnLogin];
}


-(void)setAligmentImageAndTextButton:(UIButton*)button{

    CGSize frameSizeButton = button.frame.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -frameSizeButton.width / 2 - 15, 0, 0)];
}


-(void)setShadowForButton:(UIButton*)button{
    button.layer.cornerRadius = 4;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.8f;
    button.layer.shadowOffset = CGSizeMake(1,1);
//    button.layer.shadowPath = [[UIBezierPath bezierPathWithRect:button.layer.bounds] CGPath];
}


-(void)setLayerTextFieldBottom:(UITextField*)textField borderWidth:(CGFloat)borderWidth{
    
    [self removeLayerByName:kStringKey_LayerBottom textField:textField];
    
    CALayer *border = [CALayer layer];
 //   CGFloat borderWidth = 1;
    border.backgroundColor = [[UIColor redColor] CGColor];
    border.name = kStringKey_LayerBottom;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, borderWidth);
    [textField.layer addSublayer:border];
}


- (void)removeLayerByName:(NSString *)layerNameToRemove textField:(UITextField*)textField{
    
    for (CALayer *childLayer in [textField.layer sublayers]) {
        if ([childLayer.name isEqualToString:layerNameToRemove]) {
            [childLayer removeFromSuperlayer];
            break;
        }
    }
}


#pragma mark - method UITextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){
        [self setSettingFieldText:textField];
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self defaultSettingFieldText:textField];
//    [self setLayerTextFieldBottom:textField borderWidth:2.0f];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self setSettingFieldText:textField];
//    [self setLayerTextFieldBottom:textField borderWidth:1.0f];
}


#pragma mark - Setting TextField Login and Password Method
-(void)setSettingFieldText:(UITextField*)textField{
    (![self isValidInputTextField:textField.text textField:textField]) ? [self warringSettingFieldText:textField]:[self defaultSettingFieldText:textField];
    
    [textField resignFirstResponder];
}



-(void)defaultSettingFieldText:(UITextField*)textField{
//    textField.layer.backgroundColor = [[UIColor clearColor]CGColor];
//    textField.layer.borderWidth = 0.0;
    textField.tag = EStateUnknown;
}


-(void)warringSettingFieldText:(UITextField*)textField{
//    textField.layer.borderColor = [[UIColor redColor]CGColor];
//    textField.layer.borderWidth = 1.0;
    textField.tag = EStateError;
}


-(void)callSettingTextField{
    [self setSettingFieldText:self.textLogin];
    [self setSettingFieldText:self.textPassword];
}


# pragma  mark valid field login and password
-(BOOL)isValidInputTextField:(NSString*)strField textField:(UITextField*)textField{
    
    if ([textField isEqual:self.textLogin] && (strField.length > 0)){
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        
        NSPredicate *loginTest = [NSPredicate predicateWithFormat:
                                  @"SELF MATCHES %@", stricterFilterString];
        
        return [loginTest evaluateWithObject:strField];
    } else {
        return (strField && strField.length > 0) ? YES:NO;
    }
}


#pragma mark show Alert
-(void)showAlert:(NSString*)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login failure!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - delegate UserSignIn

-(void)userSignIn:(NSError*)isSign user:(FIRUser *)userAuth type:(ETypeAuth)typeAuth{
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    UserIsSigned *userSignIn = [[UserIsSigned alloc] init];
    [userSignIn setDelegate:self];
    
    BOOL authOther = (typeAuth != ETypePassword) ? [userSignIn createUserFireBaseOther:userAuth.email password:kStringKey_PasswordDefault displayName:userAuth.displayName]:NO;

    [self changeViewLayoutWithStateIndicator:EStateReady];
    
    if (isSign == nil && !(authOther)){
        
        [userSignIn updateIsSigned:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:userAuth.uid        forKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:userAuth.displayName  forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:userAuth.email     forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:userAuth.displayName forKey:@"full_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[userAuth.photoURL absoluteString]   forKey:@"avatar"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

        //[self dismissViewControllerAnimated:YES completion:nil];

        [self.navigator presentMainWindow];
    } else if (isSign == nil && authOther) {
        [self showAlert:@"Error authentication!"];
    } else if (isSign.code == FIRAuthErrorCodeUserNotFound) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Create user" message:@"Input display name" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UITextField *textField = [alertController.textFields objectAtIndex:[alertController.textFields count]-1];
            
            [self changeViewLayoutWithStateIndicator:EStateLoading];
            
            dispatch_async(dispatchQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [userSignIn createUserFireBase:self.textLogin.text
                                  password:self.textPassword.text
                               displayName:textField.text];
                    
                });
            });
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        
        [alertController addAction:saveAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self showAlert:@"Unknown user name or password is incorrect"];
    }

}

-(void)alertMessageHTTP:(NSString *)message{
    [self changeViewLayoutWithStateIndicator:EStateReady];
    [self showAlert:message];
}


#pragma mark - Get Account info
-(void)dataCheking:(UserIsSigned*)userInfoRequest mail:(NSString*)mail password:(NSString*)pass{
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self changeViewLayoutWithStateIndicator:EStateLoading];
    
    dispatch_async(dispatchQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([userInfoRequest sendRequest:mail password:pass])
            {
                [self changeViewLayoutWithStateIndicator:EStateReady];
                [UserIsSigned saveUserDataLogin:userInfoRequest.dataRequest];
                [userInfoRequest updateIsSigned:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [self changeViewLayoutWithStateIndicator:EStateError];
                [self showAlert:@"Unknown user name or password is incorrect"];
            }
        });
    });
    
}

#pragma mark - method create Popup View

#pragma mark - show popup custom info
-(void)showPopupInfoFacebook:(NSString*)idUser nameUser:(NSString*)nameUser urlImage:(NSString*)urlImage{
    
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createViewPopup:idUser nameUser:nameUser urlImage:urlImage]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        //  NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (UIView *)createViewPopup:(NSString*)idUser nameUser:(NSString*)nameUser urlImage:(NSString*)urlImage{
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UILabel *labelNameUser = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, demoView.frame.size.width-10, 21)];
    labelNameUser.text = [NSString stringWithFormat:@"Welcome %@!",nameUser];
    labelNameUser.textAlignment = NSTextAlignmentCenter;
    labelNameUser.center = CGPointMake(demoView.bounds.size.width / 2, labelNameUser.frame.size.height/2+10);
    [demoView addSubview:labelNameUser];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(labelNameUser.frame)+7, 128, 128)];
    imageView.center = CGPointMake(demoView.bounds.size.width / 2, CGRectGetMinY(imageView.frame)+imageView.frame.size.height/2);
    
    if (!(urlImage && urlImage.length > 0)){
        [imageView setImage:[UIImage imageNamed:@"default.png"]];
    } else {
        [imageView setImage:[[SingletonImageObject sigleton] imageFromCache:urlImage]];
    }
    
    [demoView addSubview:imageView];
    
    UILabel *labelIdUser = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame)+7,
                                                                     demoView.frame.size.width-10, 21)];
    labelIdUser.text = [NSString stringWithFormat:@"ID: %@",idUser];
    labelIdUser.textAlignment = NSTextAlignmentCenter;
    labelIdUser.center = CGPointMake(demoView.bounds.size.width / 2,
                                     CGRectGetMinY(labelIdUser.frame)+labelIdUser.frame.size.height/2);
    [demoView addSubview:labelIdUser];
    
    
    return demoView;
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex{
    [alertView close];
}


//#pragma mark - method delegate facebook login
//- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
//               error:(NSError *)error{
//    
//    if ([FBSDKAccessToken currentAccessToken]){
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
//                                           parameters:@{@"fields":@"picture, email, name"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//                 if (error) {
//                     [self showAlert:error.localizedDescription];
//                 } else {
//                     
//                     [self showPopupInfoFacebook:[result valueForKey:@"id"]
//                                        nameUser:[result valueForKey:@"name"]
//                                        urlImage:[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]];
//                 }
//         }];
//    }
//}
//
//- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
//  //  NSLog(@"loginButtonDidLogOut");
//}



#pragma mark Action
- (IBAction)buttonSignIn:(id)sender {
    
    [self callSettingTextField];
    
    UserIsSigned *userInfoRequest = [[UserIsSigned alloc] init];
    
    [userInfoRequest setDelegate:self];
    
    if ((self.textPassword.tag == EStateUnknown) && (self.textLogin.tag == EStateUnknown)){
        //    [self dataCheking:userInfoRequest mail:self.textLogin.text password:self.textPassword.text];
        
        dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [self changeViewLayoutWithStateIndicator:EStateLoading];
        
        dispatch_async(dispatchQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [userInfoRequest authentication:self.textLogin.text password:self.textPassword.text];
            });
        });
        
    } else {
        [self showAlert:@"Incorrect e-mail or password is empty"];
    };
    
}

- (IBAction)signInTouch:(id)sender {
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];

}

- (IBAction)logInTouch:(id)sender {
    UserIsSigned *userInfoRequest = [[UserIsSigned alloc] init];
    [userInfoRequest setDelegate:self];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager
     logInWithReadPermissions:@[ @"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
              [self showAlert:error.localizedDescription];
         } else if (result.isCancelled) {
             NSLog(@"FBLogin cancelled");
         } else {
             FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                              credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                              .tokenString];
             [userInfoRequest authCredential:credential];
         }
     }];
}


#pragma mark - GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    UserIsSigned *userInfoRequest = [[UserIsSigned alloc] init];
    [userInfoRequest setDelegate:self];
    
    if (error) {
        [self showAlert:error.localizedDescription];
    } else {
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:[user.authentication idToken]
                                         accessToken:[user.authentication accessToken]];
        
        
        [userInfoRequest authCredential:credential];
 }
}

@end
