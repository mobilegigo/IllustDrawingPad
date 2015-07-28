#import "MyManager.h"

@implementation MyManager
@synthesize allHitUpArray;
@synthesize composeDictionary;
@synthesize composeArray;
@synthesize profileDataDictionary;
@synthesize purchaseDataDictionary;

@synthesize linkedinConnectionDictionary;
@synthesize selectedLinkedinConnectionDic;

@synthesize currentSideBarIndex;
@synthesize sideBarselectedIndex;
@synthesize checkTextFieldType;

@synthesize intMailBoxViewType;

@synthesize firstTimeLogin;

@synthesize selectedHitUpWHAT;
@synthesize selectedHitUpID;
@synthesize FromUserID_HitUp;
@synthesize ToUserID_HitUp;

//@synthesize selectedHitUpObject;

@synthesize countSentHitUp;
@synthesize countReceivedHitUp;
@synthesize unreadReceivedHitUpCount;

@synthesize replyMessage;
@synthesize changeLocation;
@synthesize signupSuccess;
@synthesize intAppStartedAgain;

@synthesize imageFilePath;
@synthesize imageForScan,cropImage;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];

    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        cropImage = [[UIImage alloc]init];
        imageForScan = [[UIImage alloc]init];

        composeDictionary = [[NSMutableDictionary alloc] init];
        composeArray = [[NSMutableArray alloc] init];
        
        profileDataDictionary = [[NSMutableDictionary alloc] init];
        purchaseDataDictionary = [[NSMutableDictionary alloc] init];
        
        allHitUpArray = [[NSMutableArray alloc] init];

        linkedinConnectionDictionary = [[NSMutableDictionary alloc] init];

        selectedHitUpID = @"";
        FromUserID_HitUp = @"";
        ToUserID_HitUp = @"";
        selectedHitUpWHAT = @"";
        currentSideBarIndex = 1;
        sideBarselectedIndex = 1;
        checkTextFieldType = 0;
        intMailBoxViewType = 1;
        replyMessage = @"";
        changeLocation = @"";
        signupSuccess = FALSE;
        intAppStartedAgain = 0;
        
        countSentHitUp = 0;
        countReceivedHitUp = 0;
        unreadReceivedHitUpCount = 0;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        imageFilePath = [documentsDir stringByAppendingPathComponent:@"profileImage.png"];
    }
    return self;
}

// Device Version and Type Methods

- (BOOL)isDeviceAniPhone3
{
    BOOL isiPhone3;
    
    if (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(320, 480)) || CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)))
    {
        isiPhone3 = TRUE;
        return isiPhone3;
    }
    isiPhone3 = FALSE;
    return isiPhone3;
    
}

- (BOOL)isDeviceAniPhone3or4
{
    BOOL isiPhone3or4;
    
    if (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(320, 480)) || CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)))
    {
        isiPhone3or4 = TRUE;
        return isiPhone3or4;
    }
    isiPhone3or4 = FALSE;
    return isiPhone3or4;
}

- (BOOL)isDeviceAniPhone
{
    BOOL isAniPhone;
    
    if (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(320, 480)) || CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960)) || CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136)))
    {
        isAniPhone = TRUE;
        return isAniPhone;
    }
    isAniPhone = FALSE;
    return isAniPhone;
}

- (BOOL)isDeviceAniPhone5
{
    BOOL isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    
    return isiPhone5;
}

- (BOOL)isDeviceAniPad
{
    #ifdef UI_USER_INTERFACE_IDIOM
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    #else
        return NO;
    #endif
}

- (BOOL)validateEmail:(NSString*)email
{
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no '@' or '.' present
        return NO;
}

@end
