//
//  UIImage+Category.m
//  WYCategory
//
//  Created by tom on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIImage+Category.h"
#import <CoreText/CoreText.h>

@implementation UIImage (Category)


#pragma mark - /*resize*/
+ (UIImage*)imageConverToSize:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)imageConverToSize:(CGSize)newSize{
    return [UIImage imageConverToSize:self scaledToSize:newSize];
}

- (UIImage *)imageCropped:(CGRect)bounds {
    CGFloat scale = MAX(self.scale, 1.0f);
    
    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef);
    
    return croppedImage;
}

#pragma mark - /*rotation*/

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    return [self imageRotatedByDegrees:degrees * M_PI / 180];
}

- (UIImage *)imageRotatedByAngle:(CGFloat)angle{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(angle);
    
    rotatedViewBox.transform = t;
    
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, angle);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - /*mask*/
-(UIImage *)addText:(UIImage *)img text:(NSString *)maskTxt
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    
    //  Get Chinese font
    CTFontRef ctFont = CTFontCreateWithName(CFSTR("STHeitiSC-Light"), 20.0, NULL);
    CGFontRef cgFont = CTFontCopyGraphicsFont(ctFont, NULL);
    
    CGContextSetFont(context, cgFont);
    CGContextSetFontSize(context, 60);
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 255, 255, 0.7);
    
    NSString *text = maskTxt;
    CGGlyph textGlyphs[[text length]];
    int count = [text length];
    UniChar characters[sizeof(UniChar) * count];
    
    // Get the characters from the string.
    CFStringGetCharacters((CFStringRef)text, CFRangeMake(0, count), characters);
    CTFontGetGlyphsForCharacters(ctFont, characters, textGlyphs, [text length]);
    CGContextShowGlyphsAtPoint(context, 100, 100, textGlyphs, [text length]);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    CGFontRelease(cgFont);
    CFRelease(ctFont);
    
    
    return [UIImage imageWithCGImage:imageMasked];
}

@end
