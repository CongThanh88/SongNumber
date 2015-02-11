//
//  SNToggleButton.m
//  SongNumber
//
//  Created by Apple on 10/8/14.
//  Copyright (c) 2014 KS.songnumber. All rights reserved.
//

#import "SNToggleButton.h"

@implementation SNToggleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.backgroundColor = MENU_BOTTOM_BG_COLOR;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
