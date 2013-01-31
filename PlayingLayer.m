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
    for(int i = 0 ;i < 3;i++){
        Enemy *enemy = [[Enemy alloc] createSprite];
        [self addChild:enemy];
        [enemies addObject:enemy];
    }
    
}
-(Boolean )isCollidWithWall:(CCSprite *)enemy
{
    if (enemy.position.x < enemy.contentSize.width/2){
        return YES;
    }
    return NO;
    
}
-(void)onEnter
{
    [super onEnter];
    self.isTouchEnabled = YES;
    [self createEnemies];
    [self scheduleUpdate];

    NSLog(@"onEnter");
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"location is %@",NSStringFromCGPoint(location));
    NSLog(@"ended");
    
    
    float realWidth =location.x ;
    float realHeight = location.y;
    
    
    float length = sqrtf((realWidth * realWidth ) + (realHeight * realHeight));
    
    
    
    
    float diffY = realWidth/length;
    float diffX = realHeight/length;
    NSLog(@"diffY is %f",diffY);
    
    float a = atan2f(diffY, diffX);
    
    // a - 1.5 が角度になる
    NSLog(@"location.y is %f",a - 1.5);
    
    
    
    
    
    

    
    

    
    

    
    
    
}



-(void)update:(ccTime *)time
{
    // moveEnemy
    CGPoint moveOffSet = ccp(-1,0);
    for (Enemy *enemy in enemies){
        if ([self isCollidWithWall:enemy] == YES){
//            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
        }else{
            [enemy move];
            
        }
    }
}



@end
