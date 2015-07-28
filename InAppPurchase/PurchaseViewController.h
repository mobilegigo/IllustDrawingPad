#import <UIKit/UIKit.h>
#import "WDAppDelegate.h"
#import "InAppPurchaser.h"

@protocol PurchaseViewDelegate;
@class MyManager;

@interface PurchaseViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *convertDocsImageView;
    IBOutlet UILabel *inAppPurchaseLabel;
    IBOutlet UIButton *purchaseButton;
    
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UIButton *restoreButton;

    
    
    InAppPurchaser* m_InAppStore;
    WDAppDelegate *appDelegate;
    MyManager *sharedManager;

    id <PurchaseViewDelegate> _delegate;
    IBOutlet UILabel *Label_Title;
    
    IBOutlet UIScrollView *mainScrollview;
}

@property (readwrite,assign, nonatomic) id<PurchaseViewDelegate> delegate;


- (IBAction)purchaseButton_Clicked:(id)sender;
- (IBAction)cancelButton_Clicked:(id)sender;
- (IBAction)restoreButton_Clicked:(id)sender;


@end



@protocol PurchaseViewDelegate <NSObject>

@required
- (void) PurchaseCall:(int)intCheck;
// Set intCheck to 0 when cancel the registration or not selected the delegated, set 1 if already registered before, 2 if edit the profile

@end
