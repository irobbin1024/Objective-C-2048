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
            break;
        case 8:
            return [UIColor colorWithRed:242 / 255.0 green:177 / 255.0 blue:121 / 255.0 alpha:1.0];
            break;
        case 16:
            return [UIColor colorWithRed:245 / 255.0 green:149 / 255.0 blue:99 / 255.0 alpha:1.0];
            break;
        case 32:
            return [UIColor colorWithRed:246 / 255.0 green:124 / 255.0 blue:95 / 255.0 alpha:1.0];
            break;
        case 64:
            return [UIColor colorWithRed:246 / 255.0 green:94 / 255.0 blue:59 / 255.0 alpha:1.0];
            break;
        case 128:
            return [UIColor colorWithRed:237 / 255.0 green:207 / 255.0 blue:114 / 255.0 alpha:1.0];
            break;
        case 256:
            return [UIColor colorWithRed:237 / 255.0 green:204 / 255.0 blue:97 / 255.0 alpha:1.0];
            break;
        case 512:
            return [UIColor colorWithRed:237 / 255.0 green:200 / 255.0 blue:80 / 255.0 alpha:1.0];
            break;
        case 1024:
            return [UIColor colorWithRed:237 / 255.0 green:216 / 255.0 blue:62 / 255.0 alpha:1.0];
            break;
        case 2048:
            return [UIColor colorWithRed:237 / 255.0 green:224 / 255.0 blue:201 / 255.0 alpha:1.0];
            break;
        case 4096:
            return [UIColor blackColor];
            break;
        default:
            break;
    }
    
    return [UIColor colorWithRed:238 / 255.0 green:228 / 255.0 blue:219 / 255.0 alpha:1.0];
}

@end
