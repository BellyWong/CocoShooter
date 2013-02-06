//
//  Ball.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/31/13.
//
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface Ball : NSObject


@property(nonatomic,strong) CCSprite *sprite;
@property(nonatomic,assign) float angle;
@property (nonatomic,strong) id delegate;
@property  int hasHitted;
-(CCSprite *)createSprite;
-(void)move;
-(void)setup;
-(void)removeObjectFromArray:(id)object;
-(void)reset;

@end
