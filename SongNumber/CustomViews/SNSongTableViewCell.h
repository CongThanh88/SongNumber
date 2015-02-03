//
//  SNSongTableViewCell.h
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.khoisang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSongModel.h"
#import "SNSongTableViewCellDelegate.h"

@interface SNSongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imvFree;
@property (weak, nonatomic) IBOutlet UIImageView *imvType;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSongNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblNhacSy;
@property (weak, nonatomic) IBOutlet UILabel *lblShortLyric;
@property (strong, nonatomic) SNSongModel *songModel;
- (IBAction)btnViewLyric:(id)sender;
- (IBAction)btnAddToFavorite:(id)sender;
@property (weak, nonatomic) id<SNSongTableViewCellDelegate>delegate;
-(void)setUpWithSong:(SNSongModel*)song;

@end
