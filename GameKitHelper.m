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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gh = [[GameKitHelper alloc ] init];
        
    });
    return gh;
    
}

-(void)authenticateLocalPlayer
{
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *vc,NSError *err){
        [self setLastError:err];
        if ([CCDirector sharedDirector].isPaused){
            [[CCDirector sharedDirector] resume];
        }
        if (localPlayer.authenticated){
            _gameCenterFeaturesEnabled = YES;
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
        if ([_delegate respondsToSelector:@selector(onScoreSubmitted:)]){
            [_delegate onScoreSubmitted:success];
            
        }
        
    }];
}



@end
