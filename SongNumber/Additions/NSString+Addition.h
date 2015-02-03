//
//  NSString+Addition.h
//
//  Created by ThanhDC4 on 3/10/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
+(BOOL)isStringEmpty:(NSString*)stringValue;
+(NSString *)formatMoney:(double) salary;
+ (BOOL)textIsValidEmailFormat:(NSString *)text;
+(BOOL)isNumeric:(NSString*)inputString;
+(NSDate*)parseDateString:(NSString*)stringDate;
+(NSAttributedString*)attributesFromString:(NSString*)textContent font:(UIFont*)font fontInsideColor:(UIColor*)insideColor fontBorderColor:(UIColor*)borderColor;
-(CGSize)sizeWithFont:(UIFont*)font;
+(BOOL)isEmptyStringClientId:(NSString*)clientId;
@end
