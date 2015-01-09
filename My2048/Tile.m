//
//  Tile.m
//  My2048
//
//  Created by 赖隆斌 on 15/1/4.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (UIColor *)tileColor
{
    switch (self.value) {
        case 2:
            return [UIColor colorWithRed:238 / 255.0 green:228 / 255.0 blue:219 / 255.0 alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 8:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 16:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 32:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 64:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 128:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 256:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 512:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 1024:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        case 2048:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
        default:
            break;
    }
    
    return [UIColor colorWithRed:238 / 255.0 green:228 / 255.0 blue:219 / 255.0 alpha:1.0];
}

@end
