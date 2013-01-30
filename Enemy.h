//
//  Enemy.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface Enemy : CCSprite

@property(nonatomic,strong) CCSprite *e;
+(id)createSprite;


@end
