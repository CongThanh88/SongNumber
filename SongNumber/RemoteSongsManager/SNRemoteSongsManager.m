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

@implementation SNRemoteSongsManager
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
        self.listSong = [[NSArray alloc]init];
    }
    return self;
}

-(NSArray*)parseListSongFromString:(NSString*)resultString
{
    if (![NSString isStringEmpty:resultString]) {
        NSArray *listSongString = [resultString componentsSeparatedByString:@"\n"];
        if (listSongString && listSongString.count>0) {
            _listSong = [SNSongModel parseListSongResponseString:listSongString];
        }
        return  listSongString;
    }
    return nil;
}

@end
