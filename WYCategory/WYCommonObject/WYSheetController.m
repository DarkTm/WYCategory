//
//  WYSheetController.m
//  WYCategory
//
//  Created by tom on 13-12-6.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "WYSheetController.h"

#import <QuartzCore/QuartzCore.h>

@interface WYSheetController ()
{
    UIView *_bgView;
}

-(UIViewController *)rootViewController;

@end

@implementation WYSheetController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
    [self.view addSubview:_bgView];
}


-(void)customerDismissViewControllerAnimated:(WYUIViewControllerAnimationBlock)aBlock{
    
    UIView *bg = _bgView;
    UIView *content = self.contentView;
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    [CATransaction setCompletionBlock:^{
        aBlock();
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(content.frame), CGRectGetMidY(content.frame))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(content.center.x, CGRectGetMaxY(self.view.bounds))];
    animation.duration = .3 ;
    [content.layer addAnimation:animation forKey:@"animation"];
    
    CABasicAnimation *animationAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationAlpha.fromValue = [NSNumber numberWithFloat:0];
    animationAlpha.toValue = [NSNumber numberWithFloat:.5];
    animationAlpha.duration = .3;
    [bg.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    [CATransaction commit];
    
    [[self rootViewController] dismissViewControllerAnimated:YES completion:NULL];
    
    [self rootViewController].modalTransitionStyle = UIModalPresentationFullScreen;
}

-(void)customerPresentViewController{
    
    [self rootViewController].modalTransitionStyle = UIModalPresentationCurrentContext;

    UIView *bg = _bgView;
    UIView *content = self.contentView;
    
    [self.view addSubview:content];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(content.center.x, CGRectGetMaxY(self.view.bounds))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(content.frame), CGRectGetMidY(content.frame))];
    animation.duration = .3 ;
    [content.layer addAnimation:animation forKey:@"animation"];
    
    CABasicAnimation *animationAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationAlpha.fromValue = [NSNumber numberWithFloat:0];
    animationAlpha.toValue = [NSNumber numberWithFloat:.5];
    animationAlpha.duration = .3;
    [bg.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    [CATransaction commit];
    
    [[self rootViewController] presentViewController:self animated:YES completion:NULL];
}


-(UIViewController *)rootViewController{

    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
