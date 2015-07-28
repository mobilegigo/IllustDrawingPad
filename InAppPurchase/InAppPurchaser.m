#import "InAppPurchaser.h"

@implementation InAppPurchaser

@synthesize m_iPurchaseStatus;

// Calls the Appstore Purchase.
-(void)requestProductData:(NSString*) productID
{
	m_iPurchaseStatus = 0;
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: productID]];
	request.delegate = self;
	[request start];
}


// Response got from Appstore
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *myProduct = response.products;
	
	NSLog(@"Product Count %lu", (unsigned long)[myProduct count]);
	// populate UI
	//[request autorelease];
	
	if ([myProduct count] <= 0)
	{
		NSLog(@"ProductId not found in InApp Store");
		
		// Purchase status is set and message is given to the parent ViewController.
		m_iPurchaseStatus = 1;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_PURCHASE_OVER" object:self];		
	}
	
	// Product list got from Appstore, In our case there will be only one. As we requested with one product. 
	for(int i=0;i<[myProduct count];i++)
	{
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f",[product localizedTitle],[[product price] doubleValue]);
		NSLog(@"Product identifier: '%@'", [product productIdentifier]);
		
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}	
}


// Product is already purchased. 
-(void)restoreTransaction: (SKPaymentTransaction *)transaction
{
	m_iPurchaseStatus = 2;
	
	// Purchase status is set and message is given to the parent ViewController.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isfullPackPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
 
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_PURCHASE_OVER" object:self];
}

// Failed to purchase
-(void)failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
		if ([transaction.error localizedFailureReason] != nil) 
		{
			NSLog(@"failedTransaction Reason '%@'", [transaction.error localizedFailureReason]);
		}
		
		if ([transaction.error localizedRecoverySuggestion] != nil)
		{
			NSLog(@"failedTransaction Recovery Suggestion '%@'", [transaction.error localizedRecoverySuggestion]);	
		}
    }
	
	// Purchase status is set and message is given to the parent ViewController.
	m_iPurchaseStatus = 1;
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_PURCHASE_OVER" object:self];
}


// Product is purchased
-(void)completeTransaction: (SKPaymentTransaction *)transaction
{
	// Your application should implement these two methods.
	//   [self recordTransaction: transaction];
	//   [self provideContent: transaction.payment.productIdentifier];
	// Remove the transaction from the payment queue.
    
	
	// Purchase status is set and message is given to the parent ViewController.
	m_iPurchaseStatus = 2;	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isfullPackPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];

	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENT_PURCHASE_OVER" object:self];
}


// The event got when transaction is complete.
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{	
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

@end
