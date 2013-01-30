//
//  Enemy.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "Enemy.h"

@implementation Enemy

+(id)createSprite
{
    
    int screenHeight = [[CCDirector sharedDirector] winSize].height;
    int screenWidth = [[CCDirector sharedDirector] winSize].width;
     CCSprite * e = [[self class] spriteWithFile:@"enemy.png" rect:CGRectMake(0, 0, 50, 50)];
        int enemyOffset = e.contentSize.height;
        int randHeight = enemyOffset +  (arc4random() % (screenHeight - enemyOffset));
        
        e.position = ccp(screenWidth + arc4random() % 150,randHeight);
        e.rotation = 45;
    
    return e;
}

-(id)init
{
    
    return self;
}

@end
