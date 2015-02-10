//
//  SNScanQRCodeViewController.m
//  SongNumber
//
//  Created by Cong Thanh on 2/3/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import "SNScanQRCodeViewController.h"
#import "SNSearchSongViewController.h"
#import "NSString+Addition.h"
#import "SNRemoteSongsManager.h"


@interface SNScanQRCodeViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
@end

@implementation SNScanQRCodeViewController
{
    SNRemoteSongsManager *remoteSongManager;
    NSString *scanValue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    remoteSongManager = [SNRemoteSongsManager sharedInstance];
    __weak typeof(SNScanQRCodeViewController) *weakSelf = self;
    __weak typeof(SNRemoteSongsManager) *weakRemoteSong = remoteSongManager;
    [remoteSongManager setRequestListSongsCompleted:^{
        [weakSelf hideLoading];
        SNSearchSongViewController *searchSongVC = [[SNSearchSongViewController alloc]initWithNibName:@"SNSearchSongViewController" bundle:nil];
        [weakSelf presentViewController:searchSongVC animated:YES completion:nil];
    }];
    
    [remoteSongManager setConnectCompleted:^(BOOL success, NSError *error) {
        if (success && !error) {
            [weakRemoteSong performSelector:@selector(requestGetListSong) withObject:nil afterDelay:2];
        }else{
            [weakSelf hideLoading];
            [weakSelf showNotifyView:[NSString stringWithFormat:@"Lỗi kết nối: %@",error] complete:nil];
        }
    }];
}

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewCapture.layer.bounds];
    [_previewCapture.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
    
    _txtIpAddress.text = scanValue;
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            scanValue = [metadataObj stringValue];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyboard
{
    if (_txtIpAddress.isEditing) {
        [_txtIpAddress endEditing:YES];
    }
}
- (IBAction)btnScanQRCode:(id)sender {
    [self hideLoading];
    [self startReading];
}

- (IBAction)btnConnect:(id)sender {
    if (![NSString isStringEmpty:_txtIpAddress.text]) {
        [self hideKeyboard];
        [self showLoading];
        [remoteSongManager initNetworkCommunicationToHost:_txtIpAddress.text port:PORT];
    }
}
@end
