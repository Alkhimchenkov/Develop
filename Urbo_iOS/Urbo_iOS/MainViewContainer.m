//
//  MainViewContainer.m
//  Urbo_iOS
//
//  Created by Андрей on 09.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "MainViewContainer.h"
#import "SWRevealViewController.h"
#import "PopoverViewController.h"
#import "UserIsSigned.h"
//#import "LoginViewController.h"
#import "DataProvider.h"
#import "Constatns.h"

#import "MainViewController.h"
#import "MapsViewController.h"


@interface MainViewContainer () <UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) MainViewController *mainView;
@property (strong, nonatomic) MapsViewController *mapsView;


@property (strong, nonatomic) PopoverViewController *itemPopVC;

@property (strong, nonatomic) IBOutlet UIView *containerViewEmbed;

@property (strong, nonatomic) IBOutlet UISwitch *switchMap;

@property (strong, nonatomic) SWRevealRouting *navigator;


- (IBAction)switchMapAction:(id)sender;


@end

@implementation MainViewContainer

#pragma mark - view method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    self.navigator = revealViewController.navigator;
    
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self initButton];
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.mainView = (MainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.mapsView = (MapsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MapsViewController"];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidSelectedPopever:) name:@"click" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showLoginViewController];
}


-(void)dealloc{
 //   NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}


#pragma mark method Notification
- (void)tableDidSelectedPopever:(NSNotification *)notification{
    [self.itemPopVC dismissViewControllerAnimated:NO completion:nil];
    self.itemPopVC = nil;
    
    NSIndexPath *indexpath = (NSIndexPath *)notification.object;
    switch (indexpath.row) {
        case 0:
            break;
        case 1:
            [self clickLogout];
            break;
    }
}


#pragma mark- custom method
- (void)clickLogout{
    UserIsSigned *userInfoRequest = [[UserIsSigned alloc] init];
    [userInfoRequest updateIsSigned:NO];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigator dismissMainViewController];
   // [self showLoginViewController];
}


#pragma mark - IBAction
- (IBAction)showPopoverView:(id)sender{
    self.itemPopVC = [[PopoverViewController alloc] init];
    self.itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    self.itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    self.itemPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.itemPopVC animated:YES completion:nil];
}

- (IBAction)clickPlace:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callSearchPlace" object:nil];
}


- (IBAction)switchMapAction:(id)sender {
    
//    if ([self.switchMap isOn]){
//        [self showMapsViewController];
//    } else {
//        [self showMainViewController];
//    }

    if ([self.switchMap isOn]){
        [self switchFromViewController:self.mainView toViewController:self.mapsView];
    } else {
        [self switchFromViewController:self.mapsView toViewController:self.mainView];
    }
    
    [[NSUserDefaults standardUserDefaults]  setObject:[NSNumber numberWithBool:[self.switchMap isOn]] forKey:@"switchMaps"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.placeBtn setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"switchMaps"] boolValue]];      
}


#pragma mark - method delegate popover contorller
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [self.itemPopVC dismissViewControllerAnimated:NO completion:nil];
    return NO;
}


#pragma mark - call Login View
-(void)showLoginViewController{
//    if (![GLOBAL_APP_DELEGATE isSigned]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginView =  (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
//
//        [loginView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        [loginView setModalPresentationStyle:UIModalPresentationFullScreen];
//
//        [self.parentViewController presentViewController:loginView animated:YES completion:nil];
//    } else {
    
        [self.switchMap setOn: [[[NSUserDefaults standardUserDefaults] objectForKey:@"switchMaps"] boolValue]];
      //  !([self.switchMap isOn]) ? [self showMainViewController]:[self showMapsViewController];
        !([self.switchMap isOn]) ? [self switchFromViewController:self.mapsView toViewController:self.mainView]:
                                   [self switchFromViewController:self.mainView toViewController:self.mapsView];

//    }
}


#pragma mark - button over uitableview
-(void)initButton{
    self.placeBtn.layer.borderColor = UIColorFromHEX(COLOR_ACCENT).CGColor;
    self.placeBtn.backgroundColor = UIColorFromHEX(COLOR_ACCENT);
    self.placeBtn.layer.cornerRadius = 48 / 2.0f;
    self.placeBtn.clipsToBounds = YES;
}

#pragma mark - methods show Embed UIViewController
-(void)showMainViewController{
    
    [self.mapsView willMoveToParentViewController:nil];
    [self.mapsView.view removeFromSuperview];
    [self.mapsView removeFromParentViewController];
    self.mapsView = nil;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainView = (MainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    self.mainView = mainView;
    [self addChildViewController:self.mainView];
    self.mainView.view.frame = self.containerViewEmbed.bounds;
    [self.containerViewEmbed addSubview:self.mainView.view];
    [self.mainView didMoveToParentViewController:self];
}

-(void)showMapsViewController{
    
    [self.mainView willMoveToParentViewController:nil];
    [self.mainView.view removeFromSuperview];
    [self.mainView removeFromParentViewController];
    self.mainView = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapsViewController *mapsView = (MapsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MapsViewController"];
    
    self.mapsView = mapsView;
    [self addChildViewController:self.mapsView];
    self.mapsView.view.frame = self.containerViewEmbed.bounds;
    [self.containerViewEmbed addSubview:self.mapsView.view];
    [self.mapsView didMoveToParentViewController:self];
}


-(void)switchFromViewController:(UIViewController*)oldViewController toViewController:(UIViewController*)newViewController{
    
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
//    oldViewController = nil;
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    if ([oldViewController isKindOfClass:([MapsViewController class])]) {
//        newViewController = (MainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    } else {
//        newViewController = (MapsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MapsViewController"];
//    }
    
    
    [self addChildViewController:newViewController];
    newViewController.view.frame = self.containerViewEmbed.bounds;
    [self.containerViewEmbed addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:self];
    
}


@end
