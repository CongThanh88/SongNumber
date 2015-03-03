//
//  SNSearchSongViewController.m
//  IKaraoke
//
//  Created by Cong Thanh on 8/14/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "SNSearchSongViewController.h"
#import "NSString+Addition.h"
#import "HTDatabaseHelper.h"
#import "SNSongTableViewCell.h"
#import "HTLocalizeHelper.h"
#import "SNSettingManager.h"
#import "SNSongTableViewCell.h"
#import "HTLyricsDetailViewController.h"
#import "SNRemoteSongsManager.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>



@interface SNSearchSongViewController ()
@property(nonatomic,strong)NSArray *listSongsFull;
@end

@implementation SNSearchSongViewController
{
    NSArray *listSongs;
    NSDictionary *currentSongType;
    NSString *searchString;
    SNSettingManager *setting;
    KSBasePopupView *popupView;
    SNRemoteSongsManager *remoteSongManager;
    
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

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    remoteSongManager = [SNRemoteSongsManager sharedInstance];
    __weak typeof(SNSearchSongViewController) *weakSelf = self;
    __weak typeof(SNRemoteSongsManager) *weakRemoteSong = remoteSongManager;
    
    [remoteSongManager setRequestListSongsCompleted:^{
        weakSelf.listSongsFull = weakRemoteSong.listSong;
        [weakSelf reloadSong];
    }];
    
    _boundSearchView.layer.cornerRadius = 5;
    _boundSearchView.layer.borderColor = [UIColor grayColor].CGColor;
    _boundSearchView.layer.borderWidth = 0.5;
    
    if (IS_IPAD) {
        _tableView.allowsSelection = NO;
    }
    _listSongsFull = remoteSongManager.listSong;
    listSongs = _listSongsFull;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (IS_IOS7) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    setting = [SNSettingManager sharedInstance];
    
    [self setupView];
    setting = [SNSettingManager sharedInstance];
    //regist keyboard notification
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)setupView
{
    CGRect searchFrame = _txtSearchField.frame;
    searchFrame.size.height = 28;
    _txtSearchField.frame = searchFrame;
    _txtSearchField.delegate = self;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor redColor];
    [_tableView reloadData];
    
    
    //The loai
    _btnTheLoai.tableWidth = _btnTheLoai.frame.size.width;;
    _btnTheLoai.icon = [UIImage imageNamed:@"ic_filter_genre.png"];
    NSArray *listTypeSongs = setting.listSTypeOfSongs;
    _btnTheLoai.delegate = self;
    [_btnTheLoai setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnTheLoai setListItem:listTypeSongs];
    [_btnTheLoai setItemSelected:[listTypeSongs objectAtIndex:0]];
    
    //Ngon Ngu
    _btnNgonNgu.tableWidth = _btnNgonNgu.frame.size.width;
    _btnNgonNgu.icon = [UIImage imageNamed:@"ic_filter_language.png"];
    NSArray *listLanguages = [setting.dicNgonNgu objectForKey:@"value"];
    _btnNgonNgu.delegate = self;
    [_btnNgonNgu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNgonNgu setListItem:listLanguages];
    [_btnNgonNgu setItemSelected:[listLanguages objectAtIndex:0]];
    
    //Loai bai hat
    _btnSort.tableWidth = _btnSort.frame.size.width;
    _btnSort.icon = [UIImage imageNamed:@"ic_filter_sort.png"];
    NSArray *listSortType = setting.listSortType;
    _btnSort.delegate = self;
    [_btnSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSort setListItem:listSortType];
    [_btnSort setItemSelected:[listSortType objectAtIndex:0]];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![NSString isStringEmpty:_txtSearchField.text] && ![NSString isStringEmpty:string]) {
        searchString = [searchString stringByAppendingString:string];
    }else if(![NSString isStringEmpty:string]){
        searchString = string;
    }else if(![NSString isStringEmpty:searchString]){
        searchString = [searchString substringToIndex:searchString.length-1];
    }
    [self reloadSong];
    return YES;
}

