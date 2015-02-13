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
        remoteSongManager = [SNRemoteSongsManager sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(SNScanQRCodeViewController) *weakSelf = self;
    [remoteSongManager setRequestListSongsCompleted:^{
        [weakSelf hideLoading];
        SNSearchSongViewController *searchSongVC = [[SNSearchSongViewController alloc]initWithNibName:@"SNSearchSongViewController" bundle:nil];
        [weakSelf presentViewController:searchSongVC animated:YES completion:nil];
    }];
    [remoteSongManager setConnectCompleted:^(BOOL success, NSError *error) {
        if (success == YES) {
            // Nothing
        }else{
            [weakSelf hideLoading];
            if(error != nil)
            {
                [weakSelf showNotifyView:[NSString stringWithFormat:@"Lỗi kết nối: %@",error] complete:nil];
            }
        }
    }];
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
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
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    
    //Auto connect to the ip after scan success
    if (![NSString isStringEmpty:scanValue]) {
        _txtIpAddress.text = scanValue;
        [self connectToHost:scanValue];
    }
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            scanValue = [metadataObj stringValue];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

-(void)connectToHost:(NSString*)ipAddress
{
    if (![NSString isStringEmpty:ipAddress]) {
        [self hideKeyboard];
        [self showLoading];
        [remoteSongManager initNetworkCommunicationToHost:_txtIpAddress.text port:PORT];
    }
}

- (IBAction)btnConnect:(id)sender {
    if (![NSString isStringEmpty:_txtIpAddress.text]) {
        [self connectToHost:_txtIpAddress.text];
    }
}
@end
