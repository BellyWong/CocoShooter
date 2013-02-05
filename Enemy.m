//
//  Enemy.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "Enemy.h"

@implementation Enemy
{
    CGPoint vec;
}


-(void)setup
{
    int screenHeight = [[CCDirector sharedDirector] winSize].height;
    int screenWidth = [[CCDirector sharedDirector] winSize].width;
    self.sprite = [CCSprite spriteWithFile:@"enemy.png" rect:CGRectMake(0, 0, 50, 50)];
    int enemyOffset = self.sprite.contentSize.height;
    int randHeight = enemyOffset +  (arc4random() % (screenHeight - enemyOffset));
    self.sprite.position = ccp(screenWidth + arc4random() % 150,(arc4random() % 300) + 100);
    self.sprite.rotation = 45;
    [self addObserver:self forKeyPath:@"sprite.visible" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)move
{
//    vec = ccp(-1,0);
    self.sprite.position = ccpAdd(self.sprite.position, vec);

}
-(void)setVec:(CGPoint)point
{
    vec = point;
    
}
-(CGPoint) vec
{
    return  vec;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        [self.delegate removeObjectFromArray:(id)object];
        [self removeObserver:self forKeyPath:@"sprite.visible"];
}
-(id)init
{
    
    return self;
}

@end
