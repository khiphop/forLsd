#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol JCIapProcessCtrlDelegate <NSObject>
@required
- (void)onCallBack:(NSInteger)p_iRet reason:(NSString *)p_pReason retry:(Boolean)bRetry receipt:(NSString *)p_pReceipt orderid:(NSString *)p_pOrderid;
@end

@interface IAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
+ (IAPManager*) getInstance;

- (id)initWithGameID:(NSString*)gameID andDelegate:(id<JCIapProcessCtrlDelegate>)delegate;

- (void) requestProductData:(NSString*)productId;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions; //购买结果
- (void) completeTransaction: (SKPaymentTransaction *)transaction retry:(Boolean)bRetry;
- (void) failedTransaction: (SKPaymentTransaction *)transaction retry:(Boolean)bRetry;

- (void) buy:(NSString*)productId orderid:(NSString*)orderid;
- (void) retryProvideProduct;
- (void) finishTransaction;

@end
