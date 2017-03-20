//
//  ProfileViewController.m
//  Urbo_iOS
//
//  Created by Андрей on 12.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SingletonImageObject.h"
#import "SWRevealViewController.h"
#import "Constatns.h"


#import "AboutViewController.h"
#import "FriendsViewController.h"
#import "RequestViewController.h"

@import Firebase;


typedef enum {
    EAbout, EFriends, ERequest
} ViewEmbedInView;

@interface ProfileViewController () 


@property (strong, nonatomic) IBOutlet Button_Border *aboutBtn;
@property (strong, nonatomic) IBOutlet Button_Border *friendsBtn;
@property (strong, nonatomic) IBOutlet Button_Border *reauestBtn;
@property (strong, nonatomic) IBOutlet UIView *ContainerShowView;



@property (strong, nonatomic) AboutViewController *aboutViewController;
@property (strong, nonatomic) FriendsViewController *friendsViewController;
@property (strong, nonatomic) RequestViewController *requestViewController;


@property (strong, nonatomic) IBOutlet UILabel *labelTitleView;

@property (assign, nonatomic) ViewEmbedInView activeViewEmbed;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController){
        
        [self.sideBarButtonProfile setTarget:self.revealViewController];
        [self.sideBarButtonProfile setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    self.view.backgroundColor = UIColorFromHEX(COLOR_MAIN);
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.aboutViewController = (AboutViewController*)[storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
    self.friendsViewController = (FriendsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FriendsView"];
    self.requestViewController = (RequestViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RequestView"];
    
    
    
//    _txtID.text            = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//    _txtUserName.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    _txtEmail.text         = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
//    _txtFullName.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"full_name"];
//    _imageViewAvatar.image = [[SingletonImageObject sigleton]
//                              imageFromCache:[[NSUserDefaults standardUserDefaults]
//                                              objectForKey:@"avatar"]];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        [self.labelTitleView setText:user.displayName];
    }];
    
    [self showFirstTabViewControllerStart];
}


- (void)viewDidLayoutSubviews{
    [[self returnActiveButton:self.activeViewEmbed] addBottomBorderWithColor:[UIColor redColor] andWidth:2.0 ];
}


#pragma mark - Action

- (IBAction)aboutBtn:(id)sender {
    [self.aboutBtn addBottomBorderWithColor:[UIColor redColor] andWidth:2.0 ];
    [[self returnActiveButton:self.activeViewEmbed] removeBottomBorder];
    [self switchFromViewController:[self returnEmbedViewControllerInView:self.activeViewEmbed] toViewController:self.aboutViewController];
}


- (IBAction)friendsBtn:(id)sender {
    [self.friendsBtn addBottomBorderWithColor:[UIColor redColor] andWidth:2.0 ];
    [[self returnActiveButton:self.activeViewEmbed] removeBottomBorder];
    [self switchFromViewController:[self returnEmbedViewControllerInView:self.activeViewEmbed] toViewController:self.friendsViewController];

}


- (IBAction)reauestBtn:(id)sender {
    [[self returnActiveButton:self.activeViewEmbed] removeBottomBorder];
    [self.reauestBtn addBottomBorderWithColor:[UIColor redColor] andWidth:2.0 ];
    [self switchFromViewController:[self returnEmbedViewControllerInView:self.activeViewEmbed] toViewController:self.requestViewController];
}




- (IBAction)btnLogOut:(id)sender {
  //  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - privete method

-(void)showFirstTabViewControllerStart{
   
    [self addChildViewController:self.aboutViewController];
    self.aboutViewController.view.frame = self.ContainerShowView.bounds;
    [self.ContainerShowView addSubview:self.aboutViewController.view];
    [self.aboutViewController didMoveToParentViewController:self];
    
}


-(void)switchFromViewController:(UIViewController*)oldViewController toViewController:(UIViewController*)newViewController{
    
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    
    [self addChildViewController:newViewController];
    newViewController.view.frame = self.ContainerShowView.bounds;
    [self.ContainerShowView addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self];
    
    
    
    if ([newViewController isKindOfClass:[AboutViewController class]]){
        self.activeViewEmbed = EAbout;
    } else if ([newViewController isKindOfClass:[FriendsViewController class]]){
        self.activeViewEmbed = EFriends;
    } else {
        self.activeViewEmbed = ERequest;
    }
    
}

-(UIViewController*)returnEmbedViewControllerInView:(ViewEmbedInView) activeViewEmbed{
    
    switch (activeViewEmbed) {
        case EAbout:
            return self.aboutViewController;
            break;
        case EFriends:
            return self.friendsViewController;
            break;
        case ERequest:
            return self.requestViewController;
            break;
    }
    return nil;
}


-(Button_Border*)returnActiveButton:(ViewEmbedInView) activeViewEmbed{
    
    switch (activeViewEmbed) {
        case EAbout:
            return self.aboutBtn;
            break;
        case EFriends:
            return self.friendsBtn;
            break;
        case ERequest:
            return self.reauestBtn;
            break;
    }
    
}


@end
