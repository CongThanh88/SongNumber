//
//  HTWordOfLine.m
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTWordOfLine.h"
#import "NSString+Addition.h"

@implementation HTWordOfLine

-(id)init{
    self = [super init];
    if (self) {
        self.genderType = None_Type;
        self.isEndOfParagraph = NO;
    }
    return self;
}

+(id)parseTime:(NSString *)contentString
{
    HTWordOfLine *word;
    if (![NSString isStringEmpty:contentString]) {
        word = [[HTWordOfLine alloc]init];
        NSRange startRange = [contentString rangeOfString:@"["];
        NSRange endRange = [contentString rangeOfString:@"]"];
        if (startRange.location+1 <= endRange.location-1) {
            word.wordContent = [contentString substringFromIndex:endRange.location+1];
            
        }
    }
    return word;
}

+(NSString*)parseContentString:(NSString*)contentString
{
    if (![NSString isStringEmpty:contentString]) {
        NSRange startRange = [contentString rangeOfString:@"]"];
        if (startRange.location+1 < contentString.length) {
            NSString * content = [contentString substringFromIndex:startRange.location+1];
            if (![NSString isStringEmpty:content]) {
                if ([content hasPrefix:@"+="]) {
                    content = [content substringFromIndex:2];
                }else if (([content hasPrefix:@"+"] || [content hasPrefix:@"="])) {
                    content = [content substringFromIndex:1];
                }
            }
            
            return content;
        }
    }
    return @"";
}
@end
