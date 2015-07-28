#import "PurchaseViewController.h"
//#import "Constant.h"
//#import "Appirater.h"
#import "MyManager.h"
//#import "GAIDictionaryBuilder.h"
//#import "GAIDictionaryBuilder.h"


@interface PurchaseViewController ()

@end

@implementation PurchaseViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
- (void)viewDidLoad
{
    appDelegate = (WDAppDelegate*) [[UIApplication sharedApplication] delegate];
    sharedManager = [MyManager sharedManager];
    
    mainScrollview.contentSize = CGSizeMake(320, 500);
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = @"";
    
    
    self.preferredContentSize = CGSizeMake(320,416);
        
    m_InAppStore = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Handle_Purchase_Over:) name:@"EVENT_PURCHASE_OVER" object:nil];

    
    inAppPurchaseLabel.text = @"Remove Advertisement";

    Label_Title.text = @"Store";
    
    cancelButton.title = @"Done";
    //구매 테스트 -->
    //[[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isfullPackPurchased"];
    //<---
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Methods

- (IBAction)restoreButton_Clicked:(id)sender
{

    
//#if TARGET_IPHONE_SIMULATOR
    
    //Simulator
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:NSLocalizedString(@"Simulator - disabled.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//    [alert show];
//#else
    
    if(m_InAppStore == nil)
        m_InAppStore = [[InAppPurchaser alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:m_InAppStore];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    [m_InAppStore requestProductData:unlockAd_inAppPurchaseID];
    
//#endif
}

- (IBAction)purchaseButton_Clicked:(id)sender
{
 
    
#if TARGET_IPHONE_SIMULATOR
    
    //Simulator
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:NSLocalizedString(@"Simulator - disabled.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
#else
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    
    [self Purchase_InAppItem:unlockAd_inAppPurchaseID];
#endif
}

- (IBAction)cancelButton_Clicked:(id)sender
{
    if(sharedManager.isDeviceAniPad)
    {
        [self.delegate PurchaseCall:0];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate PurchaseCall:0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
}

#pragma mark - inAppPurchase Methods

- (void) Purchase_InAppItem:(NSString*) IN_strProduct
{
	if (m_InAppStore != nil)
	{
		// Purchase object cleanup
		[[SKPaymentQueue defaultQueue] removeTransactionObserver:m_InAppStore];
		
		//[m_InAppStore release];
		m_InAppStore = nil;
	}
	
	// Checks if purchase can be made
	if ([SKPaymentQueue canMakePayments])
	{
		// Creates purchase object and makes payment
		m_InAppStore = [[InAppPurchaser alloc] init];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:m_InAppStore];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
		[m_InAppStore requestProductData:IN_strProduct];
    }
	else
	{
		NSLog(@"canMakePayments NO");
	}
}

-(void) Handle_Purchase_Over:(NSNotification *)pNotification
{
	//m_ctrlBtn.enabled = YES;
	
	InAppPurchaser *inApp = [pNotification object];
	
	if (inApp.m_iPurchaseStatus != 2)
	{
		NSLog(@"Purchase FAILED");
	}
	else
	{
		NSLog(@"Purchase SUCCESS");
		
		[[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isfullPackPurchased"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
		//You have to write the code for saving the purchase status either in database or in userprofile.
		//You have to expose the purchase item.(Whatever it is)

	}
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
    //이거 해야하나..??
    
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotate {
    
    return NO;
    
}

@end
