//
//  HTFolderDownLoadManager.m
//  AVPlayerDemo
//
//  Created by Apple on 7/1/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTFolderDownLoadManager.h"
#import "NSString+Addition.h"

@implementation HTFolderDownLoadManager
+(NSString*)createOnlineFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:ONLINE_KARAOKE_FOLDER];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return dirPath;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    return dirPath;
}

+(NSString*)createOfflineFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:OFFLINE_KARAOKE_FOLDER];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return dirPath;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    return dirPath;
}

+(NSString*)createMyPhotosFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:BACKGROUND_IMAGES_FOLDER];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return dirPath;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    return dirPath;
}


+(NSString*)createVideoFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:DOWNLOAD_VIDEO_FOLDER];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return dirPath;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    return dirPath;
}

+(NSString*)createRecodingFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:RECORDING_AUDIO_FOLDER];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        return dirPath;
    }
    
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
        return nil;
    }
    return dirPath;
}

+(BOOL)deleteAllFileVideoInDownloadFoler
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:DOWNLOAD_VIDEO_FOLDER];
    if ([[NSFileManager defaultManager]fileExistsAtPath:dirPath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil]) {
            return YES;
        }
    }
    
    return NO;
}

+(BOOL)deleteAllFileOnline
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Fetch path for document directory
    NSString *dirPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:ONLINE_KARAOKE_FOLDER];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:dirPath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil]) {
            return YES;
        }
    }
    
    return NO;
}

+(NSMutableArray*)getAllFileInRecordingFolder
{
    NSString *dirPath = [self createRecodingFolder];
    NSMutableArray *listFile = [[NSMutableArray alloc]init];
    if ([[NSFileManager defaultManager]fileExistsAtPath:dirPath]) {
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *file in contents) {
            if (![NSString isStringEmpty:file]) {
                [listFile addObject:[dirPath stringByAppendingPathComponent:file]];
            }
        }
    }
    
    return listFile;
}

+(BOOL)deleteFile:(NSString*)filePath
{
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil]) {
        return YES;
    }
    return NO;
}

+(BOOL)isExistFile:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (fileAttributes && !error) {
            long long fileSize = [fileAttributes fileSize];
            if (fileSize >2000) {
                return YES;
            }
        }
    }
    return NO;
}


+(NSString*)getOfflineFilePathOfUrl:(NSString*)urlString
{
    DownloadFileType downloadFileType = [HTFolderDownLoadManager getTypeOfFile:urlString];
    NSString *dirPath = [HTFolderDownLoadManager createOfflineFolder];
    if(VideoFileType == downloadFileType){
        dirPath = [HTFolderDownLoadManager createVideoFolder];
    }
    if ([NSString isStringEmpty:dirPath]) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    return  [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
}

+(NSString*)getOnlineFilePathOfUrl:(NSString*)urlString
{
    DownloadFileType downloadFileType = [HTFolderDownLoadManager getTypeOfFile:urlString];
    NSString *dirPath = [HTFolderDownLoadManager createOnlineFolder];
    if(VideoFileType == downloadFileType){
        dirPath = [HTFolderDownLoadManager createVideoFolder];
    }
    if ([NSString isStringEmpty:dirPath]) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    return  [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
}


+(BOOL)isExistFileOnlineForUrl:(NSString*)urlString
{
    if (![NSString isStringEmpty:urlString]) {
        NSString *filePath = [HTFolderDownLoadManager getOnlineFilePathOfUrl:urlString];
        if (![NSString isStringEmpty:filePath]) {
            return [HTFolderDownLoadManager isExistFile:filePath];
        }
    }
    return NO;
}

+(BOOL)isExistFileOfflineForUrl:(NSString*)urlString
{
    if (![NSString isStringEmpty:urlString]) {
        NSString *filePath = [HTFolderDownLoadManager getOfflineFilePathOfUrl:urlString];
        if (![NSString isStringEmpty:filePath]) {
            return [HTFolderDownLoadManager isExistFile:filePath];
        }
    }
    return NO;
}

+(BOOL)isExistSong:(SNSongModel *)song
{
    if (song && ![NSString isStringEmpty:song.karaoke_file]) {
        if ([self isExistFileOfflineForUrl:song.karaoke_file]) {
            return YES;
        }
        if ([self isExistFileOnlineForUrl:song.karaoke_file]) {
            return YES;
        }
    }
    return NO;
}

+(DownloadFileType)getTypeOfFile:(NSString*)file
{
    return NoneFileType;
}
@end
