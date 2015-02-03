//
//  HTSelectButtonView.m
//
//  Created by ThanhDC4 on 3/4/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import "SNSelectButtonView.h"
#import "HTLocalizeHelper.h"

@implementation SNSelectButtonView
{
    UILabel *_lblItemName;
    UIImageView *dropdownImageView;
    UIImageView *iconView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //_borderColor = [UIColor grayColor];
        //item name
        _lblItemName = [[UILabel alloc]initWithFrame:CGRectMake(22, self.frame.size.height- 22, self.frame.size.width-42,14)];
        _lblItemName.backgroundColor = [UIColor clearColor];
        _lblItemName.textColor = MENU_TEXT_COLOR;
        _lblItemName.font = [UIFont systemFontOfSize:12];
        _lblItemName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lblItemName];
        
        dropdownImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_filter_drop_down.png"]];
        CGRect dropDownImageFrame = dropdownImageView.frame;
        dropDownImageFrame.size = CGSizeMake(14, 14);
        dropDownImageFrame.origin.y = (self.frame.size.height - dropDownImageFrame.size.height)/2;
        dropDownImageFrame.origin.x = self.frame.size.width - dropDownImageFrame.size.width - 3;
        dropdownImageView.frame = dropDownImageFrame;
        [self addSubview:dropdownImageView];
        //[self setBorderRound];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //_borderColor = [UIColor whiteColor];
        //item name
        _lblItemName = [[UILabel alloc]initWithFrame:CGRectMake(22, self.frame.size.height-22, self.frame.size.width-42,14)];
        _lblItemName.textColor = MENU_TEXT_COLOR;
        _lblItemName.backgroundColor = [UIColor clearColor];
        _lblItemName.font = [UIFont systemFontOfSize:12];
        _lblItemName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lblItemName];
        
        dropdownImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_filter_drop_down.png"]];
        CGRect dropDownImageFrame = dropdownImageView.frame;
        dropDownImageFrame.size = CGSizeMake(14, 14);
        dropDownImageFrame.origin.y = (self.frame.size.height - dropDownImageFrame.size.height)/2;
        dropDownImageFrame.origin.x = self.frame.size.width - dropDownImageFrame.size.width - 3;
        dropdownImageView.frame = dropDownImageFrame;
        [self addSubview:dropdownImageView];
        //[self setBorderRound];
        //
    }
    return self;
}

-(void)setIcon:(UIImage *)icon
{
    _icon = icon;
    iconView = [[UIImageView alloc]initWithImage:icon];
    CGRect iconFrame = iconView.frame;
    iconFrame.origin.x = 2;
    iconFrame.size.height = iconFrame.size.width = 18;
    iconFrame.origin.y = (self.frame.size.height - iconFrame.size.height)/2;
    iconView.frame = iconFrame;
    [self addSubview:iconView];
}

-(void)setBorderRound
{
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

-(void)setItemSelected:(NSDictionary *)itemSelected
{
    _itemSelected = itemSelected;
    if (_itemSelected) {
        NSString *lsName = [_itemSelected objectForKey:@"name"];
        _lblItemName.text = LocalizedString(lsName);
    }
}

-(void)updateText
{
    if (_itemSelected) {
        NSString *lsName = [_itemSelected objectForKey:@"name"];
        _lblItemName.text = LocalizedString(lsName);
    }
}

-(NSDictionary*)getSelectedItem
{
    return _itemSelected;
}


-(void)setFontSize:(NSInteger)fontSize
{
    _lblItemName.font = [UIFont systemFontOfSize:fontSize];
}

-(void)layoutSubviews{
    CGRect nameFrame = _lblItemName.frame;
    nameFrame.origin.y = (self.frame.size.height - nameFrame.size.height)/2;
    _lblItemName.frame = nameFrame;
}
@end
