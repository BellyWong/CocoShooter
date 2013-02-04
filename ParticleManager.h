//
//  ParticleManager.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParticleManager : NSObject
@property(nonatomic,strong)     CCParticleSystem *emitter;
+(id)shared;
-(CCParticleSystem *)createStarAt:(CGPoint)pos;

@end
