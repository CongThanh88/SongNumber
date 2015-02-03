//
//  HTLocalizeHelper.h
//  IKaraoke
//
//  Created by Apple on 7/22/14.
//  Copyright (c) 2014 com.softfront. All rights reserved.
//

#import <Foundation/Foundation.h>

// some macros (optional, but makes life easy)

// Use "LocalizedString(key)" the same way you would use "NSLocalizedString(key,comment)"
#define LocalizedString(key) [[HTLocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizationSetLanguage(language) [[HTLocalizeHelper sharedLocalSystem] setLanguage:(language)]

@interface HTLocalizeHelper : NSObject

// a singleton:
+ (HTLocalizeHelper*) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*) key;

//set a new language:
- (void) setLanguage:(NSString*) lang;
@end
