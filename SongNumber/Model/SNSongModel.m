//
//  KSSongModel.m
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.khoisang. All rights reserved.
//

#import "SNSongModel.h"

@implementation SNSongModel
-(id)init
{
    self = [super init];
    if (self) {
        self.is_new = NO;
        self.is_local = NO;
        self.is_record = NO;
    }
    return self;
}

+(SNSongModel*)parseData:(NSDictionary*)dic
{
    SNSongModel *songResult;
    if (dic) {
        songResult = [[SNSongModel alloc]init];
        songResult.number = [dic objectForKey:KNumber];
        songResult.title = [dic objectForKey:kTitle];
        songResult.title_shortcut = [dic objectForKey:kTitleShocut];
        songResult.title_search = [dic objectForKey:kTitle_search];
        songResult.title_search2 = [dic objectForKey:kTitle_search2];
        songResult.music_by = [dic objectForKey:kMusic_by];
        songResult.lyric_by = [dic objectForKey:kLyric_by];
        songResult.karaoke_type = [dic objectForKey:kKaraoke_type];
        songResult.karaoke_file = [dic objectForKey:kKaraoke_file];
        songResult.version = [[dic objectForKey:kVersion] intValue];
        songResult.singer = [dic objectForKey:kSinger];
        songResult.singer_search = [dic objectForKey:kSinger_search];
        songResult.language = [dic objectForKey:kLanguage];
        songResult.is_free = [[dic objectForKey:kIs_free] boolValue];
        songResult.is_new = [[dic objectForKey:kIs_new] boolValue];
        songResult.short_lyric = [dic objectForKey:kShort_lyric];
        songResult.lyric_file = [dic objectForKey:kLyric_file];
        songResult.genre = [dic objectForKey:kGenre];
        songResult.genre_search = [dic objectForKey:kGenre_search];
        songResult.karaoke_track = [[dic objectForKey:kKaraoke_track] intValue];
    }
    return songResult;
}

+(NSArray*)parseListData:(NSArray*)listDic
{
    NSArray *listData;
    if (listDic) {
        listData = [[NSArray alloc]init];
        for (NSDictionary *dic in listDic) {
            if (dic) {
                SNSongModel *song = [SNSongModel parseData:dic];
                if (song) {
                    listData = [listData arrayByAddingObject:song];
                }
            }
        }
    }
    return listData;
}

+(SNSongModel*)parseSongFromResponseString:(NSString *)response
{
    if (response) {
        NSArray *arrayFields = [response componentsSeparatedByString:@"\t"];
        if (arrayFields && arrayFields.count >0 ) {
            SNSongModel *newSong = [[SNSongModel alloc]init];
            newSong.number = [arrayFields objectAtIndex:0];
            if (arrayFields.count >1 ) {
                newSong.title = [arrayFields objectAtIndex:1];
            }
            if (arrayFields.count >2 ) {
                newSong.title_shortcut = [arrayFields objectAtIndex:2];
            }
            if (arrayFields.count >3 ) {
                newSong.title_search = [arrayFields objectAtIndex:3];
            }
            if (arrayFields.count >4 ) {
                newSong.title_search2 = [arrayFields objectAtIndex:4];
            }
            if (arrayFields.count >5 ) {
                newSong.singer = [arrayFields objectAtIndex:5];
            }
            if (arrayFields.count >6 ) {
                newSong.genre = [arrayFields objectAtIndex:6];
            }
            if (arrayFields.count >7 ) {
                newSong.genre_search = [arrayFields objectAtIndex:7];
            }
            if (arrayFields.count >8 ) {
                newSong.short_lyric = [arrayFields objectAtIndex:8];
            }
            if (arrayFields.count >9 ) {
                newSong.language = [arrayFields objectAtIndex:9];
            }
            if (arrayFields.count >10 ) {
                newSong.is_favorite = [[arrayFields objectAtIndex:10] boolValue];
            }
            if (arrayFields.count >11 ) {
                newSong.is_free = [[arrayFields objectAtIndex:11] boolValue];
            }
            if (arrayFields.count >12 ) {
                newSong.is_new = [[arrayFields objectAtIndex:12] boolValue];
            }
            return newSong;
        }
    }
    return nil;
}

+(NSArray*)parseListSongResponseString:(NSArray *)listString
{
    if (listString && listString.count>0) {
        NSArray *listSong = [[NSArray alloc]init];
        int i=0;
        for (NSString *songResponse in listString) {
            if (songResponse && i<10000) {
                i++;
                SNSongModel *newSong = [SNSongModel parseSongFromResponseString:songResponse];
                if (newSong) {
                    listSong = [listSong arrayByAddingObject:newSong];
                }
            }else{
                return listSong;
            }
        }
        return listSong;
    }
    return nil;
}

-(BOOL)isOnSingerVoice
{
    if ([@"VOCAL" isEqualToString:_genre] || [@"Video" isEqualToString:_genre]) {
        return YES;
    }
    return NO;
}
@end
