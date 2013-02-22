//
//  GameKitHelper.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 2/22/13.
//
//

#import "GameKitHelper.h"


@implementation GameKitHelper
{
    BOOL _gameCenterFeaturesEnabled;
}

+(id)shared
{
    static GameKitHelper *gh;
    if (!gh){
        gh = [[GameKitHelper alloc] init];
    }
    return gh;
    
}

-(void)authenticateLocalPlayer
{
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    localPlayer.authenticateHandler = ^(UIViewController *vc,NSError *err){
        [self setLastError:err];
        if ([CCDirector sharedDirector].isPaused){
            [[CCDirector sharedDirector] resume];
        }
        if (localPlayer.authenticated){
            _gameCenterFeaturesEnabled = YES;
            
            // get localplayer's score.
            NSArray *arr = @[localPlayer.playerID];
            GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.category = @"com.nobinobiru.shooting";
            [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                NSString *s = [NSString stringWithFormat:@"%lld",board.localPlayerScore.value];
                [ud setObject:[NSString stringWithFormat:@"%@",s] forKey:@"bestScore"];
                NSLog(@"scores is %@",scores);
                
                
            }];
            
        }else if (vc){
            [[CCDirector sharedDirector] pause];
            [self presentViewController:vc];
        }
        
    };
}

-(void)setLastError:(NSError *)lastError
{
    _lastError = [lastError copy];
    if (_lastError){
        NSLog(@"GamekitHelper error :%@",[_lastError userInfo].description);
    }
}
-(UIViewController *)getRootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
    
}

-(void)presentViewController:(UIViewController *)vc
{
    UIViewController *rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:NO completion:^{
        
    }];
}


-(void)submitScore:(int)value category:(NSString *)category
{
    if (!_gameCenterFeaturesEnabled){
        NSLog(@"failed");
        return;
    }
    
    GKScore *gkScore = [[GKScore alloc] initWithCategory:category];
    gkScore.value = value;

    [gkScore reportScoreWithCompletionHandler:^(NSError *error) {
        [self setLastError:error];
        BOOL success = (error == nil);
       [self.delegate onScoreSubmitted:success];
        
    }];
}


// Leaderboards
-(void) showLeaderboard
{
    
    GKLeaderboardViewController* leaderboardVC = [[GKLeaderboardViewController alloc] init] ;
    if (leaderboardVC != nil)
    {
        leaderboardVC.leaderboardDelegate = self;
        [self presentViewController:leaderboardVC];
        

    }
    
    
    
    
    
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}
-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
