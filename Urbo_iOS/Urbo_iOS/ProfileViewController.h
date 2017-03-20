//
//  ProfileViewController.h
//  Urbo_iOS
//
//  Created by Андрей on 12.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button+Border.h"

@interface ProfileViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;

@property (strong, nonatomic) IBOutlet UILabel *txtID;
@property (strong, nonatomic) IBOutlet UILabel *txtUserName;
@property (strong, nonatomic) IBOutlet UILabel *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *txtFullName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButtonProfile;




@end
