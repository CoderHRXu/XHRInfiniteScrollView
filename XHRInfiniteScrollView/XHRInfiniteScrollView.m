//
//  XHRInfiniteScrollView.m
//  无限轮播
//
//  Created by haoran on 16/4/21.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

#import "XHRInfiniteScrollView.h"
#import "UIImageView+WebCache.h"


/************** XHRImageCell begin **************/
#pragma mark - XHRImageCell begin
@interface XHRCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation XHRCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end

/************** XHRImageCell end **************/

/************** XHRInfiniteScrollView begin **************/
#pragma mark - XHRInfiniteScrollView begin
@interface XHRInfiniteScrollView()  <UICollectionViewDataSource, UICollectionViewDelegate>
/** <#名称#> **/
@property (nonatomic, weak) UICollectionView *collectionView;

/** 计时器 **/
@property (nonatomic, weak) NSTimer *timer;

@end
@implementation XHRInfiniteScrollView 

static NSInteger XHRItemCount  = 100;
static NSString * const ID = @"cell";

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {        
        
        // 创建流水布局
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        
        // 设置item之间间距
        layout.minimumLineSpacing = 0;
        // 设置滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        // 注册cell
        [collectionView registerClass:[XHRCollectionViewCell class] forCellWithReuseIdentifier:ID];
        
        // 设置默认占位图片
        self.placeHolderImage = [UIImage imageNamed:@"XHRInfiniteScrollView.bundle/placeholderImage"];

    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    // collectionView
    self.collectionView.frame = self.bounds;
    
    // layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.bounds.size;

}

#pragma mark - set方法
-(void)setImages:(NSArray *)images{

    _images = images;
    
    // 设置默认显示最中间的图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:XHRItemCount* self.images.count / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        [self startTimer];
        
    });
}


#pragma mark - 定时器
-(void)startTimer{
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}
-(void)nextPage{
    
    CGPoint offset = self.collectionView.contentOffset ;
    offset.x += self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:offset animated:YES ];
    
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return XHRItemCount * self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XHRCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    id data = self.images[indexPath.item % self.images.count];
    if ([data isKindOfClass:[UIImage class]]) {
        cell.imageView.image = data;
    }else if([data isKindOfClass:[NSURL class]]){
    
        [cell.imageView sd_setImageWithURL:data placeholderImage:self.placeHolderImage];
    }
    
    NSLog(@"%zd",indexPath.item);
    return  cell;
    
}



#pragma mark - 其他
-(void)resetPosition{
    
    // 滚动完毕时，自动显示最中间的cell
    NSInteger oldItem = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    NSInteger newItem = XHRItemCount / 2  * self.images.count+ oldItem % self.images.count;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


#pragma mark - <UICollectionViewDelegate>
/**
 *  点击了collectionView的Cell
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didClickImageAtIndex:)]) {
        [self.delegate infiniteScrollView:self didClickImageAtIndex:indexPath.item % self.images.count ];
    }


}


/**
 *  即将开始拖拽
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopTimer];
}

/**
 *  即将结束拖拽
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

/**
 *  scrollView滚动完毕的时候调用（人为拖拽滚动）
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self resetPosition];
}

/**
 *  scrollView滚动完毕的时候调用（通过setContentOffset:animated:滚动）
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self resetPosition];
}





@end
