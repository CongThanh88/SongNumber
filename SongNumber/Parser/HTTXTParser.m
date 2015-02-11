//
//  HTTXTParser.m
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/16/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTTXTParser.h"


@implementation HTTXTParser

+(NSString*)getLyricsFile:(NSString*)filePath
{
    NSString *lyricMusic;
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        NSString *fileContents =  [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error:&error];
        if(fileContents)
        {
            NSArray *lineContents = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if (lineContents && lineContents.count>0) {
                for (int i=0; i<lineContents.count; i++ ) {
                    NSString *lineContent = [lineContents objectAtIndex:i];
                    if (![NSString isStringEmpty:lineContent]) {
                        NSArray *listWords = [lineContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if (listWords && listWords.count>0) {
                            for (int wordIndex =0; wordIndex <listWords.count; wordIndex++) {
                                NSString *wordString = [listWords objectAtIndex:wordIndex];
                                if (![NSString isStringEmpty:wordString]) {
                                    NSString *wordLyric = [HTWordOfLine parseContentString:wordString];
                                    if (![NSString isStringEmpty:wordLyric]) {
                                        if (![NSString isStringEmpty:lyricMusic]) {
                                            if (wordIndex!=0) {
                                                 lyricMusic = [lyricMusic stringByAppendingString:@" "];
                                            }
                                            lyricMusic = [lyricMusic stringByAppendingString:wordLyric];
                                        }else{
                                            lyricMusic = wordLyric;
                                        }
                                        
                                    }
                                }
                            }
                        }
                        if (![NSString isStringEmpty:lyricMusic]) {
                            lyricMusic = [lyricMusic stringByAppendingString:@"\n"];
                        }
                    }
                }
                
            }
        }
    }
    return lyricMusic;
}

+(HTLyricManager*)parseFile:(NSString*)filePath
{
    HTLyricManager *lyricManager;
    NSArray *listLine;
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        NSString *fileContents =  [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error:&error];
        if(fileContents)
        {
            lyricManager = [[HTLyricManager alloc]init];
            //set current font
            
            listLine = [[NSArray alloc]init];
            HTLineContent *result = [[HTLineContent alloc]init];
            NSArray *lineContents = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if (lineContents && lineContents.count>0) {                for (int i=0; i<lineContents.count; i++ ) {
                    NSString *contentOfLine = [lineContents objectAtIndex:i];
                    if(![NSString isStringEmpty:contentOfLine] && [contentOfLine hasPrefix:@"["]){
                        HTLineContent *lineOfParagraph = [HTLineContent parseWordsOfLine:contentOfLine];
                        result.listWord = [result.listWord arrayByAddingObject:lineOfParagraph];
                        listLine = [listLine arrayByAddingObject:lineOfParagraph];
                    }
                }
                
                //Update endtime of the last word of  the lines
                for (int i=0; i<listLine.count; i++) {
                    HTLineContent *startLine = [listLine objectAtIndex:i];
                    if ((i+1) < listLine.count) {
                        HTLineContent *endLine = [listLine objectAtIndex:i+1];
                        if (startLine && endLine) {
                            HTWordOfLine *startWord = [startLine.listWord lastObject];
                            HTWordOfLine *endWord = [endLine.listWord firstObject];
                            if (startWord && endWord){
                                startWord.endTime = endWord.startTime;
                                //Check if the line is end of paragraph
                                if(startWord.endTime - startWord.startTime > 15000){
                                    startWord.endTime = startWord.startTime + 20;
                                    startWord.isEndOfParagraph = YES;
                                    endLine.isStartParagraph = YES;
                                    //setup start time of paragraph 2
                                    lyricManager.startParagraphTwo = endWord.startTime - 3000;
                                    //setup end time of paragraph 1
                                    lyricManager.endParagraphOne = startWord.endTime + 500;
                                    
                                    //setup firstline of paragraph two
                                    lyricManager.firstLineOfParagraphTwo = endLine;
                                    //setup secondline of paragraph two
                                    if (i+2 <listLine.count) {
                                        HTLineContent *secondLineOfParagraphTwo = [listLine objectAtIndex:i+2];
                                        if (secondLineOfParagraphTwo) {
                                            lyricManager.secondLineOfparagraphTwo = secondLineOfParagraphTwo;
                                        }
                                        
                                    }
                                }else{
                                    startWord.endTime = endWord.startTime;
                                }
                            }
                            //Update duration
                            startWord.duration = startWord.endTime - startWord.startTime;
                        }
                    }else if(i == listLine.count-1){//the line is end of paragraph
                        HTWordOfLine *endWord = [startLine.listWord lastObject];
                        endWord.endTime = endWord.startTime + 20;
                        endWord.duration = endWord.endTime - endWord.startTime;
                        endWord.isEndOfParagraph = YES;
                        //setup endtime of paragraph 2
                        lyricManager.endParagraphTwo = endWord.endTime + 500;
                    }
                  
                }
                
                GenderType genderType = None_Type;
                //Update endtime of the line
                for (int i=0; i<listLine.count; i++) {
                    HTLineContent *lineContent = [listLine objectAtIndex:i];
                    if (lineContent) {
                        lineContent.endTime = ((HTWordOfLine*)[lineContent.listWord lastObject]).endTime;
                        //setup start time of paragraph 1
                        if(i==0){//the line is start of paragraph
                            lineContent.isStartParagraph = YES;
                            lyricManager.firstLineOfParagraphOne = lineContent;
                            lyricManager.startParagraphOne = lineContent.startTime - 3000;
                            if (lyricManager.startParagraphOne < 0) {
                                lyricManager.startParagraphOne = 0;
                            }
                        }else if(i==1){
                            lyricManager.secondLineOfparagraphOne = lineContent;
                        }
                       
                        if (lineContent.startWithGenderType != None_Type && lineContent.startWithGenderType != genderType){
                            genderType = lineContent.startWithGenderType;
                        }
                        lineContent.startWithGenderType = genderType;
                        
                    }
                }
                
            }
            lyricManager.listLineLyric = listLine;
        }
    }
    
    if (lyricManager && lyricManager.endParagraphOne == -1 && lyricManager.startParagraphTwo ==-1 && lyricManager.endParagraphTwo!=-1) {
        lyricManager.endParagraphOne = lyricManager.endParagraphTwo;
        lyricManager.endParagraphTwo = -1;
    }
    return lyricManager;

}


