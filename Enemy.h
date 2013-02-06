//
//  Enemy.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "Constants.h"

@interface Enemy : CCNode

@property(nonatomic,strong) CCSprite *sprite;
@property(nonatomic,strong) id delegate;
@property float currentSpeed;

-(id)createSprite;
-(void)setVec:(CGPoint)point;
-(CGPoint )vec;

-(void)removeObjectFromArray:(id)object;
-(void)reset:(float)speed;

-(void)setup;
-(void)move;

@end
