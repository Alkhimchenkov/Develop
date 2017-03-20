//
//  SingletonImageObject.h
//  Authentication
//
//  Created by Андрей on 12.12.16.
//  Copyright © 2016 com.urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface SingletonImageObject : NSObject


+(SingletonImageObject*)sigleton;
-(UIImage*)imageFromCache:(NSString*)pathJSON;

@end
