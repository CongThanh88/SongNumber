//
//  HTLyricsDetailViewController.h
//  IKaraoke
//
//  Created by Cong Thanh on 8/12/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSongModel.h"

@interface HTLyricsDetailViewController : UIViewController
@property (strong, nonatomic) SNSongModel *song;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtLyricContent;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;

@end
