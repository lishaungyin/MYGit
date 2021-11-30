//
//  GameLoginTool.h
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GameLoginType) {
    GameLoginToolGoogle,
    GameLoginToolFacebook,
    GameLoginToolApple,
    GameLoginToolYouKe,
};

@interface GameLoginTool : NSObject

+ (instancetype)shareLoginTool;

- (void)loginGameWithType:(GameLoginType)loginType complete:(void(^)(NSDictionary *userData, NSString *error))complete;

- (void)logoutGameWithType:(GameLoginType)loginType;

@end

NS_ASSUME_NONNULL_END
