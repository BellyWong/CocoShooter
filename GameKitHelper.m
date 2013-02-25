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
            GKLeaderboard *board = [[GKLeaderboard alloc] init];
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.playerScope = GKLeaderboardTimeScopeToday;
            board.category = @"com.nobinobiru.shooting";
            board.range = NSMakeRange(1, 3);
            [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                NSString *s = [NSString stringWithFormat:@"%lld",board.localPlayerScore.value];
                [ud setObject:[NSString stringWithFormat:@"%@",s] forKey:@"bestScore"];
                if (scores){
                    NSLog(@"score is %@",scores);
                }
                
                
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
    [gkScore setCategory:@"com.nobinobiru.shooting"];

    [gkScore reportScoreWithCompletionHandler:^(NSError *error) {
        [self setLastError:error];
        BOOL success = (error == nil);
        
        NSLog(@"rank is %i",gkScore.rank);
        [self.delegate onScoreSubmitted:success];
        
    }];
}


// Leaderboards
-(void) showLeaderboard
{
    
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController
                                                         alloc] init];
    if (gameCenterController != nil){
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
        gameCenterController.leaderboardCategory = @"com.nobinobiru.shooting";
       [self presentViewController:gameCenterController];
        [self retrieveTopTenScores];
    }
    
    
}
- (void) retrieveTopTenScores
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardRequest.category = @"com.nobinobiru.shooting";
        leaderboardRequest.range = NSMakeRange(1,10);
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil)
            {
                // Handle the error.
            }
            if (scores != nil)
            {
                NSLog(@"scores Is %@",scores);
                // Process the score information.
            }
        }];
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
