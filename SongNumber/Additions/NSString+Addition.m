//
//  NSString+Addition.m
//
//  Created by ThanhDC4 on 3/10/14.
//  Copyright (c) 2014 ThanhDC4. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)
+(BOOL)isStringEmpty:(NSString*)stringValue
{
    if ((NSNull *) stringValue == [NSNull null]) {
        return YES;
    }
    
    if (stringValue == nil) {
        return YES;
    } else if ([stringValue length] == 0) {
        return YES;
    } else {
        NSString *temp = [stringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([temp length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)formatMoney:(double)salary {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:salary]];
    numberAsString = [numberAsString stringByAppendingString:@" VND"];
    return numberAsString;
}

+ (BOOL)textIsValidEmailFormat:(NSString *)text {
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:text];
}

+(NSDate*)parseDateString:(NSString*)stringDate
{
    if ([NSString isStringEmpty:stringDate]) {
        return nil;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateParsed = [dateFormat dateFromString:stringDate];
	return dateParsed;
}

+(BOOL)isNumeric:(NSString*)inputString {
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

-(CGSize)sizeWithFont:(UIFont*)font {
    CGSize lineframeSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return lineframeSize;
}

+(NSAttributedString*)attributesFromString:(NSString*)textContent font:(UIFont*)font fontInsideColor:(UIColor*)insideColor fontBorderColor:(UIColor*)borderColor
{
    if (![NSString isStringEmpty:textContent]) {
        if (!font) {
            font = [UIFont systemFontOfSize:14];
        }
        NSDictionary *typingAttributes = @{
                                           NSFontAttributeName: font,
                                           NSForegroundColorAttributeName : insideColor,
                                           NSStrokeColorAttributeName : borderColor,
                                           NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-4.0]
                                           };
        NSAttributedString *str = [[NSAttributedString alloc]
                                   initWithString:textContent
                                   attributes:typingAttributes];
        return str;
        
    }
    return nil;
}

+(BOOL)isEmptyStringClientId:(NSString*)clientId
{
    if ([self isStringEmpty:clientId] || [@"0" isEqualToString:clientId]) {
        return YES;
    }
    return NO;
}


@end
