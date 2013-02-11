//
//  GameOverLayer.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "GameOverLayer.h"

@implementation GameOverLayer

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
    [self addMenu];

}
-(void)onBack
{
    NSLog(@"called back");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
}
-(void)addMenu
{
    
    CCLabelTTF *titleLabel  = [CCLabelTTF labelWithString:@"Back to Menu" fontName:@"Arial" fontSize:33];
    
    
    CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:titleLabel target:self selector:@selector(onBack)];
    
    
    CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
    [self addChild:menu];
    
}

@end
