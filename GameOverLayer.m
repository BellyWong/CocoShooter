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
    NSLog(@"called  game over");
}

@end
