//
//  HelloWorldLayer.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "PlayingLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label

	

	}
	return self;
}

-(void)addMenu
{
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
        
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"scene_ended" object:nil];
        
        [[CCDirector sharedDirector] replaceScene:[PlayingLayer scene
                                                ]];
        
        
    }];
    menuItem1.color = ccc3(200,0,0);
    NSString *item2Str = [NSString stringWithFormat:@"Best: %@",[ud objectForKey:@"bestScore"]];
    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:item2Str];
//    CCLabelTTF *bestScoreLabel = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"Best: %@pt",[ud objectForKey:@"bestScore"]] fontName:@"Arial" fontSize:33];


    CCMenu *titleMenu = [CCMenu menuWithItems:menuItem1,menuItem2, nil];
    [titleMenu alignItemsVertically];
    [self addChild:titleMenu];
    
}
-(void)onExit
{
    [super onExit];
    
    
}
-(void)onEnter
{
    [super onEnter];
    [self removeAllChildrenWithCleanup:YES];
    
    [self addMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(mySceneEnd:) name:@"scene_ended" object:nil];
    
}
- (void) mySceneEnd:(NSNotification *)notif {
    if ([CCDirector sharedDirector].runningScene){
        [[CCDirector sharedDirector] end];
    }
    NSLog(@"called end");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
