//
//  UIColor+Category.m
//  WYCategory
//
//  Created by tom on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+(UIColor *)RGBWithR:(float)r g:(float)g b:(float)b{

    return [self RGBAWithR:r g:g b:b a:1.0];
}

+(UIColor *)RGBAWithR:(float)r g:(float)g b:(float)b a:(float)a{

    return [self colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

@end
