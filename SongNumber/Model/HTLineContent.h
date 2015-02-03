//
//  HTLineContent.h
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTWordOfLine.h"

@interface HTLineContent : NSObject
@property(nonatomic, assign)NSInteger lineIndex;
@property(nonatomic, strong)NSString  *lineContent;
@property(nonatomic, assign)long startTime;
@property(nonatomic, assign)long endTime;
@property(nonatomic, strong)NSArray *listWord;
@property(nonatomic, assign)BOOL isEndOfParagraph;
@property(nonatomic, assign)BOOL isStartParagraph;
@property(nonatomic, assign)GenderType startWithGenderType;

+(id)parseWordsOfLine:(NSString*)contentString;
@end
