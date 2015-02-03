//
//  SNSettingManager.m
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/24/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import "SNSettingManager.h"
#import "NSString+Addition.h"
#import  "HTLocalizeHelper.h"
#include <sys/_types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define ORDER       @"order"

static SNSettingManager *settingManager;

@implementation SNSettingManager
+(SNSettingManager*)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        settingManager = [SNSettingManager new];
    });
    return settingManager;
}

-(id)init{
    self = [super init];
    if (self) {
        
        //Load settingValues.plist
        NSString *pathFile = [[NSBundle mainBundle]pathForResource:@"SettingValues" ofType:@"plist"];
        NSDictionary *settingData = [NSDictionary dictionaryWithContentsOfFile:pathFile];
        if (settingData) {
            self.listKeys = [settingData allKeys];
            self.listKeys = [self.listKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSNumber* key1 = [[settingData objectForKey:obj1] objectForKey:ORDER];
                     NSNumber* key2 = [[settingData objectForKey:obj2] objectForKey:ORDER];
                     return [key1 compare: key2];
            }];
            self.dicSettingData = settingData;
            self.dicNgonNgu = [settingData objectForKey:@"NgonNgu"];
            
        }
        //Load TheLoaiBaiHat.plist
        pathFile = [[NSBundle mainBundle]pathForResource:@"TheLoaiBaiHat" ofType:@"plist"];
        NSDictionary *theLoaiBaiHat = [NSDictionary dictionaryWithContentsOfFile:pathFile];
        if (theLoaiBaiHat) {
            self.listSTypeOfSongs= [theLoaiBaiHat objectForKey:@"ListTypeSong"];
            self.ListKindOfSongs = [theLoaiBaiHat objectForKey:@"ListKindOfSongs"];
            self.listActionSongQueue = [theLoaiBaiHat objectForKey:@"SongQueueAction"];
            self.listSortType = [theLoaiBaiHat objectForKey:@"ListSortType"];
        }
    }
    return self;
}


-(NSInteger)numberOfItem
{
    if (_dicSettingData) {
        return [_dicSettingData allKeys].count;
    }
    return 0;
}

-(NSArray*)listKeys
{
    return _listKeys;
}

-(UIImage*)imageIconAtSettingIndex:(NSInteger)index
{
    if (index>=0 && index < _listKeys.count) {
        NSString *key = [_listKeys objectAtIndex:index];
        NSDictionary *currentDic = [_dicSettingData objectForKey:key];
        if (currentDic) {
            NSString *imgName = [currentDic objectForKey:@"icon"];
            if (![NSString isStringEmpty:imgName]) {
                return [UIImage imageNamed:imgName];
            }
        }
    }
    return nil;
}

-(NSString*)titleForKey:(NSString*)key
{
    NSDictionary *currentDic = [_dicSettingData objectForKey:key];
    if (currentDic) {
        NSString *lsName = [currentDic objectForKey:@"name"];
        if (![NSString isStringEmpty:lsName]) {
            return LocalizedString(lsName);
        }
    }
    return nil;
}

-(NSString*)titleAtIndex:(NSInteger)index
{
    if (index>=0 && index < _listKeys.count) {
        NSString *key = [_listKeys objectAtIndex:index];
        NSDictionary *currentDic = [_dicSettingData objectForKey:key];
        if (currentDic) {
            NSString *lsName = [currentDic objectForKey:@"name"];
            if (![NSString isStringEmpty:lsName]) {
                return LocalizedString(lsName);
            }
        }
    }
    return nil;
}

@end
