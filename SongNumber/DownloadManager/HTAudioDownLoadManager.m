//
//  HTAudioDownLoadManager.m
//  AVPlayerDemo
//
//  Created by Apple on 6/29/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTAudioDownLoadManager.h"
#import "NSString+Addition.h"

#define BUFFER_LEN   1024

@implementation HTAudioDownLoadManager

-(id)init{
    self = [super init];
    if (self) {
        self.receivedData = [[NSMutableData alloc] initWithLength:0];
    }
    return self;
}

-(void)downloadFile:(NSString *)urlString ofSong:(SNSongModel *)songModel online:(BOOL)isOnline complete:(void (^)(SNSongModel *, NSString *, NSError *))complete
{
    _downLoadFileOfSongComplete = complete;
    [self downloadFile:urlString online:isOnline complete:^(NSString *filePath, NSError *error) {
        _downLoadFileOfSongComplete(songModel,filePath,error);
    }];
}


-(void)downloadFile:(NSString*)urlString online:(BOOL)isOnline complete:(void(^)(NSString *filePath, NSError *error))complete
{
    if ([NSString isStringEmpty:urlString]) {
        _isDownloading = NO;
        if (complete) {
            complete(nil,[[NSError alloc]init]);
        }
        return;
    }
    
    if (isOnline) {
        if ([HTFolderDownLoadManager isExistFileOnlineForUrl:urlString]) {// if file is downloaded
            complete([HTFolderDownLoadManager getOnlineFilePathOfUrl:urlString],nil);
            return;
        }
        
        if ([HTFolderDownLoadManager isExistFileOfflineForUrl:urlString]) {// if file is downloaded
            complete([HTFolderDownLoadManager getOfflineFilePathOfUrl:urlString],nil);
            return;
        }
        _outPutFilePath = [HTFolderDownLoadManager getOnlineFilePathOfUrl:urlString];
    }else{
        if ([HTFolderDownLoadManager isExistFileOfflineForUrl:urlString]) {// if file is downloaded
            complete([HTFolderDownLoadManager getOfflineFilePathOfUrl:urlString],nil);
            return;
        }
        _outPutFilePath = [HTFolderDownLoadManager getOfflineFilePathOfUrl:urlString];
    }
    
    
    _downloadFileType = [HTFolderDownLoadManager getTypeOfFile:urlString];
    _downLoadFileComplete = complete;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _connectionRequest = [NSURLConnection connectionWithRequest:request delegate:self];
    //update the isDownloading flag
    _isDownloading = YES;
    //start downloading
    [_connectionRequest start];
    
}


#pragma mark - NSURLConnectionDataDelegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_receivedData)
    {
        if (_outPutFilePath) {
            if (VideoFileType == _downloadFileType) {
                [_receivedData writeToFile:_outPutFilePath atomically:YES];
                //Update the isDownloading flag
                _isDownloading = NO;
                //call back block
                if (_downLoadFileComplete) {
                    _downLoadFileComplete(_outPutFilePath,nil);
                }
                return;
            }else{
                //Delete old file
                [HTFolderDownLoadManager deleteFile:_outPutFilePath];
            }
            
            
            _iStream = [[NSInputStream alloc] initWithData:_receivedData];
            [_iStream setDelegate:self];
            [_iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
            _oStream = [NSOutputStream outputStreamToFileAtPath:_outPutFilePath append:YES];
            [_oStream setDelegate:self];
            [_oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
            [_oStream open];
            [_iStream open];
            
        }else{
            _isDownloading = NO;
            if (_downLoadFileComplete) {
                _downLoadFileComplete(nil,[[NSError alloc]init]);
            }
        }
    } else{
        _isDownloading = NO;
        if (_downLoadFileComplete) {
            _downLoadFileComplete(nil,[[NSError alloc]init]);
        }
    }
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (![NSString isStringEmpty:_outPutFilePath]) {
        [HTFolderDownLoadManager deleteFile:_outPutFilePath];
    }
    _isDownloading = NO;
    if (_downLoadFileComplete) {
        _downLoadFileComplete(nil,error);
        _downLoadFileComplete = nil;
    }
}


-(void)cancelRequest
{
    if (_connectionRequest) {
        _connectionRequest = nil;
        _isDownloading = NO;
        [_connectionRequest cancel];
        _downLoadFileComplete = nil;
        _downLoadFileOfSongComplete = nil;
    }
}

-(void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            if(stream == _iStream){
                while ([_iStream hasBytesAvailable])
                {
                    uint8_t buf[1024];
                    unsigned int len = 0;
                    len = (unsigned int)[_iStream read:buf maxLength:sizeof(buf)];
                    if(len>0) {
                        for(int i = 0;i<len;i++)
                        {
                            if (buf[i] >= 128) {
                                buf[i] -= 128;
                            } else {
                                buf[i] += 128;
                            }
                            if ((buf[i] & 0x01) == 1) {
                                buf[i] -= 1;
                            } else {
                                buf[i] += 1;
                            }
                        }
                        [_oStream write:(const uint8_t *)buf maxLength:len];
                    }
                    
                }
            }
            [_iStream close];
            [_oStream close];
            [_iStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
            [_oStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
            //Update the isDownloading flag
            _isDownloading = NO;
            //call back block
            if (_downLoadFileComplete) {
                _downLoadFileComplete(_outPutFilePath,nil);
            }
            break;
        default:
            break;
            
    }
    
}
@end
