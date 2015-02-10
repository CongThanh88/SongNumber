//
//  SNScanQRCodeViewController.h
//  SongNumber
//
//  Created by Cong Thanh on 2/3/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SNBaseViewController.h"

@interface SNScanQRCodeViewController : SNBaseViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewCapture;

- (IBAction)btnScanQRCode:(id)sender;
- (IBAction)btnConnect:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtIpAddress;

@end
