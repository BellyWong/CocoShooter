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

@interface Enemy : NSObject

@property(nonatomic,strong) CCSprite *sprite;
@property(nonatomic,strong) id delegate;

-(id)createSprite;

-(void)removeObjectFromArray:(id)object;

-(void)setup;
-(void)move;

@end
