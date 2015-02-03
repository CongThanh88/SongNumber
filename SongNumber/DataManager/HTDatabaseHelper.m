//
//  HTDatabaseHelper.m
//  AVPlayerDemo
//
//  Created by Apple on 6/28/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "HTDatabaseHelper.h"
#import <sqlite3.h>
#import "NSString+Addition.h"
#define DATABASE_FILE_NAME   @"vitek.sqlite"
#define DATABASE_NAME        @"vitek"


static HTDatabaseHelper *dataHelper;

@implementation HTDatabaseHelper
{
    sqlite3 *databaseHandle;
}

-(id)init{
    self = [super init];
    if (self) {
        [self createEditablecopyofDatabaseifneeded];
    }
    return self;
}

-(void)updateSongFavorite:(SNSongModel*)song
{
    sqlite3_stmt *statement = nil;
    
    //query strinh
    int isFavorite = song.is_favorite?1:0;
    NSString *sql = [NSString stringWithFormat: @"Update song set is_favorite = %d where number = \'%@\'",isFavorite, song.number];
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([_dataBaseFilePath UTF8String], &databaseHandle) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(databaseHandle, [sql UTF8String], -1, &statement, NULL)
           == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"update success");
            }else{
                NSLog(@"error: %s\n",sqlite3_errmsg(databaseHandle));
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(databaseHandle);
    }
    
}

- (BOOL)copyFolderAtPath:(NSString *)sourceFolder toDestinationFolderAtPath:(NSString*)destinationFolder {
    //including root folder.
    //Just remove it if you just want to copy the contents of the source folder.
    destinationFolder = [destinationFolder stringByAppendingPathComponent:[sourceFolder lastPathComponent]];
    
    NSFileManager * fileManager = [ NSFileManager defaultManager];
    NSError * error = nil;
    //check if destinationFolder exists
    if ([ fileManager fileExistsAtPath:destinationFolder])
    {
        //removing destination, so soucer may be copied
        if (![fileManager removeItemAtPath:destinationFolder error:&error])
        {
            return NO;
        }
    }
    error = nil;
    //copying destination
    if ( !( [ fileManager copyItemAtPath:sourceFolder toPath:destinationFolder error:&error ]) )
    {
        return NO;
    }
    return YES;
}

