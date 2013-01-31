//
//  Ball.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/31/13.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface Ball : CCSprite


@property(nonatomic,strong) CCSprite *sprite;
@property(nonatomic,assign) float angle;
-(CCSprite *)createSprite;
-(void)move;
-(void)setup;
@end
