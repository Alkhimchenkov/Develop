//
//  Communication.h
//  Authentication
//
//  Created by Андрей on 19.12.16.
//  Copyright © 2016 Andrey Alhimchenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Communication : NSObject <NSStreamDelegate>{
    @public
        NSString *host;
        NSInteger port;
}

- (void)setup ;
- (void)close; 

@end
