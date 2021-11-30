//
//  GamePayTool.h
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GamePayTool : NSObject

+ (instancetype)sharePayTool;

- (void)payGameWith:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
