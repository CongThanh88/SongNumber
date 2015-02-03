//
//  SNSelectBoxView.h
//
//  Created by ThanhDC4 on 3/8/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSelectButtonView.h"

@protocol SelectBoxDelegate <NSObject>

-(void)didSelectedItem:(NSDictionary*)item;

@end

@interface SNSelectBoxView : SNSelectButtonView<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *listItem;
@property(nonatomic, assign) float tableWidth;
@property(nonatomic, weak) id<SelectBoxDelegate> delegate;
-(void)setItemSelected:(NSDictionary *)itemSelected;
-(void)hidePopup;
-(BOOL)isShowingPopup;
@end
