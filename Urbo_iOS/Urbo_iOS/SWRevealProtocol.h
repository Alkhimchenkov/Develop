//
//  SWRevealProtocol.h
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWRevealProtocol <NSObject>

@required
-(void) presentMainScreenViewControllerInWindow;
-(void) dismissMainViewController;

@optional
-(void) isUserSignedUpdate;


@end
