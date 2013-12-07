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

@synthesize bgView = _bgView;

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
        
    [CATransaction begin];
    
    [CATransaction setDisableActions:NO];
    
    WYSheetController *_weak = self;
    [CATransaction setCompletionBlock:^{
        
        [_weak dismissViewControllerAnimated:NO completion:NULL];
        [_weak rootViewController].modalTransitionStyle = UIModalPresentationFullScreen;
        
        if(aBlock)
            aBlock();
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.contentView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.view.frame) + 100)];
    animation.duration = .5 ;
    
    
    NSLog(@"end:%@",[NSValue valueWithCGPoint:CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.view.frame))]);
    
    CABasicAnimation *animationAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationAlpha.fromValue = [NSNumber numberWithFloat:0.5];
    animationAlpha.toValue = [NSNumber numberWithFloat:0];
    animationAlpha.duration = .5;
    
    [self.contentView.layer addAnimation:animation forKey:@"animation"];
    [_bgView.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    
    [CATransaction commit];
}

-(void)customerPresentViewController{
    
    [self rootViewController].modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self.view addSubview:self.contentView];
    
    
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:NO];
    
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.view.frame) + 100)];
    animation.toValue = [NSValue valueWithCGPoint:self.contentView.center];
    animation.duration = .5 ;
    
    
    NSLog(@"from:%@",[NSValue valueWithCGPoint:CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.view.frame))]);
    
    CABasicAnimation *animationAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationAlpha.fromValue = [NSNumber numberWithFloat:0];
    animationAlpha.toValue = [NSNumber numberWithFloat:.5];
    animationAlpha.duration = .5;
    
    [self.contentView.layer addAnimation:animation forKey:@"animation"];
    [_bgView.layer addAnimation:animationAlpha forKey:@"animationAlpha"];
    
    [CATransaction commit];
    [[self rootViewController] presentViewController:self animated:NO completion:NULL];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self customerDismissViewControllerAnimated:NULL];
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
