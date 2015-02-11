//
//  SNSongModel.h
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     TABLE_NAME                  @"song"
#define     KNumber                    @"number"
#define     kTitle                      @"title"
#define     kTitleShocut                @"title_shortcut"
#define     kTitle_search               @"title_search"
#define     kTitle_search2              @"title_search2"
#define     kMusic_by                   @"music_by"
#define     kLyric_by                   @"lyric_by"
#define     kKaraoke_type               @"karaoke_type"
#define     kKaraoke_file               @"karaoke_file"
#define     kVersion                    @"version"
#define     kSinger                     @"version"
#define     kSinger_search              @"singer_search"
#define     kLanguage                   @"language"
#define     kIs_free                    @"is_free"
#define     kShort_lyric                @"short_lyric"
#define     kLyric_file                 @"lyric_file"
#define     kGenre                      @"genre"
#define     kGenre_search               @"genre_search"
#define     kKaraoke_track              @"karaoke_track"
#define     kIs_favorite                @"is_favorite"
#define     kIs_new                     @"is_new"
#define     kArr_num                    @"arr_num"


@interface SNSongModel : NSObject

@property(nonatomic, strong)NSString *song;
@property(nonatomic, strong)NSString *number;
@property(nonatomic, strong)NSString *arr_num;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *title_shortcut;
@property(nonatomic, strong)NSString *title_search;
@property(nonatomic, strong)NSString *title_search2;
@property(nonatomic, strong)NSString *music_by;
@property(nonatomic, strong)NSString *lyric_by;
@property(nonatomic, strong)NSString *karaoke_type;
@property(nonatomic, strong)NSString *karaoke_file;
@property(nonatomic, assign)int version;
@property(nonatomic, strong)NSString *singer;
@property(nonatomic, strong)NSString *singer_search;
@property(nonatomic, strong)NSString *language;
@property(nonatomic, assign)BOOL is_free;
@property(nonatomic, strong)NSString *short_lyric;
@property(nonatomic, strong)NSString *lyric_file;
@property(nonatomic, strong)NSString *genre;
@property(nonatomic, strong)NSString *genre_search;
@property(nonatomic, assign)int karaoke_track;
@property(nonatomic, assign)BOOL is_favorite;
@property(nonatomic, assign)BOOL is_new;
@property(nonatomic, assign)BOOL is_local;
@property(nonatomic, assign)BOOL is_record;
@property(nonatomic, assign)BOOL isDownloaded;

+(SNSongModel*)parseData:(NSDictionary*)dic;

+(NSArray*)parseListData:(NSArray*)listDic;

+(SNSongModel*)parseSongFromResponseString:(NSString *)response;

+(NSArray*)parseListSongResponseString:(NSArray *)listString;

-(BOOL)isOnSingerVoice;

@end