#pragma mark - Filter song by type of song
-(void)reloadSong
{
    NSDictionary *dictCategory = [_btnTheLoai getSelectedItem];
    NSDictionary *dictLanguage = [_btnNgonNgu getSelectedItem];
    int typeSong = [self getTypeSong];
    NSString *query = @"1=1 ";// = @"select * from song where 1=1 ";
    listSongs = [[NSArray alloc]init];
    
    if (dictCategory && ![[[setting.listSTypeOfSongs firstObject] objectForKey:@"value"]  isEqualToString:[dictCategory objectForKey:@"value"]]) {
        
        query = [query stringByAppendingString:[NSString stringWithFormat:@"AND  genre = \""]];
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",[dictCategory objectForKey:@"value"]]];
        query = [query stringByAppendingString:@"\""];
        
    }
    
    if (dictLanguage && ![@"all" isEqualToString:[dictLanguage objectForKey:@"value"]]) {
        NSString *languageString = [dictLanguage objectForKey:@"value"];
        if (![NSString isStringEmpty:query]) {
            query = [query stringByAppendingString:[NSString stringWithFormat:@" AND language = \""]];
        }else{
            query = [NSString stringWithFormat:@"language = \""];
        }
        
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",languageString]];
        query = [query stringByAppendingString:@"\""];
        
    }
    
    if (![NSString isStringEmpty:searchString]) {
        if (![NSString isStringEmpty:query]) {
            query = [query stringByAppendingString:[NSString stringWithFormat:@" AND ( title_search LIKE[c] \""]];
        }else{
            query = [NSString stringWithFormat:@"title_search LIKE[c] \""];
        }
        
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",searchString]];
        query = [query stringByAppendingString:@"*\""];//%
        
        query = [query stringByAppendingString:[NSString stringWithFormat:@" OR title_shortcut LIKE[c] \""]];
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",searchString]];
        query = [query stringByAppendingString:@"*\")"];//%
    }
    
    if (typeSong>0) {
        if (typeSong==1) {
            query = [query stringByAppendingString:[NSString stringWithFormat:@" AND is_free = 1"]];
        }else if(typeSong ==2){
            query = [query stringByAppendingString:[NSString stringWithFormat:@" AND is_free = 0"]];
        }else{
            query = [query stringByAppendingString:[NSString stringWithFormat:@" AND is_favorite = 1"]];
        }
    }
    if (![NSString isStringEmpty:query]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
        listSongs = [_listSongsFull filteredArrayUsingPredicate:predicate];
    }else{
        listSongs = _listSongsFull;
    }
    
    if (_btnSort.itemSelected && [[_btnSort.itemSelected objectForKey:@"value"] intValue] !=0) {
        int sortType = [[_btnSort.itemSelected objectForKey:@"value"] intValue];
        NSString *sortBy = @"number";
        if (sortType == 2) {
            sortBy = @"title";
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortBy
                                                                         ascending:YES];
        listSongs = [listSongs sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sortDescriptor, nil]];
    }
    [self sortListSong];
}

