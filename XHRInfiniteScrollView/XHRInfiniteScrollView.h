//
//  XHRInfiniteScrollView.h
//  无限轮播
//
//  Created by haoran on 14/4/21.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHRInfiniteScrollView;

@protocol XHRInfiniteScrollViewDelegate <NSObject>

@optional
-(void)infiniteScrollView:(XHRInfiniteScrollView *)infiniteScrollView didClickImageAtIndex:(NSInteger)index;
@end

@interface XHRInfiniteScrollView : UIView
/** 需要显示的图片数据(要求里面存放UIImage\NSURL对象) */
@property (nonatomic, strong) NSArray *images;
/** 占位图片 **/
@property (nonatomic, strong) UIImage *placeHolderImage;

/** 用来监听框架内部事件的代理 */
@property (nonatomic, weak) id delegate;
@end
