//
//  PlayingLayer.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "PlayingLayer.h"
#define kPlayingLayer 10

@implementation PlayingLayer
{
    NSMutableArray *enemies;
    NSMutableArray *balls;
    float currentSpeed ;
    int comboLegnth;
    CCLabelTTF *scoreLabel;
    int currentScore;
    CCScene *scene;
    PlayingLayer *layer;
}



static CCScene *scene;
+(CCScene *)scene
{
    if (scene == nil){
        scene = [CCScene node];
        
        // 'layer' is an autorelease object.
        PlayingLayer *layer = [PlayingLayer node];
        layer.tag = kPlayingLayer;
        
        // add layer as a child to scene
        [scene addChild: layer];
    }else{
        return scene;
    }
    
	
    
    
	
	// return the scene
	return scene;
    
}
-(void)createEnemies
{
    enemies = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < 3;i++){
        Enemy *enemy = [[Enemy alloc] init];
        enemy.delegate = self;
        [enemy setVec:ccp(currentSpeed,0)];

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
    NSLog(@"secne is %@",[[self class] scene]);
    balls = [[NSMutableArray alloc] init];
    currentSpeed = -1;
    self.isTouchEnabled = YES;
    [self createEnemies];
    [self scheduleUpdate];
    scoreLabel = [CCLabelTTF labelWithString:@"Score:0pt" fontName:@"verdana" fontSize:25];
    scoreLabel.position = ccp([Constants screenWidth] - 80,[Constants screenHeight] - 40);
    [self addChild:scoreLabel];

    // preload sound
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"great.mp3"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];



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
    float a = atan2f(diffY, diffX) -  3.14/2;
    [[SimpleAudioEngine sharedEngine] playEffect:@"great.mp3"];
    
    Ball *ball = [[Ball alloc] init];
    ball.delegate = self;
    ball.angle = a;
    [ball setup];
    [self addChild:ball.sprite];
    [balls addObject:ball];
    
    
    
    
    
    
    
    

    
    

    
    

    
    
    
}

-(void)removeObjectFromArray:(id)object
{
    int idx = 0;
    for (int i = 0;i < [enemies count];i++){
        Enemy *e = [enemies objectAtIndex:i];
        if (e.sprite.visible == true){
            idx++;
        }
    }
    if (idx == 0){
        [self createEnemies];
    }
}


-(void)update:(ccTime *)time
{
    for (Enemy *enemy in enemies){
        // if enemy collid with wall , then go to game over layer.
        if ([self isCollidWithWall:enemy.sprite] == YES){
            enemy.sprite.visible = false;
            
            
            [self shakeScreen];
            
            // for production
    //            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
            
            
            
            
            
        }
        
        
            if ([enemy respondsToSelector:@selector(move)]){
                // set enemy's speed.
                
//                [enemy setVec:ccp(currentSpeed,0)];
                [enemy move];
            }
            for (Ball *ball in balls){
                if ([ball respondsToSelector:@selector(move)]){
                    [ball move];
                }
                if (ball.sprite.position.y< 0){
                    if (ball.sprite.visible != false){
                        ball.sprite.visible = false;
                    }
                }
                float distance = ccpDistance(ball.sprite.position, enemy.sprite.position);
                // check collision
                if (distance < ball.sprite.contentSize.width + enemy.sprite.contentSize.width - 50 && ball.sprite.visible == true && enemy.sprite.visible == true
                    ){
                    // ボールは貫通しない
                    ball.sprite.visible = false;
                    [self removeChild:ball.sprite cleanup:YES];
                    ball.hasHitted = true;
                    enemy.sprite.visible = false;
                    [self removeChild:enemy.sprite cleanup:YES];
                    currentScore += 1;
                    
                    [self updateScoreLabel:currentScore];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"hit.mp3"];
                    
                    [self speedUpOfEnemy];
                    CCParticleSystem *particleStar  = [[ParticleManager alloc] createStarAt:ball.sprite.position];
                    [self addChild:particleStar z:10];
                    
                    
                    
                    
                }
                
        
        }
    }
    
}
-(void)shakeScreen
{
    
    id action = [CCShaky3D actionWithRange:1 shakeZ:YES grid:ccg(10,30) duration:0.5];
    id reset = [CCCallBlock actionWithBlock:^{
        [[[self class] scene] getChildByTag:kPlayingLayer].grid = nil;
        
    }];
    [self runAction:[CCSequence actions:action,reset, nil]];
    
}


-(void)speedUpOfEnemy
{
    if (currentSpeed <= -5){
        currentSpeed = -0.01;
    }else{
        currentSpeed -= 0.1;
        
    }
}



-(void)updateScoreLabel:(int)num
{
    NSString *labelStr = [NSString stringWithFormat:@"Score:%ipt",num];
    
    
    [scoreLabel setString:labelStr];
    
}








@end
