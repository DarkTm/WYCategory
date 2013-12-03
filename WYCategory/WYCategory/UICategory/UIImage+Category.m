//
//  UIImage+Category.m
//  WYCategory
//
//  Created by tom on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)


#pragma mark /*resize*/
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

#pragma mark /*rotation*/

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

@end
