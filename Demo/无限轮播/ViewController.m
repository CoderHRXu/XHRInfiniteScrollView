//
//  ViewController.m
//  无限轮播
//
//  Created by haoran on 16/4/21.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

#import "ViewController.h"
#import "XHRInfiniteScrollView.h"
@interface ViewController () <XHRInfiniteScrollViewDelegate>

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    XHRInfiniteScrollView * scrollView = [[XHRInfiniteScrollView alloc]init];
    scrollView.images = @[
                  [UIImage imageNamed:@"img_00"],
                  [UIImage imageNamed:@"img_01"],
//                  [UIImage imageNamed:@"img_02"],
//                  [UIImage imageNamed:@"img_03"],
//                  [UIImage imageNamed:@"img_04"],
                  [NSURL URLWithString:@"http://n.sinaimg.cn/translate/20160421/_A8Z-fxrizpp1890330.jpg"],
                  [NSURL URLWithString:@""]
                  
                  ];
    
    scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

}

#pragma mark - XHRInfiniteScrollViewDelegate
-(void)infiniteScrollView:(XHRInfiniteScrollView *)infiniteScrollView didClickImageAtIndex:(NSInteger)index{
    
    // 处理点击图片的业务逻辑
    NSLog(@"点击了第%zd张图片",index);
}
@end
