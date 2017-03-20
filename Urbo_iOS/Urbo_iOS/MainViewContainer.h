//
//  MainViewContainer.h
//  Urbo_iOS
//
//  Created by Андрей on 09.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MainViewContainerDelegate;

@interface MainViewContainer : UIViewController


@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIButton *placeBtn;

- (IBAction)showPopoverView:(id)sender;
- (IBAction)clickPlace:(id)sender;

@end

@protocol MainViewContainerDelegate <NSObject>

@optional
-(void) callButtonTouch;

@end
