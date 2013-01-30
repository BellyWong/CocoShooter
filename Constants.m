//
//  Constants.m
//  CocoShooter
//
//  Created by HARADA SHINYA on 1/30/13.
//
//

#import "Constants.h"
#import "cocos2d.h"



@implementation Constants
{


}
+(CGFloat )screenHeight
{
    return [[CCDirector sharedDirector] winSize].height;
}
+(CGFloat )screenWidth
{
    return [[CCDirector sharedDirector] winSize].width;
}

@end
