//
//  UIColor+Category.h
//  WYCategory
//
//  Created by tom on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

@end


@interface UIColor (rgb)

+(UIColor *)RGBWithR:(float)r g:(float)g b:(float)b;
+(UIColor *)RGBAWithR:(float)r g:(float)g b:(float)b a:(float)a;

@end