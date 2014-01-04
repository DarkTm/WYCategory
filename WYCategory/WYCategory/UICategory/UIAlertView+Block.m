//
//  UIAlertView+Block.m
//  WYUICategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static char *WYUIAlertViewKey = "WYUIAlertViewKey";

@implementation UIAlertView (Block)

-(void)addActionHandler:(WYUIAlertViewBlock)block{

    objc_setAssociatedObject(self, WYUIAlertViewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    WYUIAlertViewBlock block = objc_getAssociatedObject(self, WYUIAlertViewKey);
    block(buttonIndex);
}


+(UIAlertView *)showAlertViewWithTitle:(NSString *)title{
    UIAlertView *a = [UIAlertView showAlertViewWithTitle:title withMessage:nil];
    return a;
}
+(UIAlertView *)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)msg{
    UIAlertView *a = [UIAlertView showAlertViewWithTitle:title withMessage:msg withAction:NULL];
    return a;
}
+(UIAlertView *)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)msg withAction:(WYUIAlertViewBlock)block{
    
    NSString *mTitle = title;
    NSString *mMessage = msg;
    if(!title)
        mTitle = @"";
    if(!msg)
        mMessage = @"";
    
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:mTitle message:mMessage delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    if(block){
    
//        __weak WYUIAlertViewBlock bb = block;
        
        [a addActionHandler:^(NSInteger index) {
            block(index);
        }];
        
    }
    [a show];
    return  a;
}

@end
