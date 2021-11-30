//
//  GamePayTool.m
//  HaoKeSdkTest
//
//  Created by 一九八八 on 2021/11/22.
//

#import "GamePayTool.h"
#import <StoreKit/StoreKit.h>
#import "GameSDKTool.h"

@interface GamePayTool ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, copy) NSString *productIdentifier;

@end

@implementation GamePayTool

+ (instancetype)sharePayTool {
    static GamePayTool *payTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payTool = [[GamePayTool alloc] init];
    });
    return payTool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)payGameWith:(NSDictionary *)parameter {
    self.parameter = parameter;
    if ([SKPaymentQueue canMakePayments]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"GamePayData" ofType:@"plist"];
        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *productIdentifier = data[parameter[@""]];
        self.productIdentifier = productIdentifier;
        NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];
    } else {
        NSLog(@"不允许程序内付费");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (product.count == 0) {
        return;
    }
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        if ([pro.productIdentifier isEqualToString:self.productIdentifier]) {
            p = pro;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
}

- (void)requestDidFinish:(SKRequest *)request {
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成!");
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateRestored:{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];
    NSString *serverId = self.parameter[@"serverId"];
    NSString *productId = self.parameter[@"productId"];
    NSString *money = self.parameter[@""];
    NSString *orderId = self.parameter[@"orderId"];
    NSString *account = self.parameter[@""];
    NSString *sign = [GameSDKTool md5:[NSString stringWithFormat:@"%@%@%@100040%@%@n7m5T8gDG0M5o08KqwcDMTVx45EAIS3z", account, money, orderId, productId, serverId]];
    NSDictionary *parameter = @{@"apple_receipt":receiptStr, @"server_id":serverId, @"product_id":productId, @"money":money, @"order_id":orderId, @"account":account, @"partner_id":@"100040", @"sign":sign};
    [GameSDKTool requestUrl:@"" requestParameter:parameter complete:^(id  _Nonnull json) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
