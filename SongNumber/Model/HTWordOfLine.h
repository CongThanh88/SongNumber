//
//  HTWordOfLine.h
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Addition.h"

typedef enum : NSUInteger {
    None_Type,
    Male_Type,
    Female_Type,
    MaleAndFemale_type,
} GenderType;

@interface HTWordOfLine : NSObject
@property(nonatomic, assign)NSInteger  indexOfLine;
@property(nonatomic, assign)long startTime;
@property(nonatomic, assign)long endTime;
@property(nonatomic, assign)long duration;
@property(nonatomic, strong)NSString *wordContent;
@property(nonatomic, assign)CGFloat frameWidthToStartWord;
@property(nonatomic, assign)CGFloat frameWidth;
@property(nonatomic, assign)BOOL isEndOfParagraph;
@property(nonatomic, strong)NSString *stringToStartWord;
@property(nonatomic, assign)GenderType genderType;

+(id)parseTime:(NSString*)contentString;
+(NSString*)parseContentString:(NSString*)contentString;
@end
