//
//  ParticleManager.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 2/4/13.
//
//

#import "ParticleManager.h"


@implementation ParticleManager
{
}
static id particleManager;
+(id)shared
{
    if (!particleManager){
        particleManager = [[ParticleManager alloc] init];
    }
    return particleManager;
    
}
-(CCParticleSystem *)createStarAt:(CGPoint)pos
{
    self.emitter = [[CCParticleFlower alloc] initWithTotalParticles:5];
    self.emitter.position = ccp(pos.x,pos.y);
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
    self.emitter.lifeVar = 1;
    self.emitter.duration = 0.5;
    self.emitter.life = 3;
    self.emitter.speed = 100;
    self.emitter.speedVar = 0;
    self.emitter.emissionRate = 30;
    return self.emitter;
}



@end
