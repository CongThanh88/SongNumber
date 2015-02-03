//
//  HTAudioDownLoadManager.h
//  AVPlayerDemo
//
//  Created by Apple on 6/29/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSongModel.h"
#import "HTFolderDownLoadManager.h"


@interface HTAudioDownLoadManager : NSObject<NSStreamDelegate, NSURLConnectionDataDelegate>
@property(nonatomic, assign) DownloadFileType downloadFileType;
@property(nonatomic, strong) NSInputStream *iStream;
@property(nonatomic, strong) NSOutputStream *oStream;
@property(nonatomic, assign) long byteIndex;
@property(nonatomic, strong) void (^downLoadFileComplete)(NSString* filePath, NSError *error);
@property(nonatomic, strong) void (^downLoadFileOfSongComplete)(SNSongModel* songDownload, NSString* filePath, NSError *error);
@property(nonatomic, strong) NSString *outPutFilePath;
@property(nonatomic, strong) NSURLConnection *connectionRequest;
@property(nonatomic, assign) BOOL isDownloading;
@property(nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, assign) BOOL isOnline;

-(void)downloadFile:(NSString *)urlString ofSong:(SNSongModel *)songModel online:(BOOL)isOnline complete:(void (^)(SNSongModel *, NSString *, NSError *))complete;
-(void)downloadFile:(NSString*)urlString online:(BOOL)isOnline complete:(void(^)(NSString *filePath, NSError *error))complete;
-(void)cancelRequest;
@end
