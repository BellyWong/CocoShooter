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
    NSMutableArray *balls;
}


+(CCScene *)scene
{
    
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayingLayer *layer = [PlayingLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}
-(void)createEnemies
{
    enemies = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < 3;i++){
        Enemy *enemy = [[Enemy alloc] init];
        [enemy setup];
        NSLog(@"enemy.sprite is %@",enemy.sprite);
        [self addChild:enemy.sprite];
        [enemies addObject:(Enemy *)enemy];
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
    balls = [[NSMutableArray alloc] init];
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
    
    
    float realWidth =location.x ;
    float realHeight = location.y;
    
    
    float length = sqrtf((realWidth * realWidth ) + (realHeight * realHeight));
    
    
    float diffY = realWidth/length;
    float diffX = realHeight/length;
    
    
    // a - 1.5 が角度になる
    float a = atan2f(diffY, diffX) -  1.5;
    
    Ball *ball = [[Ball alloc] init];
    ball.delegate = self;
    ball.angle = a;
    [ball setup];
    [self addChild:ball.sprite];
    [balls addObject:ball];
    
    
    
    
    
    
    
    

    
    

    
    

    
    
    
}

-(void)removeBallFromArrayWith:(id)object
{
    if ([object isKindOfClass:[Ball class]] && [object respondsToSelector:@selector(removeObject:)]){
        
        [balls removeObject:object];
    }
}


-(void)update:(ccTime *)time
{
    for (Enemy *enemy in enemies){
        if ([self isCollidWithWall:enemy.sprite] == YES){
            enemy.sprite.visible = false;
        }
//            enemy.sprite.visible = false;
//            [enemies removeObject:enemy];
        // for debug
//            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
            if ([enemy respondsToSelector:@selector(move)]){
                [enemy move];
            }
            for (Ball *ball in balls){
                if ([ball respondsToSelector:@selector(move)]){
                    [ball move];
                }
                if (ball.sprite.position.y< 0){
                    ball.sprite.visible = false;
                }
                float distance = ccpDistance(ball.sprite.position, enemy.sprite.position);
                if (distance < ball.sprite.contentSize.width + enemy.sprite.contentSize.width - 50 && ball.sprite.visible == true && enemy.sprite.visible == true
                    ){
                    ball.sprite.visible = false;
                    enemy.sprite.visible = false;
                }else{
                }
//                NSLog(@"%@",NSStringFromCGPointccpDistance(ball.position, enemy.position));
            
        }
    }
    
}



@end
