//
//  SNStreamUtil.m
//  SongNumber
//
//  Created by Hai_Apple on 2/5/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import "SNStreamUtil.h"

@implementation SNStreamUtil
+ (BOOL) bufferFirstPackageIsNull:(uint8_t*)bufferPackage
{
    for(int i=0;i<sizeof(bufferPackage);i++)
    {
        if(bufferPackage[i] != '\0' )
            return NO;
    }
    return YES;
}

+ (NSUInteger) bufferFirstPackageToInt:(UInt8*)bufferFirstPackage
{
    return (((int)bufferFirstPackage[0])<<24) + (((int)bufferFirstPackage[1])<<16) + (((int)bufferFirstPackage[2])<<8) + (((int)bufferFirstPackage[3]));
}

+ (void) setBufferFirstPackageNull:(uint8_t*)bufferFirstPackage
{
    for(int i=0;i<sizeof(bufferFirstPackage);i++)
    {
        bufferFirstPackage[i] = '\0';
    }
}

+ (NSMutableData*)readInt:(NSInputStream*) inputStream
{
    NSMutableData* result = [NSMutableData data];
    //
    uint8_t tempByte[1];
    NSUInteger totalLengthRead = 0;
    NSInteger lengthRead;
    do
    {
        if([inputStream hasBytesAvailable])
        {
            lengthRead = [inputStream read:tempByte maxLength:sizeof(tempByte)];
            if(lengthRead>0)
            {
                totalLengthRead = totalLengthRead + lengthRead;
                [result appendData:[NSData dataWithBytes:tempByte length:sizeof(tempByte)]];
            }
        }
        
        [NSThread sleepForTimeInterval:0.0025f];
    }
    while (totalLengthRead < sizeof(int));
    return result;
}
@end
