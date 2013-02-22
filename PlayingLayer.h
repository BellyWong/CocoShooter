//
//  PlayingLayer.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "CCActionGrid.h"
#import "cocos2d.h"
#import "GameOverLayer.h"
#import "Enemy.h"
#import "Constants.h"
#import "Ball.h"
#import "SimpleAudioEngine.h"
#import "ParticleManager.h"
#import "HelloWorldLayer.h"
#import "Helper.h"
#import "GameKitHelper.h"


@interface PlayingLayer : CCLayer

+(CCScene *) scene;
@property (nonatomic,assign) id  delegate;
-(void)onScoreSubmitted:(bool)success;





@end
