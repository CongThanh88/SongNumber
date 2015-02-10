//
//  SNSearchSongViewController.h
//  SongNumber
//
//  Created by Cong Thanh on 8/14/14.
//  Copyright (c) 2014 com.khoisang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSongTableViewCellDelegate.h"
#import "SNSelectBoxView.h"
#import "SNToggleButton.h"
#import "KSBasePopupView.h"
#import "SNBaseViewController.h"


@interface SNSearchSongViewController : SNBaseViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SelectBoxDelegate, PopupViewDelegate, SNSongTableViewCellDelegate, NSStreamDelegate>

@property (weak, nonatomic) IBOutlet UIView *boundSearchView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;
@property (weak, nonatomic) IBOutlet SNSelectBoxView *btnNgonNgu;
@property (weak, nonatomic) IBOutlet SNSelectBoxView *btnTheLoai;
@property (weak, nonatomic) IBOutlet SNSelectBoxView *btnSort;
@property (weak, nonatomic) IBOutlet SNToggleButton *btnAll;
@property (weak, nonatomic) IBOutlet SNToggleButton *btnFree;
@property (weak, nonatomic) IBOutlet SNToggleButton *btnFavorite;
@property (weak, nonatomic) IBOutlet SNToggleButton *btnNew;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SNToggleButton *btnStop;



- (IBAction)btnDeleteText:(id)sender;
- (IBAction)btnSort:(id)sender;
- (IBAction)btnNgonNgu:(id)sender;
- (IBAction)btnTheLoai:(id)sender;
- (IBAction)btnAll:(id)sender;
- (IBAction)btnFree:(id)sender;
- (IBAction)btnFavorite:(id)sender;
- (IBAction)btnNew:(id)sender;
- (IBAction)btnStop:(id)sender;
- (IBAction)btnPause:(id)sender;
- (IBAction)btnPlay:(id)sender;
- (IBAction)btnNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSingerVoice;

- (IBAction)btnOnOffSingerVoice:(id)sender;

@property (weak, nonatomic) IBOutlet SNToggleButton *btnNext;

@end
