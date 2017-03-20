//
//  Communication.m
//  Authentication
//
//  Created by Андрей on 19.12.16.
//  Copyright © 2016 Andrey Alhimchenkov. All rights reserved.
//

#import "Communication.h"
#import "Constatns.h"


CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

//NSMutableArray  *messagesRecive;


@interface Communication()

//@property (nonatomic, strong) NSDictionary *dictMessage;


@end


@implementation Communication


- (void) messageReceived:(NSString *)message type:(int)typePacket{

    NSDictionary *dictMessage = [NSDictionary dictionaryWithObjectsAndKeys:[NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil], @"message", [NSNumber numberWithInt:typePacket], @"type", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil userInfo:dictMessage];
    
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{    
    switch (eventCode) {
            
        case NSStreamEventOpenCompleted:
            //NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:

            if (aStream == inputStream){
              //  NSLog(@"inputStream is ready.");
                
                uint8_t buf[6];
                 
                NSInteger len = 0;
                
              //  NSLog(@"%@", buf);
                
                
                len = [inputStream read:buf maxLength:sizeof(buf)];
                
              //  NSLog(@"after %lu", len);
                
                if ((len > 0) && (( buf[0] == 1 ) || ( buf[0] == 2 ))) {
                    
                    
                    uint32_t lenght = 0; memcpy(&lenght, buf+2, 4);
                    
                    uint8_t *buffer = malloc(lenght);
                    
                    NSInteger len_buffer = 0;
                    
                    len_buffer = [inputStream read:buffer maxLength:lenght];
                    
                 //   NSLog(@"before %lu", len_buffer);
                    
                
                    if (len_buffer > 0){

                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len_buffer encoding:NSASCIIStringEncoding];
                        
                        
                      //  NSLog(@"%@", output);
                        
                        if (nil != output)
                     //   NSLog(@"type Communication %i", buf[0]);
                    
                        
                        [self messageReceived:output type:buf[0]];
                    //    NSLog(@"Reading in the following:");
                      //  NSLog(@"%@", output);
                    }
                }
            }
            
//                while ([inputStream hasBytesAvailable])
//                {
//                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
//                    if (len > 0)
//                    {
//                        NSString *output = [[NSString alloc] initWithBytes:buffer+6 length:len-6 encoding:NSASCIIStringEncoding];
//                        
//                        if (nil != output)
//                        {
//                            NSLog(@"server said: %@", output);
//                            [self messageReceived:output type:buffer[0]];
//                        }
//                    }
//                }
//            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
           // NSLog(@"Stream has space available now");
            break;
            
        case NSStreamEventErrorOccurred:
          //  NSLog(@"%@",[aStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //NSLog(@"close stream");
            break;
        default:
            break;
           // NSLog(@"Unknown event");
    }
    
    
}


-(void)setup{
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)host,(int)port, &readStream, &writeStream);
   // messagesRecive = [[NSMutableArray alloc] init];
    
    [self open];

}

-(void)open {
    
   // NSLog(@"Opening streams.");
    
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
}


-(void)close {
   // NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    
}


@end
