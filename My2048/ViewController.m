//
//  ViewController.m
//  My2048
//
//  Created by 赖隆斌 on 15/1/3.
//  Copyright (c) 2015年 赖隆斌. All rights reserved.
//

#import "ViewController.h"
#import "Tile.h"
#import "TileView.h"
#import "RoundView.h"
#import "TileContainerView.h"

typedef enum {DirectionUP, DirectionDown, DirectionLeft, DirectionRight} Direction;

@interface ViewController () {
    CGPoint _gestureStartPoint;
}
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetInfoLabel;
@property (weak, nonatomic) IBOutlet RoundView *playgroundView;

@property (nonatomic, assign) long bestScore;
@property (nonatomic, assign) long score;

@property (nonatomic, strong) NSMutableArray * tiles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tiles = [NSMutableArray array];
    self.score = 0;
    
    [self addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"bestScore" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSNumber * bestScoreNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"bestScore"];
    if (bestScoreNumber) self.bestScore = [bestScoreNumber longValue]; else self.bestScore = 0;
    
    self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld", self.bestScore];
    
    [self addGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)startGameAction:(id)sender
{
    [self.tiles removeAllObjects];
    [self reloadPlayground];
    [self startGame];
    
    [self debug];
}

#pragma mark - Playground

- (void)startGame
{
    self.score = 0;
    self.targetLabel.text = @"2048";
    self.targetInfoLabel.text = @"Join the numbers and get to the 2048 tile!";
    
    [self cleanGameBoard];
    
//    [self productTileA];
//    [self productTileB];
//    [self productTileC];
    
//    for (int i = 0; i < 16; i++) {
//        [self productTilePointValue:i];
//    }
    
    [self productTileWithDelay:NO];
    [self productTileWithDelay:NO];
}

- (void)cleanGameBoard
{
    [self.tiles removeAllObjects];
}


- (void)productTileWithDelay:(BOOL)isDelay
{
    NSLog(@"产生新的tile");

    if (isDelay) {
        [self performSelector:@selector(productTile) withObject:self afterDelay:0.2];
    } else {
        [self productTile];
    }
    
    if ([self playgroundIsFull]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你输了，游戏结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)playgroundIsFull
{
    if (self.tiles.count >= 16) {
        return YES;
    } else {
        return NO;
    }
}

- (void)productTile
{
    NSArray * emptyPosition = [self emptyPlaygroundPosition];
    if (emptyPosition.count <= 0) {
        NSLog(@"----- > 没有更多的空格了");
        return;
    }
    NSInteger random = arc4random() % emptyPosition.count;
    PlaygroundPosition * position = emptyPosition[random];
    
    Tile * tile = [Tile new];
    tile.position = [position copy];
    
    NSInteger randomValue = arc4random() % 2;
    if (randomValue == 0) {
        tile.value = 2;
    } else if (randomValue == 1) {
        tile.value = 4;
    }
    
    [self.tiles addObject:tile];
    
    
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    TileView * tileView = [[TileView alloc]init];
    tileView.tile = tile;
    tileView.frame = tileContainerView.frame;
    
    tileContainerView.tileView = tileView;
    
    [self.playgroundView addSubview:tileView];
}

- (NSArray *)emptyPlaygroundPosition
{
    NSMutableArray * emptyPositions = [NSMutableArray arrayWithArray:[PlaygroundPosition playground]];
    NSMutableArray * willDele = [NSMutableArray array];
    
    [emptyPositions enumerateObjectsUsingBlock:^(PlaygroundPosition * emptyPosition, NSUInteger idx, BOOL *stop) {
        [self.tiles enumerateObjectsUsingBlock:^(Tile * tile, NSUInteger idx, BOOL *stop) {
            PlaygroundPosition * tilePosition = tile.position;
            if ([emptyPosition isEqual:tilePosition] && tile.willDestroy == NO) {
                [willDele addObject:emptyPosition];
//                [emptyPositions removeObject:emptyPosition];
            }
        }];
    }];
    
    [emptyPositions removeObjectsInArray:willDele];
    
    
    return emptyPositions;
}

- (TileContainerView *)tileContainerView:(Tile *)tile
{
    return [self tileContainerViewWithPlaygroundPosition:tile.position];
}

- (void)reloadPlayground
{
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            
            TileContainerView * containerView = [self tileContainerViewWithPlaygroundPosition:[PlaygroundPosition playgroundPositionWithRow:i col:j]];
            TileView * tileView = containerView.tileView;
            if (tileView) {
                [tileView removeFromSuperview];
                containerView.tileView = nil;
            }
        }
    }
}

