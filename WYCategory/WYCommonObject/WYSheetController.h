//
//  WYSheetController.h
//  WYCategory
//
//  Created by tom on 13-12-6.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WYUIViewControllerAnimationBlock)(void);

@interface WYSheetController : UIViewController

@property(strong,nonatomic)UIView *contentView;

-(void)customerDismissViewControllerAnimated:(WYUIViewControllerAnimationBlock)aBlock;

-(void)customerPresentViewController;

@end
