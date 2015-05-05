//
//  MainViewController.h
//  addChildViewControllerTest
//
//  Created by freedom on 15/4/13.
//  Copyright (c) 2015年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIViewController *leftViewController;
@property(nonatomic,strong) UIViewController *centerViewController;
@property(nonatomic,strong) UIViewController *rightViewController;

@end
