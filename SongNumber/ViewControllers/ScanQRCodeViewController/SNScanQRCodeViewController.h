//
//  SNScanQRCodeViewController.h
//  SongNumber
//
//  Created by Cong Thanh on 2/3/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanQRCodeViewControllerDelegate <NSObject>

-(void)didScanQRCodeWithValue:(NSString*)stringValue;

@end

@interface SNScanQRCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewCapture;
@property (weak, nonatomic) IBOutlet UILabel *lblScanValue;

@property (weak, nonatomic) id<ScanQRCodeViewControllerDelegate> delegate;

- (IBAction)btnOk:(id)sender;

@end