-(SNSongModel*)getSongByNumber:(NSString*)songNumber
{
    
    // Create the query statement to get all persons
    NSString *queryStatement = [NSString stringWithFormat:@"SELECT * FROM Song where number = \"%@\"",songNumber];
    
    // Prepare the query for execution
    sqlite3_stmt *statement;
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([_dataBaseFilePath UTF8String], &databaseHandle) == SQLITE_OK)
    {
        if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            // Iterate over all returned rows
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                // Get associated address of the current person row
                char *titleChars = (char*)sqlite3_column_text(statement, 0);
                NSString *title = [[NSString alloc]initWithUTF8String:titleChars];

                
                char *titleShortChars = (char*)sqlite3_column_text(statement, 14);
                NSString *titleShortCut = [[NSString alloc]initWithUTF8String:titleShortChars];
                
                char *titleSearchChars1 = (char*)sqlite3_column_text(statement, 15);
                NSString *titleSearch1 = [[NSString alloc]initWithUTF8String:titleSearchChars1];
                
                char *titleSearchChars2 = (char*)sqlite3_column_text(statement, 16);
                NSString *titleSearch2 = [[NSString alloc]initWithUTF8String:titleSearchChars2];
                
                char *karaokeTypeChars = (char*)sqlite3_column_text(statement, 3);
                NSString *karaokeType = [[NSString alloc]initWithUTF8String:karaokeTypeChars];
                
                char *karaokeFileChars = (char*)sqlite3_column_text(statement, 4);
                NSString *karaokeFile = [[NSString alloc]initWithUTF8String:karaokeFileChars];
                
                char *shortLyricChars = (char*)sqlite3_column_text(statement, 7);
                NSString *shortLyrics = [[NSString alloc]initWithUTF8String:shortLyricChars];
                
                char *lyricFileChars = (char*)sqlite3_column_text(statement, 8);
                NSString *lyricFile = [[NSString alloc]initWithUTF8String:lyricFileChars];
                
                char *singerChars = (char*)sqlite3_column_text(statement, 5);
                NSString *singer = [[NSString alloc]initWithUTF8String:singerChars];
                
                char *musicByChars = (char*)sqlite3_column_text(statement, 1);
                NSString *musicBy = [[NSString alloc]initWithUTF8String:musicByChars];
                
                char *lyricByChars = (char*)sqlite3_column_text(statement, 2);
                NSString *lyricBy = [[NSString alloc]initWithUTF8String:lyricByChars];
                
                
                char *generChars = (char*)sqlite3_column_text(statement, 9);
                NSString *gener = [[NSString alloc]initWithUTF8String:generChars];
                
                char *numberChars = (char*)sqlite3_column_text(statement, 17);
                NSString *number = [[NSString alloc]initWithUTF8String:numberChars];
                
                char *languageChars = (char*)sqlite3_column_text(statement, 6);
                NSString *language = [[NSString alloc]initWithUTF8String:languageChars];
                
                char *isNewChars = (char*)sqlite3_column_text(statement, 20);
                BOOL isNew = [[[NSString alloc]initWithUTF8String:isNewChars] boolValue];
                
                char *isFreeChars = (char*)sqlite3_column_text(statement, 11);
                BOOL isFree = [[[NSString alloc]initWithUTF8String:isFreeChars] boolValue];
                
                SNSongModel *songObject = [[SNSongModel alloc]init];
                songObject.title = title;
                songObject.music_by = musicBy;
                songObject.lyric_by = lyricBy;
                songObject.karaoke_file = karaokeFile;
                songObject.karaoke_type = karaokeType;
                songObject.singer = singer;
                songObject.genre = gener;
                songObject.number = number;
                songObject.short_lyric = shortLyrics;
                songObject.title_search = titleSearch1;
                songObject.title_search2 = titleSearch2;
                songObject.title_shortcut = titleShortCut;
                songObject.lyric_file = lyricFile;
                songObject.is_free = isFree;
                songObject.is_new = isNew;
                songObject.language = language;
                return songObject;
            }
            sqlite3_finalize(statement);
        }
    }
    return nil;
}

