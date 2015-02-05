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
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>


@interface SNSearchSongViewController ()

@end

@implementation SNSearchSongViewController
{
    NSArray *listSongs;
    NSArray *listSongsFull;
    NSDictionary *currentSongType;
    NSString *searchString;
    SNSettingManager *setting;
    KSBasePopupView *popupView;
    SNScanQRCodeViewController *scanQRVC;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    BOOL isFirstReceived;
    int fileLenght;
    int receivedBytes;
    NSString *receivedString;
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
    
    _boundSearchView.layer.cornerRadius = 5;
    _boundSearchView.layer.borderColor = [UIColor grayColor].CGColor;
    _boundSearchView.layer.borderWidth = 0.5;
    
    if (IS_IPAD) {
        _tableView.allowsSelection = NO;
    }
    listSongsFull = [[HTDatabaseHelper sharedInstance] querySongs:@"Select * from song"];
    listSongs = listSongsFull;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (IS_IOS7) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    setting = [SNSettingManager sharedInstance];
    
    [self setupView];
    setting = [SNSettingManager sharedInstance];
    //regist keyboard notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //notify view
    float x_center = ([UIScreen mainScreen].bounds.size.height - 300)/2;
    _notifyView = [[UILabel alloc]initWithFrame:CGRectMake(x_center, 120, 300, 100)];
    _notifyView.numberOfLines = 4;
    _notifyView.textColor = [UIColor whiteColor];
    _notifyView.font = [UIFont systemFontOfSize:15];
    _notifyView.textAlignment = NSTextAlignmentCenter;
    _notifyView.layer.cornerRadius = 7;
    _notifyView.layer.borderColor = [UIColor grayColor].CGColor;
    _notifyView.layer.backgroundColor = [[UIColor colorWithRed:196/255 green:196/255 blue:196/255 alpha:0.75] CGColor];
    _notifyView.alpha = 0;
    [self.view addSubview:_notifyView];
}

-(void)setupView
{
    
    
    CGRect searchFrame = _txtSearchField.frame;
    searchFrame.size.height = 26;
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
    _btnSort.tableWidth = _btnSort.frame.size.width;;
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
        //listSongs = [[HTDatabaseHelper sharedInstance] querySongs:query];
        listSongs = [listSongsFull filteredArrayUsingPredicate:predicate];
    }else{
        listSongs = listSongsFull;
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
    [self sendRemoteControl:REMOTE_SONG_LIST songNumber:nil];
    
//    if (IS_IPAD) {
//        return;
//    }
//    if (!popupView) {
//        popupView = [[KSBasePopupView alloc]initWithNibName:@"KSBasePopupView" bundle:nil];
//        popupView.delegate = self;
//    }
//    
//    if (listSongs && listSongs.count > indexPath.row) {
//        SNSongModel *selectedSong = [listSongs objectAtIndex:indexPath.row];
//        if (selectedSong) {
//            popupView.songModel = selectedSong;
//            [popupView showInView:self.view animated:YES completeBlock:nil];
//        }
//    }
}


-(void)hideNotifyView:(void(^)())complete
{
    [UIView animateWithDuration:2.5 animations:^{
        _notifyView.alpha = 0;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

-(void)showNotifyView:(NSString*)content complete:(void(^)())complete
{
    _notifyView.layer.zPosition = 100;
    _notifyView.text = content;
    
    //Update notify frame
    CGRect notifyFrame = _notifyView.frame;
    CGSize fixedSize = [content sizeWithFont:_notifyView.font];
    notifyFrame.size = CGSizeMake(fixedSize.width +20, fixedSize.height + 10);
    float x_center = ([UIScreen mainScreen].bounds.size.height - notifyFrame.size.width)/2;
    float y_center = ([UIScreen mainScreen].bounds.size.width - notifyFrame.size.height)/2;
    notifyFrame.origin.x = x_center;
    notifyFrame.origin.y = y_center;
    _notifyView.frame = notifyFrame;
    
    [UIView animateWithDuration:0.2 animations:^{
        _notifyView.alpha = 1;
    } completion:^(BOOL finished) {
        [self hideNotifyView:nil];
        if (complete) {
            complete();
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDeleteText:(id)sender {
    _txtSearchField.text = @"";
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

- (IBAction)btnScanCode:(id)sender {
    scanQRVC = [[SNScanQRCodeViewController alloc]initWithNibName:@"SNScanQRCodeViewController" bundle:nil];
    scanQRVC.delegate = self;
    [self presentViewController:scanQRVC animated:YES completion:nil];
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
    if (song) {
        [[HTDatabaseHelper sharedInstance] updateSongFavorite:song];
    }
    if (_btnFavorite.isSelected) {
        [self reloadSong];
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

//////// socket /////////////

- (void)initNetworkCommunicationToHost:(NSString*)host port:(UInt32)port {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(host), port, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}


-(void)sendRemoteControl:(REMOTE)remote songNumber:(NSString*)songNumber
{
    NSInteger number = [songNumber integerValue];
    NSMutableData *remoteData = [NSMutableData dataWithBytes:&remote length:sizeof(remote)];
    if (![NSString isStringEmpty:songNumber]) {
        [remoteData appendData:[NSData dataWithBytes:&number length:sizeof(number)]];
    }
    
    [self sendData:remoteData];
}

-(void)sendData:(NSData*)data
{
    if (data && outputStream && [outputStream hasSpaceAvailable]) {
        [outputStream write:[data bytes] maxLength:[data length]];
    }
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
            isFirstReceived = YES;
            receivedBytes = 0;
			break;

		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                NSMutableData *receivedData = [[NSMutableData alloc]init];
                while ([inputStream hasBytesAvailable]) {
                    long len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        [receivedData appendBytes:buffer length:len];
                    }
                }
                if (!buffer) {
                    NSLog(@"Received: %@",receivedString);
                }
                
                NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                if (output) {
                    receivedString = [receivedString stringByAppendingString:output];
                }
                
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host! error: %@",[theStream streamError]);
			break;
            
		case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}

#pragma mark - ScanQRCodeViewControllerDelegate
-(void)didScanQRCodeWithValue:(NSString *)stringValue
{
//    if (![NSString isStringEmpty:stringValue]) {
        [self initNetworkCommunicationToHost:stringValue port:2468];//@"172.18.23.54"
//    }
}
@end
