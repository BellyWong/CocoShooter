//
//  GameKitHelper.h
//  CocoShooter
//
//  Created by HARADA SHINYA on 2/22/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import <GameKit/GameKit.h>


@interface GameKitHelper : NSObject<GKGameCenterControllerDelegate,GKLeaderboardViewControllerDelegate>

@property (nonatomic,strong) id delegate;


@property (nonatomic,strong) NSError *lastError;
+(id)shared;
-(void)authenticateLocalPlayer;
-(void)submitScore:(int)value category:(NSString *)category;

-(void)onScoreSubmitted:(bool)success;

-(void)showLeaderboard;

// playingLayerprotocol

@end
