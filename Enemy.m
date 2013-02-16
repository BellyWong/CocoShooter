//
//  Enemy.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "Enemy.h"

@implementation Enemy
{
    CGPoint vec;
    int offY;
    int flag;
}


-(void)setup
{
    flag =1;
    int screenWidth = [[CCDirector sharedDirector] winSize].width;
    self.sprite = [CCSprite spriteWithFile:@"enemy.png" rect:CGRectMake(0, 0, 50, 50)];
    self.sprite = [[CCSprite alloc] init];
    self.sprite.position = ccp(screenWidth + arc4random() % 150,(arc4random() % 300) + 100);
    self.sprite.rotation = 45;
    self.currentSpeed = -1;

    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"birds.plist"];
    
    

    
    NSMutableArray *flyingFrames = [NSMutableArray array];
    for(int i = 1; i < 4;i++){
        NSString *imagePath = [NSString stringWithFormat:@"bird%d.png",i];
        
        [flyingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imagePath]];
    }
    CCAnimation *flyingAnimation = [CCAnimation animationWithSpriteFrames:flyingFrames delay:0.1f];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:flyingAnimation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
//    self.sprite.scale =0.3;
    
    
    [self.sprite runAction:repeat];
    
    
    
    
}
-(void)onAddedTexture:(id)sender
{
    NSLog(@"received");
}
-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}


-(void)move
{
    
    offY += 1;
    if (offY >  10 ){
        flag *= -1;
        offY = 1;
    }
    float force = offY * flag/10;
    vec = ccp(self.currentSpeed ,force) ;
    self.sprite.position = ccpAdd(self.sprite.position, vec);

}


// リセットした時にスピードを上げる
- (void)reset:(float)speed
{
    self.currentSpeed = speed;
    self.sprite.visible = true;
    self.sprite.position = ccp(320 + arc4random() % 200,100 + arc4random() % 300);

}

-(void)setVec:(CGPoint)point
{
    vec = point;
    
}
-(CGPoint) vec
{
    return  vec;
}

-(id)init
{
    
    return self;
}

@end
