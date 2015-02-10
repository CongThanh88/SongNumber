//
//  SNBaseViewController.h
//  SongNumber
//
//  Created by Hai_Apple on 2/9/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SNBaseViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *loadingView;
@property (strong, nonatomic) UILabel *notifyView;

-(void)hideNotifyView:(void(^)())complete;

-(void)showNotifyView:(NSString*)content complete:(void(^)())complete;

-(void)showLoading;

-(void)hideLoading;

@end
