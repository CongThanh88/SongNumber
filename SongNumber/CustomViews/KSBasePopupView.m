//
//  KSBasePopupView.m
//
//  Created by ThanhDC4 on 3/3/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import "KSBasePopupView.h"
#import "NSString+Addition.h"

@interface KSBasePopupView ()

@end

@implementation KSBasePopupView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect selfFrame = self.view.frame;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    selfFrame.size = screenSize;
    self.view.frame = selfFrame;
    
    CGRect popupViewFrame = self.popupView.frame;
    popupViewFrame.origin.x = (selfFrame.size.width - popupViewFrame.size.width)/2;
    popupViewFrame.origin.y = (selfFrame.size.height - popupViewFrame.size.height)/2 ;
    self.popupView.frame = popupViewFrame;
    
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}


- (void)showAnimate
{
    if (_songModel) {
        if (_songModel.is_favorite) {
            [_btnAddToFavorite setImage:[UIImage imageNamed:@"ic_favorite.png"] forState:UIControlStateNormal];
            [_btnAddToFavorite setTitle:@"Xoá khỏi bài hát yêu thích" forState:UIControlStateNormal];
        }else{
            [_btnAddToFavorite setImage:[UIImage imageNamed:@"ic_favorites_disable.png"] forState:UIControlStateNormal];
            [_btnAddToFavorite setTitle:@"Thêm vào bài hát yêu thích" forState:UIControlStateNormal];
        }
    }
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            if (_closePopupBlock) {
                _closePopupBlock();
            }
        }
    }];
}


- (IBAction)btnViewLyric:(id)sender {
    if (_songModel && _delegate && [_delegate respondsToSelector:@selector(viewLyricSong:)]) {
        [_delegate viewLyricSong:_songModel];
    }
    [self closePopup];
}

- (IBAction)btnAddToFavorite:(id)sender {
    if (_songModel && _delegate && [_delegate respondsToSelector:@selector(addToFavorite:)]) {
        _songModel.is_favorite = !_songModel.is_favorite;
        [_delegate addToFavorite:_songModel];
    }
    [self closePopup];
}

- (IBAction)btnAddToQueue:(id)sender {
    
    if (_songModel && _delegate && [_delegate respondsToSelector:@selector(addToQueue:)]) {
        [_delegate addToQueue:_songModel];
    }
    [self closePopup];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated completeBlock:(void (^)(void))closePopupBlock
{
    _closePopupBlock =  closePopupBlock;
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)closePopup
{
    [self removeAnimate];
}

#pragma mark - touchesEnd
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(self.popupView.frame, touchLocation)) {
        [self removeAnimate];
    }
}

@end
