//
//  BorderRoundButton.m
//  AVPlayerDemo
//
//  Created by Apple on 6/24/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "BorderRoundButton.h"

@implementation UIButton (BorderRound)
-(void)setBorderRound
{
    [super layoutSubviews];
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.5f;
}
@end