- (TileContainerView *)tileContainerViewWithPlaygroundPosition:(PlaygroundPosition *)playgroundPosition
{
    NSInteger tag = (playgroundPosition.row + 1) * 10 + playgroundPosition.col + 1;
    return (TileContainerView *)[self.playgroundView viewWithTag:tag];
}



- (void)moveWithNextPositionBlock:(PlaygroundPosition *(^)(PlaygroundPosition * postion)) nextPositionBlock comparator:(NSComparisonResult(^)(id obj1, id obj2))comparator
{
    self.tiles =[NSMutableArray arrayWithArray:[self.tiles sortedArrayUsingComparator:comparator]];
    
    BOOL hasMoved = NO;
    
    for (int i = 0; i < self.tiles.count; i++) {
        Tile * obj = self.tiles[i];
        
        if (obj.willDestroy == YES) {
            continue;
        }
        
        Tile * targetTile = [self getTargetTileWithTile:obj NextPositionBlock:nextPositionBlock];
        PlaygroundPosition * targetPosition = [self getTargetPositionWithTile:obj NextPositionBlock:nextPositionBlock];
        
        if (targetTile) {
            [self mixTile:targetTile anotherTile:obj];
            
            hasMoved = YES;
        } else if (obj.position.row != targetPosition.row || obj.position.col != targetPosition.col){
            [self moveTile:obj toPlaygroundPosition:targetPosition complete:nil];
            
            hasMoved = YES;
        }
    }
    
    [self cleanWillDestoryTiles];
    
    if (hasMoved == YES) {
        [self productTileWithDelay:YES];
    }
}

- (void)cleanWillDestoryTiles
{
    NSMutableArray * objs = [NSMutableArray array];
    [self.tiles enumerateObjectsUsingBlock:^(Tile * obj, NSUInteger idx, BOOL *stop) {
        if (obj.willDestroy) {
            [objs addObject:obj];
        }
    }];
    
    [self.tiles removeObjectsInArray:objs];
}

- (PlaygroundPosition *)getTargetPositionWithTile:(Tile *)tile NextPositionBlock:(PlaygroundPosition *(^)(PlaygroundPosition * postion)) nextPositionBlock
{
    PlaygroundPosition * lastPosition = tile.position;
    PlaygroundPosition * nextPosition = nextPositionBlock(tile.position);
    
    if ([self overPlayground:nextPosition]) {
        return lastPosition;
    }
    
    while (YES) {
        TileView * tileView = [self tileContainerViewWithPlaygroundPosition:nextPosition].tileView;
        
        if (tileView == nil) {
            lastPosition = nextPosition;
        } else {
            return lastPosition;
        }
        
        PlaygroundPosition * fakeNextPosition = nextPositionBlock(nextPosition);
        
        if ([self overPlayground:fakeNextPosition]) {
            return nextPosition;
        }
        
        nextPosition = fakeNextPosition;
    }
}

- (Tile *)getTargetTileWithTile:(Tile *)tile NextPositionBlock:(PlaygroundPosition *(^)(PlaygroundPosition * postion)) nextPositionBlock
{
    PlaygroundPosition * nextPosition = nextPositionBlock(tile.position);
    
    while (YES) {
        Tile * targetTile = [self tileContainerViewWithPlaygroundPosition:nextPosition].tileView.tile;
        
        if (targetTile) {
            if (targetTile.value == tile.value) {
                return targetTile;
            } else {
                return nil;
            }
        }
        
        nextPosition = nextPositionBlock(nextPosition);
        
        if ([self overPlayground:nextPosition]) {
            return nil;
        }
    }
}

- (BOOL)overPlayground:(PlaygroundPosition *)position
{
    if (position.row < 0 || position.row > 3 || position.col < 0 || position.col > 3) {
        return YES;
    } else {
        return NO;
    }
}

