//
//  SNRemoteSongsManager.h
//  SongNumber
//
//  Created by Hai_Apple on 2/5/15.
//  Copyright (c) 2015 KS.songnumber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNRemoteSongsManager : NSObject
@property(nonatomic, strong)NSArray *listSong;

+(instancetype)sharedInstance;
-(NSArray*)parseListSongFromString:(NSString*)resultString;
@end
