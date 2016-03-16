//
//  CLDisplayImageView.m
//  CLImageScrollView
//
//  Created by nil on 16/3/16.
//  Copyright © 2016年 岑磊. All rights reserved.
//

#import "CLDisplayImageView.h"

@implementation CLDisplayImageView

-(instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
    
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
    }
    
    return self;
}

@end