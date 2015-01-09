//
//  PlaygroundPosition.h
//  My2048
//
//  Created by 赖隆斌 on 15/1/4.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaygroundPosition : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger col;

+ (instancetype)playgroundPositionWithRow:(NSInteger)row col:(NSInteger)col;
+ (NSArray *)playground;

@end
