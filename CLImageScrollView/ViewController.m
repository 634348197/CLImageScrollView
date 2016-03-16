//
//  ViewController.m
//  CLImageScrollView
//
//  Created by nil on 16/3/16.
//  Copyright © 2016年 岑磊. All rights reserved.
//

#import "ViewController.h"
#import "CLDisplayImageView.h"
#import "CLNextViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:34/255.0 green:199/255.0 blue:1 alpha:1];
    
    //判断手机当前的操作系统
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0 ? YES : NO)  {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_height - 64)];
    scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:scrollView];
    
    NSMutableArray *mImags = [NSMutableArray array];
    
    for (int i = 0; i <10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%d",i+1]];
        [mImags addObject:image];
    }
    
    
    int count = 0;
    //行
    if (mImags.count %3 == 0) {
        count = (int)mImags.count / 3;
    }
    else
    {
        count = (int)mImags.count /3 +1;
    }
    //高
    CGFloat height = (Screen_height - 64) / 2;
    //宽
    CGFloat width = Screen_Width /3;
    NSLog(@"%f",height);
    
    
    scrollView.contentSize = CGSizeMake(0, height * count);
    
    int num = 0;
    for (int i =0; i < count; i++) {
        
        for (int j = 0; j < 3; j++) {
            
            if (num == mImags.count) {
                
                break;
            }
            
            CLDisplayImageView *imageView = [[CLDisplayImageView alloc] initWithFrame:CGRectMake(width * j, height * i, width, height) Image:mImags[num ++]];
            [scrollView addSubview:imageView];
            imageView.tag = 100+num-1;
            [imageView addTarget:self action:@selector(imageViewAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    //偏移到应对的位置的视图上去
    scrollView.contentOffset = CGPointMake(0, height);
}


-(void)imageViewAction:(CLDisplayImageView *)sender
{
    
    CLNextViewController *nextViewController =[[CLNextViewController alloc] init];
    nextViewController.num = sender.tag-100;
    [self presentViewController:nextViewController animated:YES completion:nil];
    
}


@end
