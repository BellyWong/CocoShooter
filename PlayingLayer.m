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
    float currentSpeed ;
    int comboLegnth;
    CCLabelTTF *scoreLabel;
    int currentScore;

}


+(CCScene *)scene
{
    
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayingLayer *layer = [PlayingLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    
    // preload sound
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"great.mp3"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];
	
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
    balls = [[NSMutableArray alloc] init];
    currentSpeed = -1;
    self.isTouchEnabled = YES;
    [self createEnemies];
    [self scheduleUpdate];
    scoreLabel = [CCLabelTTF labelWithString:@"Score:0pt" fontName:@"verdana" fontSize:25];
    scoreLabel.position = ccp([Constants screenWidth] - 80,[Constants screenHeight] - 40);
    [self addChild:scoreLabel];



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
        if ([self isCollidWithWall:enemy.sprite] == YES){
            enemy.sprite.visible = false;
        }
        
        // for production
//            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
        
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
                    ball.hasHitted = true;
                    enemy.sprite.visible = false;
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


-(void)speedUpOfEnemy
{
    currentSpeed -= 0.1;
    NSLog(@"currentSpeed is %f",currentSpeed);
}



-(void)updateScoreLabel:(int)num
{
    NSString *labelStr = [NSString stringWithFormat:@"Score:%ipt",num];
    
    
    [scoreLabel setString:labelStr];
    
}








@end
