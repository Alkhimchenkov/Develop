//
//  DataModelTable.h
//  Urbo_iOS
//
//  Created by Андрей on 12.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import <GooglePlaces/GooglePlaces.h>

@interface DataModelTable : NSObject

@property (nonatomic, assign) NSUInteger     rowIdx;
@property (nonatomic, strong) GMSPlace       *placeClass;
@property (nonatomic, strong) NSString       *placeID;
@property (nonatomic, strong) NSDictionary   *notification;
//@property (nonatomic, strong) NSDictionary   *eventsArray;

@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, assign) BOOL           openMessage;
@property (nonatomic, strong) NSString       *address;
@property (nonatomic, strong) UIImage        *imagePlace;

@end