-(NSArray*)querySongs:(NSString*)queryStatement
{
    // Allocate a persons array
    NSMutableArray *songs = [[NSMutableArray alloc]init];

    // Prepare the query for execution
    sqlite3_stmt *statement;
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([_dataBaseFilePath UTF8String], &databaseHandle) == SQLITE_OK)
    {
        if (sqlite3_prepare_v2(databaseHandle, [queryStatement UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            // Iterate over all returned rows
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                // Get associated address of the current person row
                char *titleChars = (char*)sqlite3_column_text(statement, 0);
                NSString *title = [[NSString alloc]initWithUTF8String:titleChars];
                
                char *musicByChars = (char*)sqlite3_column_text(statement, 1);
                NSString *musicBy = [[NSString alloc]initWithUTF8String:musicByChars];
                
                char *titleShortChars = (char*)sqlite3_column_text(statement, 14);
                NSString *titleShortCut = [[NSString alloc]initWithUTF8String:titleShortChars];
                
                char *titleSearchChars1 = (char*)sqlite3_column_text(statement, 15);
                NSString *titleSearch1 = [[NSString alloc]initWithUTF8String:titleSearchChars1];
                
                char *titleSearchChars2 = (char*)sqlite3_column_text(statement, 16);
                NSString *titleSearch2 = [[NSString alloc]initWithUTF8String:titleSearchChars2];
                
                char *karaokeTypeChars = (char*)sqlite3_column_text(statement, 3);
                NSString *karaokeType = [[NSString alloc]initWithUTF8String:karaokeTypeChars];
                
                char *karaokeFileChars = (char*)sqlite3_column_text(statement, 4);
                NSString *karaokeFile = [[NSString alloc]initWithUTF8String:karaokeFileChars];
                
                char *lyricFileChars = (char*)sqlite3_column_text(statement, 8);
                NSString *lyricFile = [[NSString alloc]initWithUTF8String:lyricFileChars];
                
                char *shortLyricChars = (char*)sqlite3_column_text(statement, 7);
                NSString *shortLyrics = [[NSString alloc]initWithUTF8String:shortLyricChars];
                
                char *singerChars = (char*)sqlite3_column_text(statement, 5);
                NSString *singer = [[NSString alloc]initWithUTF8String:singerChars];
                
                char *generChars = (char*)sqlite3_column_text(statement, 9);
                NSString *gener = [[NSString alloc]initWithUTF8String:generChars];
                
                char *numberChars = (char*)sqlite3_column_text(statement, 17);
                NSString *number = [[NSString alloc]initWithUTF8String:numberChars];
                
                char *languageChars = (char*)sqlite3_column_text(statement, 6);
                NSString *language = [[NSString alloc]initWithUTF8String:languageChars];
                
                char *isNewChars = (char*)sqlite3_column_text(statement, 20);
                BOOL isNew = [[[NSString alloc]initWithUTF8String:isNewChars] boolValue];
                
                char *isFreeChars = (char*)sqlite3_column_text(statement, 11);
                BOOL isFree = [[[NSString alloc]initWithUTF8String:isFreeChars] boolValue];
                
                char *isFavoriteChars = (char*)sqlite3_column_text(statement, 10);
                BOOL isFavorite = [[[NSString alloc]initWithUTF8String:isFavoriteChars] boolValue];
                
                SNSongModel *songObject = [[SNSongModel alloc]init];
                songObject.title = title;
                songObject.music_by = musicBy;
                songObject.karaoke_file = karaokeFile;
                songObject.karaoke_type = karaokeType;
                songObject.singer = singer;
                songObject.genre = gener;
                songObject.number = number;
                songObject.short_lyric = shortLyrics;
                songObject.title_search = titleSearch1;
                songObject.title_search2 = titleSearch2;
                songObject.title_shortcut = titleShortCut;
                songObject.lyric_file = lyricFile;
                songObject.is_free = isFree;
                songObject.is_favorite = isFavorite;
                songObject.is_new = isNew;
                songObject.language = language;
                [songs addObject:songObject];
            }
            sqlite3_finalize(statement);
        }
    }

    return songs;
}


//Update top 10 song from mp3 to midi
-(void)updateKaraokeFileForTopTenSong:(NSString*)number
{
    sqlite3_stmt *statement = nil;
    
    //query strinh
    NSString *sql = [NSString stringWithFormat: @"UPDATE song SET karaoke_file = REPLACE(karaoke_file, 'mp3', 'mid') WHERE   number = \"%@\"", number];
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([_dataBaseFilePath UTF8String], &databaseHandle) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(databaseHandle, [sql UTF8String], -1, &statement, NULL)
           == SQLITE_OK)
        {
            sqlite3_step(statement);
        
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(databaseHandle);
    }

}

+(HTDatabaseHelper*)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dataHelper = [HTDatabaseHelper new];
    });
    return dataHelper;
}

-(void)createEditablecopyofDatabaseifneeded
{
    NSError *error;
    NSFileManager *filemanagr = [NSFileManager defaultManager];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [path objectAtIndex:0];
    NSString *finalDBPath = [dbPath stringByAppendingPathComponent:DATABASE_FILE_NAME];
    _dataBaseFilePath=finalDBPath;
    if (![filemanagr fileExistsAtPath:finalDBPath]) {
        NSString *writableDBPath = [[NSBundle mainBundle] pathForResource:DATABASE_NAME ofType:@"sqlite"];
        [filemanagr copyItemAtPath:writableDBPath toPath:finalDBPath error:&error];
    }

}
@end
