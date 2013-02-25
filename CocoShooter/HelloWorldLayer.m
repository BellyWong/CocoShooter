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
-(void)addBackground
{
    CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
    bg.anchorPoint = ccp(0,0);
    [self addChild:bg z:-1];
    
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
    if ([ud objectForKey:@"bestScore"] == nil){
        [ud setObject:@"0" forKey:@"bestScore"];
    }
    
    CCMenuItemFont *menuItem1 = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
        
        [[CCDirector sharedDirector] replaceScene:[PlayingLayer scene
                                                ]];
        
    }];
    
    

    
    CCMenuItemFont *menuItem3 = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
        [[GameKitHelper shared] showLeaderboard];
    }];
    [menuItem3 setColor:ccc3(200, 30, 30)];

    menuItem1.color = ccc3(200,0,0);
//    NSString *item2Str = [NSString stringWithFormat:@"Best: %@",[ud objectForKey:@"bestScore"]];
//    CCMenuItemFont *menuItem2 = [CCMenuItemFont itemWithString:item2Str];


//    CCMenu *titleMenu = [CCMenu menuWithItems:menuItem1,menuItem2,menuItem3, nil];
    CCMenu *titleMenu = [CCMenu menuWithItems:menuItem1,menuItem3, nil];
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
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [self addBackground];
    
    [self addTitle];
    [self addMenu];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(mySceneEnd:) name:@"scene_ended" object:nil];
    
    
    
    [[GameKitHelper shared] authenticateLocalPlayer];
    
    
    
    
    
    
}
-(void)showReader
{
    GKLeaderboardViewController *lvc = [[GKLeaderboardViewController alloc] init];
    if (lvc != nil){
        lvc.leaderboardDelegate = self;
        [[CCDirector sharedDirector].parentViewController.view addSubview:lvc.view];
    }
    
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    NSLog(@"called done");
    
    [[CCDirector sharedDirector].parentViewController dismissViewControllerAnimated:YES
     completion:^{
         NSLog(@"finish");
     }];
}




-(void)addTitle
{
    CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Shooting Bird" fontName:@"Arial" fontSize:50];
    
//    CCLabelTTF *titleLabel  = [CCLabelTTF labelWithString:@"Back to Menu" fontName:@"Arial" fontSize:33];
    titleLabel.position = ccp([Constants screenWidth]/2,[Constants screenHeight] * 0.8);
    titleLabel.color = ccc3(51,0,0);
    [self addChild:titleLabel z:10];
    
    [[Helper alloc] addAdmobOn:[CCDirector sharedDirector].parentViewController];
    
}
- (void) mySceneEnd:(NSNotification *)sender {
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