-(void)sortListSong
{
    if (_btnSort.itemSelected && [[_btnSort.itemSelected objectForKey:@"value"] intValue] !=0) {
        int sortType = [[_btnSort.itemSelected objectForKey:@"value"] intValue];
        NSString *sortBy = @"number";
        if (sortType == 2) {
            sortBy = @"title";
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortBy
                                                                         ascending:YES];
        listSongs = [listSongs sortedArrayUsingDescriptors:[[NSArray alloc]initWithObjects:sortDescriptor, nil]];
    }
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

#pragma mark - SelectBoxDelegate
-(void)didSelectedItem:(NSDictionary *)item
{
    [self reloadSong];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listSongs) {
        return listSongs.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 80;
    }
    return 54;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SNSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongTableViewCell"];
    if (!cell) {
        cell = [[SNSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SongTableViewCell"];
    }
    
    SNSongModel *song = [listSongs objectAtIndex:indexPath.row];
    if ( song) {
        [cell setUpWithSong:song];
    }
    // change background color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:colorWithHexValue(0xec992d)];
    [cell setSelectedBackgroundView:bgColorView];
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return;
    }
    if (!popupView) {
        popupView = [[KSBasePopupView alloc]initWithNibName:@"KSBasePopupView" bundle:nil];
        popupView.delegate = self;
    }
    
    if (listSongs && listSongs.count > indexPath.row) {
        SNSongModel *selectedSong = [listSongs objectAtIndex:indexPath.row];
        if (selectedSong) {
            popupView.songModel = selectedSong;
            [popupView showInView:self.view animated:YES completeBlock:nil];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDeleteText:(id)sender {
    _txtSearchField.text = @"";
    searchString = nil;
    [self reloadSong];
}

- (IBAction)btnSort:(id)sender {
    [_btnNgonNgu hidePopup];
    [_btnTheLoai hidePopup];
    [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)btnNgonNgu:(id)sender {
    [_btnTheLoai hidePopup];
    [_btnSort hidePopup];
    [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)btnTheLoai:(id)sender {
    [_btnSort hidePopup];
    [_btnNgonNgu hidePopup];
    [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)resetButton
{
    if (_btnFree.isSelected) {
        _btnFree.isSelected = NO;
    }
    if (_btnFavorite.isSelected) {
        _btnFavorite.isSelected = NO;
    }
    if (_btnNew.isSelected) {
        _btnNew.isSelected = NO;
    }
    if (_btnAll.isSelected) {
        _btnAll.isSelected = NO;
    }
    
}

-(int)getTypeSong
{
    if (_btnFree.isSelected) {
        return 1;
    }
    if (_btnFavorite.isSelected) {
        return 3;
    }
    if (_btnNew.isSelected) {
        return 2;
    }
    if (_btnAll.isSelected) {
        return 0;
    }
    return 0;
}

- (IBAction)btnAll:(id)sender {
    if (!_btnAll.isSelected) {
        [self reloadSong];
    }
    [self resetButton];
    if (!_btnAll.isSelected) {
        _btnAll.isSelected = YES;
        [self reloadSong];
    }
}

- (IBAction)btnFree:(id)sender {
    [self resetButton];
    if (!_btnFree.isSelected) {
        _btnFree.isSelected = YES;
        [self reloadSong];
    }
}

- (IBAction)btnFavorite:(id)sender {
    [self resetButton];
    if (!_btnFavorite.isSelected) {
        _btnFavorite.isSelected = YES;
        [self reloadSong];
    }
}

- (IBAction)btnNew:(id)sender {
    [self resetButton];
    if (!_btnNew.isSelected) {
        _btnNew.isSelected = YES;
        [self reloadSong];
    }
}

- (IBAction)btnStop:(id)sender {
    [remoteSongManager sendRemoteControl:REMOTE_STOP andValue:-1];
}

- (IBAction)btnPause:(id)sender {
    [remoteSongManager sendRemoteControl:REMOTE_PAUSE andValue:-1];
}

- (IBAction)btnPlay:(id)sender {
    [remoteSongManager sendRemoteControl:REMOTE_PLAY andValue:-1];
}

- (IBAction)btnNext:(id)sender {
    [remoteSongManager sendRemoteControl:REMOTE_NEXT andValue:-1];
}

- (IBAction)btnOnOffSingerVoice:(id)sender {
    if (_btnSingerVoice.isSelected) {
        _btnSingerVoice.selected = NO;
        [remoteSongManager sendRemoteControl:REMOTE_SELECT_TRACK andValue:-1];
    }else{
        _btnSingerVoice.selected = YES;
        [remoteSongManager sendRemoteControl:REMOTE_SELECT_TRACK andValue:-1];
    }
}


#pragma mark - PopupViewDeleate - SNSongTableViewCellDelegate
-(void)viewLyricSong:(SNSongModel*)song
{
    if (song) {
        HTLyricsDetailViewController *lyricVC = [[HTLyricsDetailViewController alloc]initWithNibName:@"HTLyricsDetailViewController" bundle:nil];
        if (song) {
            [lyricVC setSong:song];
        }
        [self presentViewController:lyricVC animated:YES completion:nil];
    }
}

-(void)addToFavorite:(SNSongModel*)song{
    if (song && !song.is_favorite) {
        [remoteSongManager sendRemoteControl:REMOTE_FAVORITE andValue:[song.number intValue]];
    }else if(song){
        [remoteSongManager sendRemoteControl:REMOTE_UNFAVORITE andValue:[song.number intValue]];
    }
}

-(void)addToQueue:(SNSongModel *)song
{
    if (song) {
        [remoteSongManager sendRemoteControl:REMOTE_RES andValue:[song.number intValue]];
    }
}

#pragma Keyboard notification
-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect tableFrame = _tableView.frame;
    tableFrame.size.height = [UIScreen mainScreen].bounds.size.height - tableFrame.origin.y -( keyboardFrameBeginRect.size.height - 30);
    _tableView.frame = tableFrame;
}

-(void)keyboardWillHide:(NSNotificationCenter*)notification
{
    CGRect tableFrame = _tableView.frame;
    tableFrame.size.height = [UIScreen mainScreen].bounds.size.height - 44- tableFrame.origin.y - 24;
    _tableView.frame = tableFrame;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
