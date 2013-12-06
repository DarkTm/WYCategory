//
//  UINavigationController+Animation.m
//  TestProject
//
//  Created by tom on 13-12-5.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import "UINavigationController+Animation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (Animation)

const float WYNavigationControllerAnimationDuration = 1.3;

-(void)customerPopViewController{

    CATransition *transition = [CATransition animation];
    transition.duration = WYNavigationControllerAnimationDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

-(void)customerPushViewController:(UIViewController *)c{

    CATransition *transition = [CATransition animation];
    transition.duration = WYNavigationControllerAnimationDuration;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:c animated:NO];
}

@end
