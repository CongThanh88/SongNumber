//
//  HTTXTParser.h
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLineContent.h"
#import "HTLyricManager.h"

@interface HTTXTParser : NSObject
+(NSString*)getLyricsFile:(NSString*)filePath;
+(HTLyricManager*)parseFile:(NSString*)filePath;
+(NSArray*)parseString:(NSString*)fileContents;
@end
