//
//  CLNextViewController.m
//  CLImageScrollView
//
//  Created by nil on 16/3/16.
//  Copyright © 2016年 岑磊. All rights reserved.
//

#import "CLNextViewController.h"

@interface CLNextViewController () <UIScrollViewDelegate>

{
    BOOL flag;
}
/** 大ScrollView */
@property (nonatomic,strong) UIScrollView *scrollViews;
/** 小ScrollView */
@property (nonatomic,strong) UIScrollView *smallScrollView;
/** 页码 */
@property (nonatomic,strong) UIPageControl *pageControl;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/* 长按事件 */
@property (nonatomic,strong)  UILongPressGestureRecognizer *longPress;

@end

@implementation CLNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UITapGestureRecognizer *singTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singTop:)];
    [self.view addGestureRecognizer:singTop];
    
    self.scrollViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_height)];
    [self.view addSubview:self.scrollViews];
    
    
    NSMutableArray *mImags = [NSMutableArray array];
    
    for (int i = 0; i <10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%d",i+1]];
        [mImags addObject:image];
    }
    
    self.scrollViews.contentSize = CGSizeMake(Screen_Width * mImags.count, 0 );
    for (int i = 0; i<mImags.count; i++) {
        
        self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(Screen_Width * i, 0, Screen_Width, Screen_height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.smallScrollView.bounds];
        
        imageView.image = mImags[i];
        self.scrollViews.contentMode = UIViewContentModeScaleAspectFit;
        [self.smallScrollView addSubview:imageView];
        [self.scrollViews addSubview:self.smallScrollView];
        
        self.smallScrollView.maximumZoomScale = 2;
        self.smallScrollView.minimumZoomScale = 0;
        self.smallScrollView.zoomScale = 1;
        self.smallScrollView.bouncesZoom = NO;
        self.smallScrollView.delegate = self;
        
        self.scrollViews.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollViews.pagingEnabled = YES;
    }
    
    self.scrollViews.tag = 1000;
    self.scrollViews.delegate = self;
    self.scrollViews.showsHorizontalScrollIndicator = NO;
    self.scrollViews.contentOffset = CGPointMake(Screen_Width*_num, 0);
    
    
    
    [self page];
    [self longPressGesture];
}


-(void)page
{
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(Screen_Width -150 , Screen_height - 35, 100, 30)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = 10;
    self.pageControl.currentPage = _num;
    self.pageControl.tag = 2000;
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}



-(void)singTop:(UITapGestureRecognizer *)sender
{
    //点击返回dismissViewControllerAnimated
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
//只有滚动 scrollView 就会触发这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.pageControl.currentPage = page;
    //    NSLog(@"滚动中");
}

//当滚动彻底停止的时候会触发这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滚动停止");
    const int page = (int)(scrollView.contentOffset.x / Screen_Width);
    UIPageControl *pageControl = (UIPageControl *) [self.view viewWithTag:2000];
    pageControl.currentPage = page;
}

//指定某个 UIScrollView 的子视图可以做缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = [scrollView.subviews objectAtIndex:0];
    return imageView;
}

-(void)pageControlAction:(UIPageControl *)page
{
    NSLog(@"page.currentPage = %lu",page.currentPage);
    UIScrollView *scrollView= [self.view viewWithTag:1000];
    [scrollView setContentOffset:CGPointMake(Screen_Width * page.currentPage , 0) animated:YES];
}

//开始拖拽时候会触发这个方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
    [self stop];
}

//当结束拖拽时会触发这个方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
    [self addTimer];
}

#pragma mark - 幻灯片
//长按手势
-(void)longPressGesture
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.scrollViews addGestureRecognizer:longPress];
}

//长按事件
-(void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    //    NSLog(@"长按");
    [self stop];
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (flag == YES) {
                [self addTimer];
            }
            
        }];
        [alertController addAction:cancle];
        
        UIAlertAction *playSlide = [UIAlertAction actionWithTitle:@"幻灯片播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            flag = YES;
            [self addTimer];
        }];
        [alertController addAction:playSlide];
        
        UIAlertAction *stopSlide = [UIAlertAction actionWithTitle:@"幻灯片停止" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            flag = NO;
            [self stop];
            
        }];
        [alertController addAction:stopSlide];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

//定时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//下一页
- (void)nextPage{
    //当前页码书
    NSInteger page = self.pageControl.currentPage ;
    page++;
    NSLog(@"%lu = %lu",page,self.pageControl.numberOfPages);
    if (page == self.pageControl.numberOfPages) {
        page = 0;
    }
    //拿到当前页码数来改变偏移量
    CGPoint point = CGPointMake(self.smallScrollView.bounds.size.width * page, 0);
    [self.scrollViews setContentOffset:point animated:YES];
}
//停止定时器
-(void)stop
{
    [self.timer invalidate];
}



@end
