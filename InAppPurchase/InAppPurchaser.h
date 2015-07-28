#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h> 

@interface InAppPurchaser : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> 
{
	int m_iPurchaseStatus;	// This will store the purchase status.
							// 0 - Not Processed,  1 - Failed, 2 - Success

}

@property(readwrite,assign) int m_iPurchaseStatus;

- (void) requestProductData:(NSString*) productID;

@end
