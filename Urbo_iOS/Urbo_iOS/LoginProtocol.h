//
//  LoginProtocol.h
//  Urbo_iOS
//
//  Created by Андрей on 17.03.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginProtocol <NSObject>

@required

-(void) presentLoginWindow;
-(void) presentMainWindow;

@optional

-(void) isUserSignedUpdate;


@end
