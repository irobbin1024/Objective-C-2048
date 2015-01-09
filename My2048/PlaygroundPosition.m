//
//  PlaygroundPosition.m
//  My2048
//
//  Created by 赖隆斌 on 15/1/4.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import "PlaygroundPosition.h"

@implementation PlaygroundPosition

+ (instancetype)playgroundPositionWithRow:(NSInteger)row col:(NSInteger)col
{
    PlaygroundPosition * playgroundPosition = [[PlaygroundPosition alloc]init];
    playgroundPosition.row = row;
    playgroundPosition.col = col;
    
    return playgroundPosition;

}
- (BOOL)isEqual:(PlaygroundPosition *)object
{
    if (self.row == object.row && self.col == object.col) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)playground
{
    NSMutableArray * playground = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            int row = i, col = j;
            
            PlaygroundPosition * position = [PlaygroundPosition new];
            position.row = row;
            position.col = col;
            
            [playground addObject:position];
        }
    }
    
    return playground;
}

- (id)copyWithZone:(NSZone *)zone
{
    PlaygroundPosition * copyPlaygroundPosition = [PlaygroundPosition new];
    copyPlaygroundPosition.row = self.row;
    copyPlaygroundPosition.col = self.col;
    
    return copyPlaygroundPosition;
}
@end
