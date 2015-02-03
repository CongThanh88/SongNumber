//
//  HTLyricManager.h
//  AVPlayerDemo
//
//  Created by Cong Thanh on 7/4/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLineContent.h"

@interface HTLyricManager : NSObject
@property(nonatomic,assign)Float64 startParagraphOne;
@property(nonatomic,assign)Float64 startParagraphTwo;
@property(nonatomic,assign)Float64 endParagraphOne;
@property(nonatomic,assign)Float64 endParagraphTwo;
@property(nonatomic,strong)HTLineContent *firstLineOfParagraphOne;
@property(nonatomic,strong)HTLineContent *secondLineOfparagraphOne;
@property(nonatomic,strong)HTLineContent *firstLineOfParagraphTwo;
@property(nonatomic,strong)HTLineContent *secondLineOfparagraphTwo;
@property(nonatomic,strong)NSArray *listLineLyric;
@property(nonatomic,strong)UIFont *currentFont;
@end
