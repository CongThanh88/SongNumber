//
//  HTLyricsDetailViewController.m
//  IKaraoke
//
//  Created by Cong Thanh on 8/12/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTLyricsDetailViewController.h"
#import "NSString+Addition.h"
//#import "MBProgressHUD.h"
#import "HTAudioDownLoadManager.h"
#import "HTLocalizeHelper.h"
#import "HTTXTParser.h"

@interface HTLyricsDetailViewController ()

@end

@implementation HTLyricsDetailViewController
{
//    MBProgressHUD *loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    //return supported orientation masks
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lblTitle.text = LocalizedString(@"Lời bài hát");
    [_btnBack setTitle:LocalizedString(@"Quay lại") forState:UIControlStateNormal];
    _txtLyricContent.showsHorizontalScrollIndicator = NO;
    _txtLyricContent.alwaysBounceHorizontal = NO;
    _txtLyricContent.bounces = NO;
    _txtLyricContent.contentSize = CGSizeMake(100, _txtLyricContent.contentSize.height);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_song) {
        [self showLoading];
        NSString *lyricMusic = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@ %@\n%@ %@\n\n",LocalizedString(@"Tên bài hát: "), _song.title?_song.title:@"", LocalizedString(@"Nhạc: "), _song.music_by?_song.music_by:@"", LocalizedString(@"Lời: "), _song.lyric_by?_song.lyric_by:@"", LocalizedString(@"Ca sĩ: "), _song.singer?_song.singer:@""];
        HTAudioDownLoadManager *downloadManager = [[HTAudioDownLoadManager alloc]init];
        [downloadManager downloadFile:_song.lyric_file ofSong:_song online:YES complete:^(SNSongModel* downloadSong2, NSString *filePath, NSError *error) {
            [self hideLoading];
            if (![NSString isStringEmpty:filePath]) {
                NSString *fileContent =  [HTTXTParser getLyricsFile:filePath];
                if (![NSString isStringEmpty:fileContent] && ![NSString isStringEmpty:lyricMusic]) {
                    fileContent = [lyricMusic stringByAppendingString:fileContent];
                }
                if (![NSString isStringEmpty:fileContent]) {
                    _txtLyricContent.text = fileContent;
                }
            }
        }];
    }
}

-(void)setSong:(SNSongModel *)song{
    _song = song;
}


-(void)showLoading
{
//    if (!loadingView) {
//        loadingView = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:loadingView];
//    }
//    [loadingView show:YES];
}


-(void)hideLoading
{
//    if (loadingView) {
//        [loadingView hide:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
