//
//  GameOverLayer.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "GameOverLayer.h"

@implementation GameOverLayer
{
    NSUserDefaults *ud;
}

+(CCScene *)scene
{
    
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}
-(void)onEnter
{
    [super onEnter];
    ud = [NSUserDefaults standardUserDefaults];
    [self addMenu];
    [self addBackground];


}
-(void)addBackground
{
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];

}
-(void)onBack
{
    NSLog(@"called back");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
}
-(void)addMenu
{
    
    CCLabelTTF *titleLabel  = [CCLabelTTF labelWithString:@"Back to Menu" fontName:@"Arial" fontSize:33];
    titleLabel.color = ccc3(255,0,0);
    CCLabelTTF *currentScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %@pt",[ud objectForKey:@"currentScore"]] fontName:@"Arial" fontSize:33];
//    CCLabelTTF *bestScoreLabel = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"Best: %@pt",[ud objectForKey:@"bestScore"]] fontName:@"Arial" fontSize:33];
    CCLabelTTF *viewScoreLabel = [CCLabelTTF labelWithString:@"View Score" fontName:@"Arial" fontSize:33];
    
//    CCMenuItemLabel *bestScoreItem = [CCMenuItemLabel itemWithLabel:bestScoreLabel];
    CCMenuItemLabel *currentScoreItem = [CCMenuItemLabel itemWithLabel:currentScoreLabel];
    
    CCMenuItemLabel *viewScoreItem = [CCMenuItemLabel itemWithLabel:viewScoreLabel block:^(id sender) {
        [[GameKitHelper shared] showLeaderboard];
    }];
    CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(onBack)];
    
    
    
    
//    CCMenu *menu = [CCMenu menuWithItems:backItem,currentScoreItem,bestScoreItem, nil];
    CCMenu *menu = [CCMenu menuWithItems:backItem,currentScoreItem,viewScoreItem, nil];
    [menu alignItemsVertically];
    [self addChild:menu];
    
}


@end