+(NSArray*)parseString:(NSString *)fileContents
{
    NSArray *listLine;
        if(fileContents)
        {
            listLine = [[NSArray alloc]init];
            HTLineContent *result = [[HTLineContent alloc]init];
            NSArray *lineContents = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if (lineContents && lineContents.count>0) {
                for (int i=0; i<lineContents.count; i++ ) {
                    NSString *contentOfLine = [lineContents objectAtIndex:i];
                    if(contentOfLine && ![contentOfLine isEqualToString:@""]){
                        HTLineContent *lineOfParagraph = [HTLineContent parseWordsOfLine:contentOfLine];
                        result.listWord = [result.listWord arrayByAddingObject:lineOfParagraph];
                        listLine = [listLine arrayByAddingObject:lineOfParagraph];
                        if (i+1< lineContents.count) {
                            NSString *nextLineContent = [lineContents objectAtIndex:i+1];
                            if (!nextLineContent || [nextLineContent isEqualToString:@""]) {
                                lineOfParagraph.isEndOfParagraph = YES;
                            }
                        }
                    }
                }
                
                //Update endtime of the last word of  the lines
                for (int i=0; i<listLine.count; i++) {
                    HTLineContent *startLine = [listLine objectAtIndex:i];
                    if (!startLine.isEndOfParagraph && (i+1) < listLine.count) {
                        HTLineContent *endLine = [listLine objectAtIndex:i+1];
                        if (startLine && endLine) {
                            HTWordOfLine *startWord = [startLine.listWord lastObject];
                            HTWordOfLine *endWord = [endLine.listWord firstObject];
                            if (startWord && endWord) {
                                startWord.endTime = endWord.startTime;
                            }
                        }
                    }else{
                        HTWordOfLine *startWord = [startLine.listWord lastObject];
                        startWord.endTime = startWord.startTime + 20;
                    }
                    
                }
                
                //Update endtime of the line
                for (int i=0; i<listLine.count; i++) {
                    HTLineContent *lineContent = [listLine objectAtIndex:i];
                    if (lineContent) {
                        lineContent.endTime = ((HTWordOfLine*)[lineContent.listWord lastObject]).endTime;
                    }
                }
                
            }
            return listLine;
        }
//    }
    return nil;
    
}

@end
