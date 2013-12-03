//
//  UIImage+Category.h
//  WYCategory
//
//  Created by tom on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage *)imageConverToSize:(UIImage*)image scaledToSize:(CGSize)newSize;

- (UIImage *)imageConverToSize:(CGSize)newSize;

- (UIImage *)imageCropped:(CGRect)bounds;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageRotatedByAngle:(CGFloat)angle;

@end
