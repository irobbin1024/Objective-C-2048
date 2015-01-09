//
//  RoundButton.m
//  My2048
//
//  Created by 赖隆斌 on 15/1/3.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

@end
