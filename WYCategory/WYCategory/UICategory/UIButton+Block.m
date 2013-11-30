//
//  UIButton+Block.m
//  WYUICategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char WYUIButtonBlockKey;

@implementation UIButton (Block)

-(void)addActionHandler:(void (^)(NSInteger))touchHandler{

    objc_setAssociatedObject(self, &WYUIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(on_btn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)on_btn:(UIButton *)btn{

    WYUIButtonBlock block = objc_getAssociatedObject(self, &WYUIButtonBlockKey);
    
    block(btn.tag);
}

@end
