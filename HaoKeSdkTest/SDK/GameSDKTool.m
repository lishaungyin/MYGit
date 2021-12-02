//
//  GameSDKTool.m
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/26.
//

#import "GameSDKTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GameSDKTool

+ (NSString *)uuidString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return [result lowercaseString];
}

+ (void)requestUrl:(NSString *)urlStr requestParameter:(NSDictionary *)parameter complete:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    __block NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    NSArray *keyArr = [parameter allKeys];
    [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == keyArr.count - 1) {
            keyValueFormat = [NSString stringWithFormat:@"%@=%@", obj, [parameter valueForKey:obj]];
            [result appendString:keyValueFormat];
        } else {
            keyValueFormat = [NSString stringWithFormat:@"%@=%@&", obj, [parameter valueForKey:obj]];
            [result appendString:keyValueFormat];
        }
    }];
    request.HTTPBody = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            failure(error);
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(dic);
        }
    }];
    [dataTask resume];
}

@end
