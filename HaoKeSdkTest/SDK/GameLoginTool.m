//
//  GameLoginTool.m
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/22.
//

#import "GameLoginTool.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "GameSDKTool.h"

static NSString *const googleClientId = @"";

@interface GameLoginTool ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, copy) void(^completeAction)(NSDictionary *userData, NSString *error);

@end

@implementation GameLoginTool

+ (instancetype)shareLoginTool {
    static GameLoginTool *loginTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginTool = [[GameLoginTool alloc] init];
    });
    return loginTool;
}

- (void)loginGameWithType:(GameLoginType)loginType complete:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))complete {
    self.completeAction = complete;
    switch (loginType) {
        case GameLoginToolGoogle: {
            [GIDSignIn.sharedInstance restorePreviousSignInWithCallback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
                if (user && !error) {
                    [self googleUserData:user];
                    return;
                }
                GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:googleClientId];
                [GIDSignIn.sharedInstance signInWithConfiguration:signInConfig presentingViewController:UIApplication.sharedApplication.keyWindow.rootViewController callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
                    if (error || !user) { return; }
                    [self googleUserData:user];
                }];
            }];
            
        }
            break;
        case GameLoginToolFacebook: {
            if (FBSDKAccessToken.currentAccessToken) {
                [self facebookUserData];
                return;
            }
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithPermissions:@[@"public_profile"] fromViewController:UIApplication.sharedApplication.keyWindow.rootViewController handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                if (error || result.isCancelled) { return; }
                [self facebookUserData];
            }];
        }
            break;
        case GameLoginToolApple: {
            if (@available(iOS 13.0, *)) {
                ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
                ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
                request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
                ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
                auth.delegate = self;
                auth.presentationContextProvider = self;
                [auth performRequests];
            }
        }
            break;
        case GameLoginToolYouKe: {
            NSString *uuid = [GameSDKTool uuidString];
        }
            break;
    }
}

- (void)googleUserData:(GIDGoogleUser * _Nullable)user {
    NSString *userId = user.userID;
    NSString *emailAddress = user.profile.email ? : @"";
    NSString *name = user.profile.name;
    [user.authentication doWithFreshTokens:^(GIDAuthentication * _Nullable authentication, NSError * _Nullable error) {
        if (error || !authentication) { return; }
        NSString *idToken = authentication.idToken;
    }];
}

- (void)facebookUserData {
    if ([FBSDKProfile currentProfile]) {
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if (error || !profile) { return; }
            NSString *userId = profile.userID;
            NSString *emailAddress = profile.email ? : @"";
            NSString *name = profile.name;
        }];
    }
}

#pragma mark ------Sign With Apple

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return UIApplication.sharedApplication.keyWindow;
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *apple = authorization.credential;
        ///将返回得到的user 存储起来
        NSString *userIdentifier = apple.user;
        NSPersonNameComponents *fullName = apple.fullName;
        NSString *email = apple.email;
        //用于后台像苹果服务器验证身份信息
        NSData *identityToken = apple.identityToken;
        NSLog(@"%@%@%@%@",userIdentifier,fullName,email,identityToken);
    }
    if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        //// Sign in using an existing iCloud Keychain credential.
        ASPasswordCredential *pass = authorization.credential;
        NSString *username = pass.user;
        NSString *passw = pass.password;
        NSLog(@"%@%@",username, passw);
    }
}

///回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSLog(@"%@",error.localizedDescription);
}


- (void)logoutGameWithType:(GameLoginType)loginType {
    switch (loginType) {
        case GameLoginToolGoogle: {
            [GIDSignIn.sharedInstance signOut];
        }
            break;
        case GameLoginToolFacebook: {
            
        }
            break;
        case GameLoginToolApple: {
            
        }
            break;
        default:
            break;
    }
}

@end
