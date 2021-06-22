#import "IAPManager.h"
#define __MAX_GAME_ID_SIZE     32

@interface IAPManager()<NSURLConnectionDataDelegate>

@property (nonatomic,assign) id<JCIapProcessCtrlDelegate> delegate;
@property (nonatomic,strong) NSString* gameAppID;
@property (nonatomic,strong) NSString *strPlateform;
@end

@implementation IAPManager

+ (IAPManager*) getInstance{
    static IAPManager* iap = nil;
    if (iap == nil){
        iap = [IAPManager alloc];
    }
    return iap;
}

- (id)initWithGameID:(NSString*)gameID andDelegate:(id<JCIapProcessCtrlDelegate>)delegate{
    if ((self = [super init])) {
        NSAssert(gameID != nil,@"[IAP] gameID can not be nil");
        NSAssert(gameID.length <= __MAX_GAME_ID_SIZE,@"gameID is too long");
        self.gameAppID = [NSString stringWithString:gameID];
        NSAssert(delegate != nil, @"[IAP] delegate can not be nil");
        self.delegate = delegate;
        self.strPlateform = [NSString stringWithFormat:@"%@,%@,%@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
        NSLog(@"[IAP]plateform info: %@\n", self.strPlateform);
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        // [self.delegate onCallBack:1 reason:@"" retry:true receipt:@"" orderid:@""];
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)buy:(NSString*)productId orderid:(NSString*) orderid
{
    bool canBuy = [SKPaymentQueue canMakePayments];
    
    if (canBuy) {
        NSLog(@"允许程序内付费购买");
        //直接购买
        //SKPayment *payment = [SKPayment paymentWithProductIdentifier:productId];
        
        SKMutablePayment *payment = [SKMutablePayment paymentWithProductIdentifier:productId];
        payment.applicationUsername = orderid;
        
        NSLog(@"---------发送购买请求------------");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        [self.delegate onCallBack:-1 reason:@"You can‘t purchase in app store（没允许应用程序内购买）" retry:false receipt:@"" orderid:@""];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    //完成购买
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                [self completeTransaction:transaction retry:false];
                NSLog(@"-----交易完成 --------");
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction retry:false];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                //[self restoreTransaction:transaction];
                //NSLog(@"-----已经购买过该商品 --------");
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction retry:(Boolean)bRetry
{
    NSLog(@"-----completeTransaction--------");
    NSString* pszBase64 = [transaction.transactionReceipt base64Encoding];
    [self.delegate onCallBack:0 reason:@"购买成功！" retry:bRetry receipt:pszBase64 orderid:transaction.payment.applicationUsername];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction retry:(Boolean)bRetry
{
    NSLog(@"失败,%ld,%@",(long)transaction.error.code,[transaction.error localizedDescription]);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    //用户取消
    if (transaction.error.code == SKErrorPaymentCancelled)
        [self.delegate onCallBack:-1 reason:@"您取消支付！" retry:bRetry receipt:@"" orderid:@""];
    else
        [self.delegate onCallBack:-1 reason:[transaction.error localizedDescription] retry:bRetry receipt:@"" orderid:@""];
}

-(void)retryProvideProduct
{
    bool bTraslate = false;
    NSLog(@"-----paymentQueue--------");
    
    for (SKPaymentTransaction *transaction in [[SKPaymentQueue defaultQueue]transactions])
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                [self completeTransaction:transaction retry:true];
                bTraslate = true;
                NSLog(@"-----交易完成 --------");
            }
                break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction retry:true];
                bTraslate = true;
            }
                break;
            default:
                break;
        }
    }
    if(!bTraslate){
        [self.delegate onCallBack:1 reason:@"" retry:true receipt:@"" orderid:@""];
    }
}

-(void)finishTransaction
{
    NSLog(@"-----finishTransaction --------");
    for (SKPaymentTransaction *transaction in [[SKPaymentQueue defaultQueue]transactions])
    {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

@end
