//
//  NSString+Category.m
//  WYNSCategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "NSString+Category.h"
#import "NSData+Category.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)
@end

#pragma mark - md5 -

@implementation NSString(md5)

- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

@end

#pragma mark - base64 -
@implementation NSString (base64)

- (NSData *)base64DecodedData{
    return [NSData dataWithBase64EncodedString:self];
}

- (NSString *)base64EncodedString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString{
    return [NSString stringWithBase64EncodedString:self];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)string{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

@end

#pragma mark - folder path -

@implementation NSString (path)

+(NSString *)getFolderWithType:(NSSearchPathDirectory)type{
    
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) objectAtIndex:0];
}

@end
