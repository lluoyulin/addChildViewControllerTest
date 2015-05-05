//
//  MainViewController.m
//  addChildViewControllerTest
//
//  Created by freedom on 15/4/13.
//  Copyright (c) 2015年 freedom_luo. All rights reserved.
//

#import "MainViewController.h"

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

static const NSTimeInterval ShowOrHideAnimationDuration=0.5;//显示或隐藏子ViewController动画时间
static const CGFloat CenterViewControllerOffset=200.0;//中间ViewController偏移量
static const CGFloat CenterViewControllerScale=0.7;//中间ViewController缩放比例

@interface MainViewController ()

@end

@implementation MainViewController
{
    BOOL isCenter;//中间视图是否在中心
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addChildViewController:self.leftViewController];
    [self.view addSubview:self.leftViewController.view];
    
    [self addChildViewController:self.rightViewController];
    [self.view addSubview:self.rightViewController.view];
    
    [self addChildViewController:self.centerViewController];
    [self.view addSubview:self.centerViewController.view];
    
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.centerViewController.view addGestureRecognizer:panGesture];
    panGesture.delegate=self;
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame=CGRectMake(30, 20, 60, 30);
    [leftBtn setTitle:@"左边VC" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(touchLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.centerViewController.view addSubview:leftBtn];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame=CGRectMake(230, 20, 60, 30);
    [rightBtn setTitle:@"右边VC" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchRithtBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.centerViewController.view addSubview:rightBtn];
    
    isCenter=YES;
}

-(void)touchLeftBtn:(UIButton *)btn
{
    if (self.centerViewController.view.frame.origin.x==0) {
        [self showLeftViewControllerDuration:ShowOrHideAnimationDuration];
    }
    else{
        [self hideLeftViewControllerDuration:ShowOrHideAnimationDuration];
    }
}

-(void)touchRithtBtn:(UIButton *)btn
{
    if (self.centerViewController.view.frame.origin.x==0) {
        [self showRightViewControllerDuration:ShowOrHideAnimationDuration];
    }
    else{
        [self hideRightViewControllerDuration:ShowOrHideAnimationDuration];
    }
}

-(void)showLeftViewControllerDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.centerViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(CenterViewControllerOffset, 0), CenterViewControllerScale, CenterViewControllerScale);
        self.rightViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(CenterViewControllerOffset, 0), CenterViewControllerScale, CenterViewControllerScale);
    }];
}

-(void)hideLeftViewControllerDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.centerViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1, 1);
        self.rightViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1, 1);
    }];
}

-(void)showRightViewControllerDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.centerViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(-CenterViewControllerOffset, 0), CenterViewControllerScale, CenterViewControllerScale);
        self.leftViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(-CenterViewControllerOffset, 0), CenterViewControllerScale, CenterViewControllerScale);
    }];
}

-(void)hideRightViewControllerDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.centerViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1, 1);
        self.leftViewController.view.transform=CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1, 1);
    }];
}

-(void)moveCenterControllerTranslation:(CGFloat)translation
{
    CGFloat moveScale=1.0-CenterViewControllerScale/CenterViewControllerOffset*translation*(1.0-CenterViewControllerScale);
    
    if (translation>CenterViewControllerOffset) {
        translation=CenterViewControllerOffset;
    }
    if (moveScale<CenterViewControllerScale) {
        moveScale=CenterViewControllerScale;
    }
    
    CGAffineTransform makeTranslation=CGAffineTransformMakeTranslation(translation, 0);
    CGAffineTransform makeScale=CGAffineTransformScale(makeTranslation, moveScale, moveScale);
    
    self.centerViewController.view.transform=makeScale;
    self.rightViewController.view.transform=makeScale;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            if (translation.x>0) {//右划
                if (isCenter) {
                    [self moveCenterControllerTranslation:translation.x];
                }
            }
            else{//左划
                if (!isCenter) {
                    if (CenterViewControllerOffset+translation.x>0) {
                        [self moveCenterControllerTranslation:CenterViewControllerOffset+translation.x];
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (translation.x>0) {//右划
                if (translation.x>30) {
                    [self showLeftViewControllerDuration:0.3];
                    isCenter=NO;
                }
                else{
                    [self hideLeftViewControllerDuration:0.3];
                    isCenter=YES;
                }
            }
            else{//左划
                if(translation.x<-30)
                {
                    [self hideLeftViewControllerDuration:0.3];
                    isCenter=YES;
                }
                else{
                    [self showLeftViewControllerDuration:0.3];
                    isCenter=NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            break;
        }
        default:
            break;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.centerViewController.view.frame.origin.x<0) {
        return NO;
    }
    return YES;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
