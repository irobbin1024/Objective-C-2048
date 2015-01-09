//
//  TileView.h
//  My2048
//
//  Created by 赖隆斌 on 15/1/5.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tile.h"

@interface TileView : UIView
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) Tile * tile;


@end
