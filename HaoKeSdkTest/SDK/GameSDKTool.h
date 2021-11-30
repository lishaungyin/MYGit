//
//  GameSDKTool.h
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameSDKTool : NSObject

+ (NSString *)uuidString;

+ (NSString *)md5:(NSString *)str;

+ (void)requestUrl:(NSString *)urlStr requestParameter:(NSDictionary *)parameter complete:(void(^)(id json))success failure:(void(^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
