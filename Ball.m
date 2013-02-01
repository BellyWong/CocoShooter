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
    CGPoint gravity;
    CCSprite *ball;
    float force;
    float friction;
    
}
-(void)setup
{
    
    gravity = ccp(0,-1);
    vec = ccp(0,1);
    friction = 0.9;
    self.sprite = [CCSprite spriteWithFile:@"ball.png" rect:CGRectMake(0, 0, 50, 50)];
    self.sprite.position = ccp(30,30);
    [self addObserver:self forKeyPath:@"sprite.visible" options:NSKeyValueObservingOptionNew context:nil];
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
    gravity.y -= 0.1;
    force  = 10;
    vec =  ccp(force*cosf(self.angle) * friction ,-1*force *sinf(self.angle));
    
    self.sprite.position = ccpAdd(self.sprite.position,ccpAdd(vec,gravity));
    
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.delegate removeObjectFromArray:(id)object];
    [self removeObserver:self forKeyPath:@"sprite.visible"];
}
@end
