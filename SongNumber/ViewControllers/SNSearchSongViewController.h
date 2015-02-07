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
#import "SNScanQRCodeViewController.h"
#import "MBProgressHUD.h"
#import <Foundation/NSStream.h>

#define PORT       2468

typedef enum : unsigned char {
    REMOTE_PING = 0,
    REMOTE_SONG_LIST = 1,
    REMOTE_RES = 2,
    REMOTE_1ST_RES = 3,
    REMOTE_PLAY = 4,
    REMOTE_PAUSE = 5,
    REMOTE_STOP = 6,
    REMOTE_NEXT = 7,
    REMOTE_SELECT_TRACK = 8,
    REMOTE_FAVORITE = 9,
    REMOTE_UNFAVORITE = 10,
    REMOTE_QUEUE_MOVE_UP = 11,
    REMOTE_QUEUE_MOVE_FIRST = 12,
    REMOTE_QUEUE_REMOVE = 13,
    REMOTE_QUEUE_LIST = 14,
    REMOTE_DISCONNECT = 15,
    REMOTE_VOLUME_UP = 16,
    REMOTE_VOLUME_DOWN = 17,
    REMOTE_MESSAGE = 18,
    REMOTE_SCORING = 19
} REMOTE;

@interface SNSearchSongViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SelectBoxDelegate, PopupViewDelegate, SNSongTableViewCellDelegate, NSStreamDelegate, ScanQRCodeViewControllerDelegate>

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
@property (nonatomic, strong) MBProgressHUD *loadingView;
@property (strong, nonatomic) UILabel *notifyView;


- (IBAction)btnDeleteText:(id)sender;
- (IBAction)btnSort:(id)sender;
- (IBAction)btnNgonNgu:(id)sender;
- (IBAction)btnTheLoai:(id)sender;
- (IBAction)btnAll:(id)sender;
- (IBAction)btnFree:(id)sender;
- (IBAction)btnFavorite:(id)sender;
- (IBAction)btnNew:(id)sender;
- (IBAction)btnScanCode:(id)sender;
- (IBAction)btnStop:(id)sender;
- (IBAction)btnPause:(id)sender;
- (IBAction)btnPlay:(id)sender;
- (IBAction)btnOnOffSingerVoice:(id)sender;

@property (weak, nonatomic) IBOutlet SNToggleButton *btnNext;




- (void)initNetworkCommunicationToHost:(NSString*)host port:(UInt32)port;
@end
