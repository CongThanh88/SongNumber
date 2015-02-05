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

typedef enum : NSUInteger {
    REMOTE_PING = 0x00,
    REMOTE_SONG_LIST = 0x01,
    REMOTE_RES = 0x02,
    REMOTE_1ST_RES = 0x03,
    REMOTE_PLAY = 0x04,
    REMOTE_PAUSE = 0x05,
    REMOTE_STOP = 0x06,
    REMOTE_NEXT = 0x07,
    REMOTE_SELECT = 0x08,
    REMOTE_FAVORITE = 0x09,
    REMOTE_UNFAVORITE = 0x0A,
    REMOTE_QUEUE_MOVE_UP = 0x0B,
    REMOTE_QUEUE_MOVE_FIRST = 0x0C,
    REMOTE_QUEUE_MOVE = 0x0D,
    REMOTE_QUEUE_LIST = 0x0E,
    REMOTE_DISCONNECT = 0x0F,
    REMOTE_VOLUME_UP = 0x10,
    REMOTE_VOLUME_DOWN = 0x11
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

- (void)initNetworkCommunicationToHost:(NSString*)host port:(UInt32)port;
@end
