//
//  SNRemoteSongsManager.m
//  SongNumber
//
//  Created by Hai_Apple on 2/5/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import "SNRemoteSongsManager.h"
#import "NSString+Addition.h"
#import "SNSongModel.h"
#import "SNStreamUtil.h"

@implementation SNRemoteSongsManager
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    BOOL isGetList;
    BOOL isRequestedGetList;
    BOOL sentRemoteGetList;
    NSMutableData* mDataRead;
    
    // Read 4 bytes
    uint8_t mBufferFirstPackage[4];
    NSUInteger mCurrentRead;
}


+(instancetype)sharedInstance
{
    static dispatch_once_t one_token;
    static SNRemoteSongsManager *songsManager;
    dispatch_once(&one_token, ^{
        songsManager = [SNRemoteSongsManager new];
    });
    return songsManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.listSong = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)parseListSongFromString:(NSString*)resultString
{
    if (![NSString isStringEmpty:resultString]) {
        NSArray *listSongString = [resultString componentsSeparatedByString:@"\n"];
        if (listSongString && listSongString.count>0) {
            NSArray *songResult = [SNSongModel parseListSongResponseString:listSongString];
            if (songResult && songResult.count >0) {
                _listSong = [[NSMutableArray alloc]initWithArray:songResult];
            }
        }
    }
    if(_requestListSongsCompleted){
        _requestListSongsCompleted();
    }
}

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

-(void)requestGetListSong
{
    [self sendRemoteControl:REMOTE_SONG_LIST andValue:-1];
}


-(void)sendRemoteControl:(REMOTE)remote andValue:(int)value
{
    NSMutableData *remoteData = [NSMutableData dataWithBytes:&remote length:sizeof(remote)];
    if (value >=0 ) {
        uint32_t tempValue = CFSwapInt32HostToBig(value);
        [remoteData appendData:[NSData dataWithBytes:(&tempValue) length:sizeof(uint32_t)]];
    }
    [self performSelectorInBackground:@selector(sendData:) withObject:remoteData];
}

-(void)sendData:(NSData*)data
{
    if (data && outputStream && [outputStream hasSpaceAvailable]) {
        NSUInteger byteswrote = [outputStream write:[data bytes] maxLength:[data length]];
    }
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            if (!isRequestedGetList) {
                isRequestedGetList = YES;
                if (_connectCompleted) {
                    _connectCompleted(YES, nil);
                }
            }
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                if (!isGetList) {
                    @try {
                        if ([SNStreamUtil bufferFirstPackageIsNull:mBufferFirstPackage]) {
                            mDataRead = [[NSMutableData alloc]init];
                            NSMutableData* intByte = [SNStreamUtil readInt:inputStream];
                            [intByte getBytes:mBufferFirstPackage length:[intByte length]];
                            
                            NSMutableData *amountSongData = [SNStreamUtil readInt:inputStream];
                            uint8_t amountSongBytes[4];
                            [amountSongData getBytes:amountSongBytes length:[amountSongData length]];
                        }
                        
                        //total length will be received
                        NSUInteger totalLength = [SNStreamUtil bufferFirstPackageToInt:mBufferFirstPackage];
                        
                        uint8_t buffer[1024];
                        NSInteger lengthRead = 0;
                        
                        if (totalLength >0) {
                            NSUInteger currentReading =0;
                            while ([inputStream hasBytesAvailable]) {
                                if (mCurrentRead + sizeof(buffer) < totalLength) {
                                    currentReading = sizeof(buffer);
                                }else{
                                    currentReading = totalLength - mCurrentRead;
                                }
                                
                                lengthRead = [inputStream read:buffer maxLength:currentReading];
                                if (lengthRead >0) {
                                    mCurrentRead += lengthRead;
                                    if (mCurrentRead < totalLength) { // It not full
                                        [mDataRead appendBytes:buffer length:lengthRead];
                                    } else { // Full
                                        NSString *receivedString = [[NSString alloc]initWithData:mDataRead encoding:NSUTF8StringEncoding];
                                        if (![NSString isStringEmpty:receivedString]) {
                                            [self performSelectorInBackground:@selector(parseListSongFromString:) withObject:receivedString];
                                        }else if(_requestListSongsCompleted){
                                            _requestListSongsCompleted();
                                        }
                                        isGetList = YES;
                                        mDataRead = nil;
                                    }
                                }
                            } // End while
                        } // End if
                    } // End try
                    @catch (NSException *exception) {
                        NSLog(@"Error: %@", [exception description]);
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            if (_connectCompleted) {
                _connectCompleted(NO, [theStream streamError]);
            }
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        case NSStreamEventEndEncountered:
            break;
        case NSStreamEventHasSpaceAvailable:
            if(self->sentRemoteGetList == NO)
            {
                self->sentRemoteGetList = YES;
                [self performSelector:@selector(requestGetListSong) withObject:nil];
            }
            break;
        case NSStreamEventNone:
            break;
    }
    
}


@end
