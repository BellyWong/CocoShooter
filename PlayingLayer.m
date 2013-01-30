//
//  PlayingLayer.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "PlayingLayer.h"

@implementation PlayingLayer
{
    NSMutableArray *enemies;
}


+(CCScene *)scene
{
    
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayingLayer *layer = [PlayingLayer node];
    NSLog(@"called");
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}
-(void)createEnemies
{
    enemies = [[NSMutableArray alloc] init];
//    int screenHeight = [[CCDirector sharedDirector] winSize].height;
//    int screenWidth = [[CCDirector sharedDirector] winSize].width;
    // create 3 enemies.
    for(int i = 0 ;i < 3;i++){
        Enemy *enemy = [Enemy createSprite];
        [self addChild:enemy];
        [enemies addObject:enemy];
    }
    
}
-(Boolean )isCollidWithWall:(CCSprite *)enemy
{
    if (enemy.position.x < enemy.contentSize.width/2){
        NSLog(@"game over");
        return YES;
    }
    return NO;
    
}
-(void)onEnter
{
    [super onEnter];
    [self createEnemies];
    [self scheduleUpdate];

    NSLog(@"onEnter");
}



-(void)update:(ccTime *)time
{
    // moveEnemy
    CGPoint moveOffSet = ccp(-1,0);
    for (CCSprite *enemy in enemies){
        if ([self isCollidWithWall:enemy] == YES){
            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
        }else{
            enemy.position = ccpAdd(enemy.position, moveOffSet);
            
        }
    }
}



@end
