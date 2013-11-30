//
//  UIAlertView+Block.m
//  WYUICategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static char WYUIAlertViewKey;

@implementation UIAlertView (Block)

-(void)addActionHandler:(WYUIAlertViewBlock)block{

    objc_setAssociatedObject(self, &WYUIAlertViewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    WYUIAlertViewBlock block = objc_getAssociatedObject(self, &WYUIAlertViewKey);
    block(buttonIndex);
}

@end
