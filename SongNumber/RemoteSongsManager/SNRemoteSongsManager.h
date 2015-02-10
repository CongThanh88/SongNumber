//
//  SNRemoteSongsManager.h
//  SongNumber
//
//  Created by Hai_Apple on 2/5/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSStream.h>

#define PORT       6789

typedef enum : unsigned char {
    REMOTE_PING = 0,
    REMOTE_SONG_LIST = 1,
    REMOTE_RES = 2,
    REMOTE_1ST_RES = 3,
    REMOTE_PLAY = 4,
    REMOTE_PAUSE = 5,
    REMOTE_STOP = 6,
    REMOTE_NEXT = 7,
    REMOTE_SELECT_TRACK = 8,
    REMOTE_FAVORITE = 9,
    REMOTE_UNFAVORITE = 10,
    REMOTE_QUEUE_MOVE_UP = 11,
    REMOTE_QUEUE_MOVE_FIRST = 12,
    REMOTE_QUEUE_REMOVE = 13,
    REMOTE_QUEUE_LIST = 14,
    REMOTE_DISCONNECT = 15,
    REMOTE_VOLUME_UP = 16,
    REMOTE_VOLUME_DOWN = 17,
    REMOTE_MESSAGE = 18,
    REMOTE_SCORING = 19
} REMOTE;


@interface SNRemoteSongsManager : NSObject<NSStreamDelegate>
@property(nonatomic, strong)NSMutableArray *listSong;
@property(nonatomic, strong) void(^requestListSongsCompleted)(void);
@property(nonatomic, strong) void(^connectCompleted)(BOOL success, NSError *error);

+(instancetype)sharedInstance;
- (void)initNetworkCommunicationToHost:(NSString*)host port:(UInt32)port;
-(void)parseListSongFromString:(NSString*)resultString;
-(void)requestGetListSong;
-(void)sendRemoteControl:(REMOTE)remote andValue:(int)value;
@end
