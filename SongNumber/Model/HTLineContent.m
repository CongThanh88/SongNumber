//
//  HTLineContent.m
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTLineContent.h"
#import "NSString+Addition.h"

@implementation HTLineContent

-(id)init
{
    self = [super init];
    if (self) {
        self.startWithGenderType = None_Type;
        self.listWord = [[NSArray alloc]init];
    }
    return self;
}


+(id)parseWordsOfLine:(NSString*)contentString
{
    HTLineContent *lineContent;
    if (contentString) {
        lineContent = [[HTLineContent alloc]init];
        NSArray *listWords = [contentString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (listWords && listWords.count>0) {
            NSString *lyricOfLine = @"";
            NSArray *listResults = [[NSArray alloc]init];
            for (NSString *wordString in listWords) {
                if (![NSString isStringEmpty:wordString]) {
                    HTWordOfLine *wordResult = [HTWordOfLine parseTime:wordString];
                    if (wordResult) {
                        listResults = [listResults arrayByAddingObject:wordResult];
                    }
                    NSString *wordLyric = [HTWordOfLine parseContentString:wordString];
                    if (![NSString isStringEmpty:wordLyric]) {
                        if (![lyricOfLine isEqualToString:@""]) {
                            lyricOfLine = [lyricOfLine stringByAppendingString:@" "];
                        }
                        lyricOfLine = [lyricOfLine stringByAppendingString:wordLyric];
                    }
                }
            }
            lineContent.lineContent = lyricOfLine;
        }
    }
    


    return lineContent;
}


@end
