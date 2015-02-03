//
//  HTLyricManager.m
//  AVPlayerDemo
//
//  Created by Cong Thanh on 7/4/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTLyricManager.h"

@implementation HTLyricManager
-(id)init
{
    self = [super init];
    if (self) {
        self.startParagraphOne = -1;
        self.startParagraphTwo = -1;
        self.endParagraphOne = -1;
        self.endParagraphTwo = -1;
    }
    return self;
}



@end
