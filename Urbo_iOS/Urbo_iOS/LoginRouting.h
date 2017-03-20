//
//  LoginRouting.h
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginProtocol.h"

@interface LoginRouting : NSObject <LoginProtocol>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedInstance;


@end
