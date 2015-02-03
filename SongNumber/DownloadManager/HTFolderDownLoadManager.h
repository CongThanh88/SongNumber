//
//  HTFolderDownLoadManager.h
//  AVPlayerDemo
//
//  Created by Apple on 7/1/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSongModel.h"

typedef enum : NSUInteger {
    NONE_Player,
    MP3_Player,
    MIDI_Player,
    MKV_Player,
} PlayerType;

typedef enum : NSUInteger {
    NoneFileType,
    AudioFileType,
    VideoFileType,
} DownloadFileType;

@interface HTFolderDownLoadManager : NSObject
+(NSString*)createOnlineFolder;
+(NSString*)createOfflineFolder;
+(NSString*)createVideoFolder;
+(NSString*)createRecodingFolder;
+(NSString*)createFileRecordingWithSongName:(NSString*)musicName;
+(BOOL)deleteAllFileOnline;
+(BOOL)deleteAllFileVideoInDownloadFoler;
+(BOOL)deleteAllFileInMyPhotoFolder;
+(BOOL)deleteFile:(NSString*)filePath;
+(BOOL)isExistFile:(NSString*)filePath;
+(NSString*)getOnlineFilePathOfUrl:(NSString*)urlString;
+(NSString*)getOfflineFilePathOfUrl:(NSString*)urlString;
+(DownloadFileType)getTypeOfFile:(NSString*)file;
+(BOOL)isExistFileOnlineForUrl:(NSString*)urlString;
+(BOOL)isExistFileOfflineForUrl:(NSString*)urlString;
+(NSMutableArray*)getAllFileInMyPhotosFolder;
+(BOOL)isExistSong:(SNSongModel*)song;
@end
