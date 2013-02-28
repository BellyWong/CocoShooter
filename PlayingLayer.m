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
    scene = [CCScene node];
    PlayingLayer *layer = [PlayingLayer node];
    layer.tag = kPlayingLayer;
    [scene addChild: layer];
    return scene;
    
}


-(void)createEnemies
{
    enemies = [[NSMutableArray alloc] init];
    for(int i = 0 ;i < 3;i++){
        Enemy *enemy = [[Enemy alloc] init];
        enemy.visible = true;
        enemy.position = ccp(100,100);
        [enemy setVec:ccp(currentSpeed,0)];
        [enemy setup];
       [self addChild:enemy.sprite];
        [enemies addObject:(Enemy *)enemy];
    }
    
}
-(Boolean )isCollidWithWall:(CCSprite *)enemy
{
    
    // -10 は微調整
    if (enemy.position.x < enemy.contentSize.width/2 -10    && enemy.visible == YES){
        return YES;
    }
    return NO;
    
}
-(void)addBackground
{
    CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
    bg.anchorPoint = ccp(0,0);
    [self addChild:bg z:-1];
    
}
-(void)onEnter
{
    [super onEnter];
    GameKitHelper *gh = [GameKitHelper shared];
    gh.delegate = self;
    
    [[Helper alloc] removeAdmobOn:[CCDirector sharedDirector].parentViewController];
    
    [self addBackground];
    balls = [[NSMutableArray alloc] init];
    currentSpeed = -1;
    self.isTouchEnabled = YES;
    [self createEnemies];
    [self scheduleUpdate];
    scoreLabel = [CCLabelTTF labelWithString:@"Score:0pt" fontName:@"Marker Felt" fontSize:25];
    scoreLabel.position = ccp([Constants screenWidth] - 80,[Constants screenHeight] - 80);
    scoreLabel.color = ccc3(255, 10, 0);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *item2Str = [NSString stringWithFormat:@"Best: %@",[ud objectForKey:@"bestScore"]];
    
    CCLabelTTF *bestLabel = [CCLabelTTF labelWithString:item2Str fontName:@"Marker Felt" fontSize:22];
    bestLabel.position = ccp([Constants screenWidth] -80,[Constants screenHeight]  - 120);
    [self addChild:bestLabel z:-1];
    [self addChild:scoreLabel];
    [self addBackMenu];

    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"great.mp3"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3"];



}
-(void)addBackMenu
{
//    CCMenuItem
    
    CCLabelTTF *titleLabel  = [CCLabelTTF labelWithString:@"Back" fontName:@"Marker Felt" fontSize:23];
    
    
    CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(onBack:)];
    
    CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
    menu.position = ccp(50,[Constants screenHeight] - 40 - 50);

    [self addChild:menu];
    
}

-(void)onBack:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];

    
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



-(void)update:(ccTime *)time
{
    
    
    
    for (Enemy *enemy in enemies){
        // if enemy collid with wall , then go to game over layer.
        if ([self isCollidWithWall:enemy.sprite] == YES){
            
            [self shakeScreen];
            return;
            
            // for production
            [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene
                                                       ]];
            
        }
        
    
            [enemy setVec:ccp(currentSpeed,0)];
            [enemy move];
        
        
        
            for (Ball *ball in balls){
                
                [ball move];
                if (ball.sprite.position.y< 0){
                    if (ball.sprite.visible != false){
                        ball.sprite.visible = false;
                    }
                }
                float distance = ccpDistance(ball.sprite.position, enemy.sprite.position);
                
                
                
                // check collision
                if (distance < ball.sprite.contentSize.width + enemy.sprite.contentSize.width && ball.sprite.visible == true && enemy.sprite.visible == true
                    ){
                    // ボールは貫通しない
                    ball.sprite.visible = false;
                    [ball.sprite setAnchorPoint:CGPointMake(0.5, 0.5)];
                    ball.hasHitted = true;
                    
                    
                    
                    currentSpeed -= 0.1;
                    enemy.sprite.visible = false;
                    [enemy reset:currentSpeed];
                    currentScore += 1;
                    
                    [self updateScoreLabel:currentScore];
                    [[SimpleAudioEngine sharedEngine] playEffect:@"hit.mp3"];
                    
                    CCParticleSystem *particleStar  = [[ParticleManager alloc] createStarAt:ball.sprite.position];
                    
                    [self addChild:particleStar z:10];
                    
                    
                }
        
        }
    }
    
}
-(void)shakeScreen
{
    
    
    [self unscheduleUpdate];
    
    [[GameKitHelper shared] submitScore:currentScore category:@"com.nobinobiru.shooting"];
    id action = [CCShaky3D actionWithRange:3 shakeZ:YES grid:ccg(10,30) duration:1];
    id reset = [CCCallBlock actionWithBlock:^{
        [[[self class] scene] getChildByTag:kPlayingLayer].grid = nil;

        
    }];
    id onEnd = [CCCallBlock actionWithBlock:^(void) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[GameOverLayer scene]];
        [[CCDirector sharedDirector] removeFromParentViewController];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([ud objectForKey:@"bestScore"] ==nil){
            [ud setObject:[NSString stringWithFormat:@"%i",currentScore] forKey:@"bestScore"];
        }
        
        if (currentScore > [[ud objectForKey:@"bestScore"] intValue]){
            [ud setObject:[NSString stringWithFormat:@"%i",currentScore] forKey:@"bestScore"];
        }
        [ud setObject:[NSString stringWithFormat:@"%i",currentScore]  forKey:@"currentScore"];
        
        
    }];
    
    
    
    [self runAction:[CCSequence actions:action,reset,onEnd, nil]];
    
}





-(void)updateScoreLabel:(int)num
{
    NSString *labelStr = [NSString stringWithFormat:@"Score:%ipt",num];
    [scoreLabel setString:labelStr];
    
}


-(void)onScoreSubmitted:(bool)success
{
    
    NSLog(@"subbmmitte");
    
}

-(void)onExit
{
    [super onExit];

}







@end
