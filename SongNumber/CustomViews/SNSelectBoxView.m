//
//  SNSelectBoxView.m
//
//  Created by ThanhDC4 on 3/8/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import "SNSelectBoxView.h"
#import "HTLocalizeHelper.h"
#define TABLE_WIDTH

@implementation SNSelectBoxView
{
    NSIndexPath *_indexPathSelected;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableWidth = 130;
        _indexPathSelected = [NSIndexPath indexPathForRow:0 inSection:0];
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tableWidth = 130;
        _indexPathSelected = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

-(void)hidePopup
{
    if (!_tableView.hidden) {
        _tableView.hidden = YES;
    }
}

-(BOOL)isShowingPopup
{
    if (!_tableView) {
        return NO;
    }
    return !_tableView.hidden;
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents {
    if(controlEvents == UIControlEventTouchUpInside) {
        // show list data
        if (_listItem.count>0) {
            if (!_tableView) {
                _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame)+1, _tableWidth, 75)];
                //Set border to table
                _tableView.layer.borderColor = [UIColor grayColor].CGColor;
                _tableView.layer.cornerRadius = 2;
                _tableView.layer.borderWidth = 0.5;
                //
                if (IS_IOS7) {
                    _tableView.separatorInset = UIEdgeInsetsZero;
                }
                _tableView.backgroundColor = [UIColor whiteColor];
                _tableView.dataSource = self;
                _tableView.delegate = self;
                 [_tableView selectRowAtIndexPath:_indexPathSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.superview addSubview:_tableView];
            }else{
                if (_tableView.hidden) {
                    _tableView.hidden = NO;
                    [_tableView reloadData];
                    [_tableView selectRowAtIndexPath:_indexPathSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
                }else{
                    _tableView.hidden = YES;
                }
            }
        }
        
    }
}

-(void)setTableWidth:(float)tableWidth
{
     _tableWidth = tableWidth;
    if (_tableView) {
        CGRect tableFrame = _tableView.frame;
        tableFrame.size.width = tableWidth;
        _tableView.frame = tableFrame;
    }
   
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listItem) {
        return _listItem.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIndentifier = [NSString stringWithFormat:@"cellReuse_%d",(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemCell"];
    }
    NSDictionary *dicItem = [_listItem objectAtIndex:indexPath.row];
    if (dicItem) {
        UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 2, cell.frame.size.width, 16)];
        txtLabel.backgroundColor = [UIColor clearColor];
        NSString *lsName = [dicItem objectForKey:@"name"];
        txtLabel.text = LocalizedString(lsName);
        txtLabel.font =[UIFont systemFontOfSize:13];
        [cell addSubview:txtLabel];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView && !_tableView.hidden) {
        _indexPathSelected = indexPath;
        [super setItemSelected:[_listItem objectAtIndex:indexPath.row]];
        if (_delegate) {
            [_delegate didSelectedItem:[_listItem objectAtIndex:indexPath.row]];
        }
        _tableView.hidden = YES;
    }
}

-(void)setListItem:(NSArray *)listItem{
    _listItem = listItem;
}



-(void)setItemSelected:(NSDictionary *)itemSelected
{
    [super setItemSelected:itemSelected];
    long itemIndex = [_listItem indexOfObject:itemSelected];
    if (itemIndex>-1) {
        _indexPathSelected = [NSIndexPath indexPathForRow:itemIndex inSection:0];
    }
    if (_tableView) {
        [_tableView selectRowAtIndexPath:_indexPathSelected animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

                                 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
