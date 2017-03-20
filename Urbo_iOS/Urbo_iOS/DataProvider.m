//
//  DataProvider.m
//  Urbo_iOS
//
//  Created by Андрей on 14.01.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "DataProvider.h"

static DataProvider *sharedInstance;

@interface DataProvider () {
    NSMutableArray *_dataModels;
}

@end

@implementation DataProvider

+ (instancetype)sharedInstance
{
    if (sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
            [sharedInstance loadData];
        });
    }
    return sharedInstance;
}

- (NSArray *)getData
{
    return [NSArray arrayWithArray:_dataModels];
}

- (void)setData:(NSArray *)newData
{
    _dataModels = [NSMutableArray arrayWithArray:newData];
}

#pragma mark - private methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)saveData
{
  //  BOOL res = [_dataModels writeToFile:@"SAVEFILE.DATA" atomically:YES];
   // NSLog(@"File has %@been written", res ? @"" : @"not ");
}

- (void)loadData
{
    _dataModels = [_dataModels initWithContentsOfFile:@"SAVEFILE.DATA"];
    if (_dataModels == nil) {
        _dataModels = [[NSMutableArray alloc] init];
    }
}

@end
