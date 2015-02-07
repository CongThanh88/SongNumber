//
//  SNSettingManager.h
//  AVPlayerDemo
//
//  Created by Cong Thanh on 6/24/14.
//  Copyright (c) 2014 com.khoisang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSettingManager : NSObject
@property(nonatomic,strong)NSArray *listKeys;
@property(nonatomic,strong)NSDictionary *dicSettingData;
@property(nonatomic,strong)NSDictionary *dicNgonNgu;
@property(nonatomic,strong)NSArray *listSTypeOfSongs;
@property(nonatomic,strong)NSArray *ListKindOfSongs;
@property(nonatomic,strong)NSArray *listActionSongQueue;
@property(nonatomic,strong)NSArray *listSortType;


+(SNSettingManager*)sharedInstance;
-(NSInteger)numberOfItem;

-(NSArray*)listKeys;
-(UIImage*)imageIconAtSettingIndex:(NSInteger)index;
-(NSString*)titleAtIndex:(NSInteger)index;
-(NSString*)titleForKey:(NSString*)key;
@end
