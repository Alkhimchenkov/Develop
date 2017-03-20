//
//  SWRevealRouting.h
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWRevealProtocol.h"

@interface SWRevealRouting : NSObject <SWRevealProtocol>

@property (strong, nonatomic) UIWindow *window;

@end
