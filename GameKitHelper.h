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

@protocol GameKitHelperProtocol <NSObject>
-(void)onScoreSubmitted:(bool)success;
@end

@interface GameKitHelper : NSObject<GKGameCenterControllerDelegate>

@property (nonatomic,strong) id<GameKitHelperProtocol>delegate;

@property (nonatomic,strong) NSError *lastError;
+(id)shared;
-(void)authenticateLocalPlayer;
-(void)submitScore:(int)value category:(NSString *)category;

@end
