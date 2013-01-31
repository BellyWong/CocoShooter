//
//  Ball.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/31/13.
//
//

#import "Ball.h"

@implementation Ball
{
    CGPoint vec;
    CCSprite *ball;
}
-(void)setup
{
    
    vec = ccp(0,0);
    int screenHeight = [[CCDirector sharedDirector] winSize].height;
    int screenWidth = [[CCDirector sharedDirector] winSize].width;
    self.sprite = [CCSprite spriteWithFile:@"ball.png" rect:CGRectMake(0, 0, 50, 50)];
    self.sprite.position = ccp(30,30);
    
    
}

-(id)init
{
    
    return self;
}
-(void)fire
{
    
}
-(void)move
{
    NSLog(@"moved");
    
//    X軸方向の移動量 = cos (現在向いている方向) × 進行速度
//    Y軸方向の移動量　= sin (現在向いている方向) × 進行速度
    
}

@end
