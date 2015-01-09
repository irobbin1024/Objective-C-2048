//
//  Tile.h
//  My2048
//
//  Created by 赖隆斌 on 15/1/4.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlaygroundPosition.h"

@interface Tile : NSObject

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) PlaygroundPosition * position;

@property (nonatomic, assign) BOOL willDestroy;

- (UIColor *)tileColor;

@end
