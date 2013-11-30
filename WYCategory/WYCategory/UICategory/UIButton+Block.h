//
//  UIButton+Block.h
//  WYUICategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^WYUIButtonBlock)(NSInteger tag);

@interface UIButton (Block)

-(void)addActionHandler:(void (^)(NSInteger tag))touchHandler;


@end
