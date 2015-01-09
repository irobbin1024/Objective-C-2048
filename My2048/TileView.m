//
//  TileView.m
//  My2048
//
//  Created by 赖隆斌 on 15/1/5.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import "TileView.h"

@interface TileView ()

@property (nonatomic, strong) UIColor * numberLabelTextColor;

@end

@implementation TileView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberLabel == nil) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
        label.font = [UIFont boldSystemFontOfSize:50.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.numberLabel = label;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tile.value];
    self.numberLabel.textColor = self.numberLabelTextColor;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

- (void)setTile:(Tile *)tile
{
    [_tile removeObserver:self forKeyPath:@"value"];
    
    _tile = tile;
    
    self.backgroundColor = [tile tileColor];
   
    if (_tile.value == 2 || _tile.value == 4) {
        self.numberLabelTextColor = [UIColor colorWithRed:119 / 255.0 green:110 / 255.0 blue:101 / 255.0 alpha:1.0];
    } else {
        self.numberLabelTextColor = [UIColor colorWithRed:249 / 255.0 green:246 / 255.0 blue:242 / 255.0 alpha:1.0];
    }
    
    [_tile addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc
{
    [self.tile removeObserver:self forKeyPath:@"value"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
     if([keyPath isEqualToString:@"value"])
     {
         Tile * tile = object;
//         self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)tile.value];
     }
}
@end
