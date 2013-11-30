//
//  UIAlertView+Block.h
//  WYUICategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^WYUIAlertViewBlock)(NSInteger index);

@interface UIAlertView (Block)<UIAlertViewDelegate>

-(void)addActionHandler:(WYUIAlertViewBlock)block;

@end
