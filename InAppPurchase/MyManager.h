


//@import UIKit;
//@import Foundation;

@interface MyManager : NSObject
{
    UIImage *imageForScan,*cropImage;
    NSMutableArray *allHitUpArray;

    NSMutableDictionary *composeDictionary;
    NSMutableArray *composeArray;
    
    NSMutableDictionary *profileDataDictionary;
    NSMutableDictionary *purchaseDataDictionary;

    NSMutableDictionary *linkedinConnectionDictionary;
    NSDictionary *selectedLinkedinConnectionDic;
    
    int currentSideBarIndex;
    int sideBarselectedIndex;
    int checkTextFieldType;
    
    int intMailBoxViewType;                        // Set 1 for Confirmed HitUps, 2 for all HitUps, 3 for received HitUps
    
    BOOL firstTimeLogin;
    
    NSString *selectedHitUpWHAT;
    NSString *selectedHitUpID;
    NSString *FromUserID_HitUp;
    NSString *ToUserID_HitUp;
    
//    PFObject *selectedHitUpObject;

    int countSentHitUp;
    int countReceivedHitUp;
    int unreadReceivedHitUpCount;
    
    
    NSString *replyMessage;
    NSString *changeLocation;
    BOOL signupSuccess;
    
    int intAppStartedAgain;                         // Set 0 if started from beginning, 1 if LogOut and then start, 2 if in Mailbox, 3 if go to background with auto login
    
    NSString *imageFilePath;
}
@property (nonatomic,retain) UIImage *imageForScan,*cropImage;
@property (nonatomic,retain) NSMutableArray *allHitUpArray;

@property (nonatomic,retain) NSMutableDictionary *composeDictionary;
@property (nonatomic,retain) NSMutableArray *composeArray;

@property (nonatomic,retain) NSMutableDictionary *profileDataDictionary;
@property (nonatomic,retain) NSMutableDictionary *purchaseDataDictionary;

@property (nonatomic,retain) NSMutableDictionary *linkedinConnectionDictionary;
@property (nonatomic,retain) NSDictionary *selectedLinkedinConnectionDic;

@property (nonatomic,readwrite) int currentSideBarIndex;
@property (nonatomic,readwrite) int sideBarselectedIndex;
@property (nonatomic,readwrite) int checkTextFieldType;

@property (nonatomic,readwrite) int intMailBoxViewType;

@property (nonatomic,readwrite) BOOL firstTimeLogin;

@property (nonatomic,retain) NSString *selectedHitUpWHAT;
@property (nonatomic,retain) NSString *selectedHitUpID;
@property (nonatomic,retain) NSString *FromUserID_HitUp;
@property (nonatomic,retain) NSString *ToUserID_HitUp;

//@property (nonatomic,retain) PFObject *selectedHitUpObject;

@property (nonatomic,readwrite) int countSentHitUp;
@property (nonatomic,readwrite) int countReceivedHitUp;
@property (nonatomic,readwrite) int unreadReceivedHitUpCount;

@property (nonatomic,retain) NSString *replyMessage;
@property (nonatomic,retain) NSString *changeLocation;
@property (nonatomic,readwrite) BOOL signupSuccess;
@property (nonatomic,readwrite) int intAppStartedAgain;

@property (nonatomic,retain) NSString *imageFilePath;



+ (id)sharedManager;


// To validate email address

- (BOOL)validateEmail:(NSString*)email;

// Device Version and Type Methods

- (BOOL)isDeviceAniPhone;
- (BOOL)isDeviceAniPhone5;
- (BOOL)isDeviceAniPad;
- (BOOL)isDeviceAniPhone3;
- (BOOL)isDeviceAniPhone3or4;

@end