- (void)mixTile:(Tile *)targetTile anotherTile:(Tile *)anotherTile
{
    if (targetTile == nil) {
        return;
    }
    
    NSInteger anotherTileValue = anotherTile.value;
    targetTile.value += anotherTileValue;
    
    self.score += targetTile.value;
    
    TileView * tileView = [self tileViewWithTile:anotherTile];
    TileView * targetTileView = [self tileViewWithTile:targetTile];
    
    anotherTile.willDestroy = YES;
    
    [self removeTileFromPlayground:anotherTile];
    
    [self pureMoveTileView:tileView toPlaygroundPosition:targetTile.position complete:^{
        
        [tileView removeFromSuperview];
        targetTileView.numberLabel.text = [NSString stringWithFormat:@"%ld", targetTile.value];
        
    }];
}

- (void)removeTileFromPlayground:(Tile *)tile
{
    TileContainerView * tileContainerView = [self tileContainerViewWithPlaygroundPosition:tile.position];
    tileContainerView.tileView = nil;
}

- (void)pureMoveTileView:(TileView *)tileView toPlaygroundPosition:(PlaygroundPosition *)playgroundPosition complete:(void(^)())complete
{
    TileContainerView * targetTileContainerView = [self tileContainerViewWithPlaygroundPosition:playgroundPosition];
    
    [UIView animateWithDuration:0.2 animations:^{
        tileView.frame = targetTileContainerView.frame;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
    [UIView commitAnimations];
}

- (void)moveTile:(Tile *)tile toPlaygroundPosition:(PlaygroundPosition *)playgroundPosition complete:(void(^)())complete
{
    if (playgroundPosition == nil) {
        return;
    }
    
    TileView * tileView = [self tileViewWithTile:tile];
    
    TileContainerView * originalTileContainerView = [self tileContainerViewWithPlaygroundPosition:tile.position];
    TileContainerView * targetTileContainerView = [self tileContainerViewWithPlaygroundPosition:playgroundPosition];
    
    originalTileContainerView.tileView = nil;
    targetTileContainerView.tileView = tileView;
    tile.position = playgroundPosition;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        tileView.frame = targetTileContainerView.frame;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
    
    [UIView commitAnimations];
}

- (TileView *)tileViewWithTile:(Tile *)tile
{
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    return tileContainerView.tileView;
}



#pragma mark - Touch
- (void)addGesture
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromUp:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromDown:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}



- (void)handleSwipeFromRight:(UIGestureRecognizer *)gesture
{
    [self moveWithNextPositionBlock:^PlaygroundPosition *(PlaygroundPosition *postion) {
        return [PlaygroundPosition playgroundPositionWithRow:postion.row col:postion.col + 1];
    } comparator:^NSComparisonResult(Tile * obj1, Tile * obj2) {
        
        if (obj1.position.col > obj2.position.col)
            return NSOrderedAscending;
        else if (obj1.position.col < obj2.position.col)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    [self debug];
    
}

- (void)handleSwipeFromLeft:(UIGestureRecognizer *)gesture
{
    [self moveWithNextPositionBlock:^PlaygroundPosition *(PlaygroundPosition *postion) {
        
        return [PlaygroundPosition playgroundPositionWithRow:postion.row col:postion.col - 1];
        
    } comparator:^NSComparisonResult(Tile * obj1, Tile * obj2) {
        
        if (obj1.position.col < obj2.position.col)
            return NSOrderedAscending;
        else if (obj1.position.col > obj2.position.col)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    [self debug];
    
}

- (void)handleSwipeFromUp:(UIGestureRecognizer *)gesture
{
    [self moveWithNextPositionBlock:^PlaygroundPosition *(PlaygroundPosition *postion) {
        return [PlaygroundPosition playgroundPositionWithRow:postion.row - 1 col:postion.col];
    } comparator:^NSComparisonResult(Tile * obj1, Tile * obj2) {
        
        if (obj1.position.row < obj2.position.row)
            return NSOrderedAscending;
        else if (obj1.position.row > obj2.position.row)
            return NSOrderedDescending;
        else
            return NSOrderedSame;

    }];
    
    [self debug];
    
}

- (void)handleSwipeFromDown:(UIGestureRecognizer *)gesture
{
    [self moveWithNextPositionBlock:^PlaygroundPosition *(PlaygroundPosition *postion) {
        return [PlaygroundPosition playgroundPositionWithRow:postion.row + 1 col:postion.col];
    } comparator:^NSComparisonResult(Tile * obj1, Tile * obj2) {
        if (obj1.position.row > obj2.position.row)
            return NSOrderedAscending;
        else if (obj1.position.row < obj2.position.row)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    [self debug];
    
}


#pragma mark - Debug
- (void)debug
{
    printf("--------------------------->tiles count %lu \n", (unsigned long)self.tiles.count);
    int tileMap[4][4] = {0};
    int tileViewMap[4][4] = {0};
    
    for (int i = 0; i < self.tiles.count; i++) {
        Tile * obj = self.tiles[i];
        tileMap[obj.position.row][obj.position.col] = 1;
    }
    
    
    for (int i = 0; i < 4; i++) {
        printf("\n");
        for (int j = 0; j < 4; j++) {
            printf("%d\t", tileMap[i][j]);
        }
    }
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            TileView * tileView = [self tileContainerViewWithPlaygroundPosition:[PlaygroundPosition playgroundPositionWithRow:i col:j]].tileView;
            if (tileView) {
                tileViewMap[i][j] = 8;
            }
        }
    }
    
    for (int i = 0; i < 4; i++) {
        printf("\n");
        for (int j = 0; j < 4; j++) {
            printf("%d\t", tileViewMap[i][j]);
        }
    }
}


- (void)productTilePointValue:(NSInteger)value
{
    NSArray * emptyPosition = [self emptyPlaygroundPosition];
    if (emptyPosition.count <= 0) {
        NSLog(@"----- > 没有更多的空格了");
        return;
    }
    NSInteger random = arc4random() % emptyPosition.count;
    PlaygroundPosition * position = emptyPosition[random];
    
    Tile * tile = [Tile new];
    tile.position = [position copy];
    tile.value = value;
    
    
    [self.tiles addObject:tile];
    
    
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    TileView * tileView = [[TileView alloc]init];
    tileView.tile = tile;
    tileView.frame = tileContainerView.frame;
    
    tileContainerView.tileView = tileView;
    
    [self.playgroundView addSubview:tileView];
    
    
    if ([self playgroundIsFull]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"游戏结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)productTileA
{
    Tile * tile = [Tile new];
    tile.position = [PlaygroundPosition new];
    tile.position.row = 2;
    tile.position.col = 1;
    tile.value = 2;
    
    [self.tiles addObject:tile];
    
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    TileView * tileView = [[TileView alloc]init];
    tileView.tile = tile;
    tileView.frame = tileContainerView.frame;
    
    tileContainerView.tileView = tileView;
    
    [self.playgroundView addSubview:tileView];
}

- (void)productTileB
{
    Tile * tile = [Tile new];
    tile.position = [PlaygroundPosition new];
    tile.position.row = 2;
    tile.position.col = 2;
    tile.value = 2;
    
    [self.tiles addObject:tile];
    
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    TileView * tileView = [[TileView alloc]init];
    tileView.tile = tile;
    tileView.frame = tileContainerView.frame;
    
    tileContainerView.tileView = tileView;
    
    [self.playgroundView addSubview:tileView];
}

- (void)productTileC
{
    Tile * tile = [Tile new];
    tile.position = [PlaygroundPosition new];
    tile.position.row = 2;
    tile.position.col = 3;
    tile.value = 2;
    
    [self.tiles addObject:tile];
    
    TileContainerView * tileContainerView = [self tileContainerView:tile];
    TileView * tileView = [[TileView alloc]init];
    tileView.tile = tile;
    tileView.frame = tileContainerView.frame;
    
    tileContainerView.tileView = tileView;
    
    [self.playgroundView addSubview:tileView];
}

#pragma mark Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"score"]) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];
        
        if (self.score == 2048) {
            [[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"恭喜，你赢了" delegate:nil cancelButtonTitle:@"继续游戏" otherButtonTitles: nil]show];
        }
        
        if (self.score % 2048 == 0) {
            self.targetLabel.text = [NSString stringWithFormat:@"%ld", self.score * 2];
            self.targetInfoLabel.text = [NSString stringWithFormat:@"Join the numbers and get to the %@ tile!", self.targetLabel.text];
        }
        
        if (self.score > self.bestScore) {
            self.bestScore = self.score;
            NSNumber * bestScoreNumber = [NSNumber numberWithLong:self.bestScore];
            [[NSUserDefaults standardUserDefaults] setObject:bestScoreNumber forKey:@"bestScore"];
        }
    } else if ([keyPath isEqualToString:@"bestScore"]) {
        self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld", self.bestScore];
    }
}

@end
