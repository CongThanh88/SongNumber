//
//  HTSongOfflineTableViewCell.m
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "SNSongTableViewCell.h"
#import "HTLocalizeHelper.h"
#import "NSString+Addition.h"

@implementation SNSongTableViewCell
{
    UIActivityIndicatorView *activityIndicator;
    UIButton *btnViewLyric;
    UIButton *btnAddToFavorite;
}


- (void)awakeFromNib
{
    if (IS_IPAD) {
        // Initialization code
        UITapGestureRecognizer *cellTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addSongToQueue)];
        [self addGestureRecognizer:cellTapGesture];
        
        if (!btnAddToFavorite) {
            btnAddToFavorite = [[UIButton alloc]initWithFrame:CGRectMake(530, 46, 186, 28)];
            btnAddToFavorite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btnAddToFavorite.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            [btnAddToFavorite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnAddToFavorite.titleLabel.font = [UIFont systemFontOfSize:11];
            [btnAddToFavorite addTarget:self action:@selector(addToFavorite:) forControlEvents:UIControlEventTouchUpInside];
            [btnAddToFavorite setImage:[UIImage imageNamed:@"menu_favorite.png"] forState:UIControlStateNormal];
            [self addSubview:btnAddToFavorite];
        }
        
        if (!btnViewLyric) {
            btnViewLyric = [[UIButton alloc]initWithFrame:CGRectMake(530, 9, 186, 28)];
            btnViewLyric.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btnViewLyric.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btnViewLyric.titleLabel.font = [UIFont systemFontOfSize:11];
            [btnViewLyric setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnViewLyric setTitle:@"Xem lời bài hát" forState:UIControlStateNormal];
            [btnViewLyric addTarget:self action:@selector(viewLyric:) forControlEvents:UIControlEventTouchUpInside];
            [btnViewLyric setImage:[UIImage imageNamed:@"menu_lyric.png"] forState:UIControlStateNormal];
            [self addSubview:btnViewLyric];
        }
    }
   
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSString *cellNibName = @"SNSongTableViewCell";
    if (IS_IPAD) {
        cellNibName = @"SNSongTableViewCell_Ipad";
    }
    SNSongTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:cellNibName owner:self options:nil]lastObject];
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)setUpWithSong:(SNSongModel*)song
{
    _songModel = song; 
    if (song) {
        _lblTitle.text = song.title;
        if (song.is_free) {
            _imvFree.image = [UIImage imageNamed:@"ic_free.png"];
        }else{
            _imvFree.image = [UIImage imageNamed:@"ic_paid.png"];
        }
        
        if ([@"midi" isEqualToString:song.karaoke_type]) {
            _imvType.image = [UIImage imageNamed:@"ic_midi.png"];
        }else if([@"mp3" isEqualToString:song.karaoke_type]){
            _imvType.image = [UIImage imageNamed:@"ic_mp3.png"];
        }
        _lblNhacSy.text = song.music_by;
        _lblSongNumber.text = song.number;
        _lblShortLyric.text = song.short_lyric;
        [self updateFavoriteIcon];
    }
    self.backgroundColor = [UIColor clearColor];
}

-(void)updateFavoriteIcon
{
    if (_songModel.is_favorite) {
        [btnAddToFavorite setImage:[UIImage imageNamed:@"ic_favorite.png"] forState:UIControlStateNormal];
        [btnAddToFavorite setTitle:@"Xoá khỏi bài hát yêu thích" forState:UIControlStateNormal];
    }else{
        [btnAddToFavorite setImage:[UIImage imageNamed:@"ic_favorites_disable.png"] forState:UIControlStateNormal];
        [btnAddToFavorite setTitle:@"Thêm vào bài hát yêu thích" forState:UIControlStateNormal];
    }
}


-(void)addActivityIndicator
{
    CGRect center = CGRectMake([UIScreen mainScreen].bounds.size.height - 25, 3, 21, 21);
    
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:center];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:activityIndicator];
    }
}

- (void)viewLyric:(id)sender {
    if (_songModel && _delegate && [_delegate respondsToSelector:@selector(viewLyricSong:)]) {
        [_delegate viewLyricSong:_songModel];
    }
}

- (void)addToFavorite:(id)sender {
    if (_songModel) {
        _songModel.is_favorite = !_songModel.is_favorite;
        if (_delegate && [_delegate respondsToSelector:@selector(addToFavorite:)]) {
            [_delegate addToFavorite:_songModel];
        }
        [self updateFavoriteIcon];
    }
}

-(void)addSongToQueue
{
    if (_songModel && _delegate && [_delegate respondsToSelector:@selector(addToQueue:)]) {
        [_delegate addToQueue:_songModel];
    }
}
@end
