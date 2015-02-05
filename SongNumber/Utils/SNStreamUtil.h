//
//  SNStreamUtil.h
//  SongNumber
//
//  Created by Hai_Apple on 2/5/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNStreamUtil : NSObject
+ (BOOL) bufferFirstPackageIsNull:(uint8_t*)bufferPackage;

+ (NSUInteger) bufferFirstPackageToInt:(UInt8*)bufferFirstPackage;

+ (void) setBufferFirstPackageNull:(uint8_t*)bufferFirstPackage;

+ (NSMutableData*)readInt:(NSInputStream*) inputStream;
@end
