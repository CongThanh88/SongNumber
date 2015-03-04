//
//  SNSongTableViewCellDelegate.h
//  IKaraoke
//
//  Created by Cong Thanh on 8/12/14.
//  Copyright (c) 2014 com.khoisang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSOngModel.h"

@protocol SNSongTableViewCellDelegate <NSObject>
-(void)addToFavorite:(SNSongModel*)song;
-(void)viewLyricSong:(SNSongModel*)song;
-(void)addToQueue:(SNSongModel*)song;
@end
