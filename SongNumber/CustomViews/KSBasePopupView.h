//
//  KSBasePopupView.h
//
//
//  Created by ThanhDC4 on 3/3/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSongModel.h"

@protocol PopupViewDelegate <NSObject>

-(void)viewLyricSong:(SNSongModel*)song;
-(void)addToFavorite:(SNSongModel*)song;
-(void)addToQueue:(SNSongModel*)song;

@end

@interface KSBasePopupView : UIViewController
@property (strong, nonatomic) SNSongModel *songModel;
@property (weak, nonatomic) id<PopupViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToFavorite;
@property (copy, nonatomic)  void (^closePopupBlock)(void);

- (IBAction)btnViewLyric:(id)sender;
- (IBAction)btnAddToFavorite:(id)sender;
- (IBAction)btnAddToQueue:(id)sender;

- (void)showInView:(UIView *)aView animated:(BOOL)animated completeBlock:(void(^)(void))closePopupBlock;
-(void)closePopup;
@end
