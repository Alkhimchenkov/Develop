//
//  DataProvider.h
//  Urbo_iOS
//
//  Created by Андрей on 14.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)getData;
- (void)setData:(NSArray *)newData;
- (void)saveData;
- (void)loadData;

@end
