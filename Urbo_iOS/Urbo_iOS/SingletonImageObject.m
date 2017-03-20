//
//  SingletonImageObject.m
//  Authentication
//
//  Created by Андрей on 12.12.16.
//  Copyright © 2016 com.urbolabs.urbo. All rights reserved.
//

#import "SingletonImageObject.h"

@implementation SingletonImageObject


+(SingletonImageObject*)sigleton{
    
    static SingletonImageObject *sigleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sigleton = [[SingletonImageObject alloc] init];
    });
    
    return sigleton;
}


-(NSString*)getCacheDirectoryPath{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [array objectAtIndex:0];
 
}


-(BOOL)createDirectory:(NSString*)pathDirectory{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}


-(UIImage*)imageFromCache:(NSString*)pathJSON{
    
    NSString *nameImage = [pathJSON lastPathComponent];
    
    NSString *cachePathDir = [NSString stringWithFormat:@"%@/Cache", [self getCacheDirectoryPath]];
    
    NSString *cachePathFile = [NSString stringWithFormat:@"%@/Cache/%@", [self getCacheDirectoryPath], nameImage];
    
    
    if ([self createDirectory:cachePathDir]){
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePathFile]){
    
           NSData *imageData = UIImagePNGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pathJSON]]]);
            [imageData writeToFile:cachePathFile atomically:YES];
        }
    
    }
    
    return [UIImage imageWithContentsOfFile:cachePathFile];

}

@end
