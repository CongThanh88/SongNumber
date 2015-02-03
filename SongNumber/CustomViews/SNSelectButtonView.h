//
//  SNSelectButtonView.h
//
//  Created by ThanhDC4 on 3/4/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderRoundButton.h"

@interface SNSelectButtonView : UIButton
@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, strong) NSDictionary *itemSelected;
-(void)setFontSize:(NSInteger)fontSize;
-(NSDictionary*)getSelectedItem;
-(void)updateText;
@end
