//
//  HTDatabaseHelper.h
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSongModel.h"

@class HTConfigManager;

@interface HTDatabaseHelper : NSObject
@property(nonatomic,strong)NSString *dataBaseFilePath;
+(HTDatabaseHelper*)sharedInstance;
-(NSArray*)querySongs:(NSString*)queryStatement;
-(SNSongModel*)getSongByNumber:(NSString*)songNumber;
-(void)updateSongFavorite:(SNSongModel*)song;
@end
