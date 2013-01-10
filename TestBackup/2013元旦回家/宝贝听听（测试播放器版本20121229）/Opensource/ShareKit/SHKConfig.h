




// PLEASE SEE INSTALL/CONFIG INSTRUCTIONS:
// http://getsharekit.com/install






// App Description
// These values are used by any service that shows 'shared from XYZ'

#define SHKMyAppName			@"My App Name"
#define SHKMyAppURL				@"http://example.com"



/*
 API Keys
 --------
 This is the longest step to getting set up, it involves filling in API keys for the supported services.
 It should be pretty painless though and should hopefully take no more than a few minutes.
 
 Each key below as a link to a page where you can generate an api key.  Fill in the key for each service below.
 
 A note on services you don't need:
 If, for example, your app only shares URLs then you probably won't need image services like Flickr.
 In these cases it is safe to leave an API key blank.
 
 However, it is STRONGLY recommended that you do your best to support all services for the types of sharing you support.
 The core principle behind ShareKit is to leave the service choices up to the user.  Thus, you should not remove any services,
 leaving that decision up to the user.
 */

//Tencent - http://open.t.qq.com
#define SHKTencentConsumerKey       @"801058979"
#define SHKTencentSecret            @"3254813204105fd62d4ab1f1d602306f"
#define SHKTencentCallbackUrl       @"http://itunes.apple.com/cn/app/bao-bei-ting-ting/id480111612?mt=8" // You need to set this if using OAuth, see note above (xAuth users can skip it)
#define SHKTencentUseXAuth			0 // To use xAuth, set to 1
#define SHKTencentUsername			@"Qbabyting" // Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)



//Sina - http://open.weibo.com
#define SHKSinaConsumerKey      @"3488461899"
#define SHKSinaSecret           @"3e226b1cdd5b501dddba7ff61576e527"
#define SHKSinaCallbackUrl		@"http://itunes.apple.com/cn/app/bao-bei-ting-ting/id480111612?mt=8" // You need to set this if using OAuth, see note above (xAuth users can skip it)
#define SHKSinaOauthCallBackUrl @"http://baobeitingting.jsp"
#define SHKSinaUseXAuth			0 // To use xAuth, set to 1
#define SHKSinaUserID           @"2636029301"
#define SHKSinaUsername			@"宝贝听听_客户端" // Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
#define USER_STORE_ACCESS_TOKEN @"accessToken"
//#define USER_STORE_USER_ID      @"userId"
#define SINA_USER_STORE_EXPIRATION_DATE  @"SinaExpirationDate"



//RenRen - http://dev.renren.com/
#define SHKRenrenAppID									@"2080207"
#define SHKRenrenConsumerKey							@"9832da0b775e478bb2795b847be129de"
#define SHKRenrenSecret									@"72b3b16261be41a3b6ce6cd3ed4672b1"
#define SHKRenrenOauthCallBackUrl						@"http://graph.renren.com/oauth/login_success.html" // You need to set this if using OAuth, see note above (xAuth users can skip it)
#define SHKRenrenUseXAuth								0
#define SHKRenrenCallbackUrl							@"http://itunes.apple.com/cn/app/bao-bei-ting-ting/id480111612?mt=8"
#define RENREN_USER_STORE_EXPIRATION_DAT				@"RenrenExpirationDate"
#define SHKRenrenRequestBaseUrl							@"http://api.renren.com/restserver.do"
#define RENREN_USER_STORE_NICK_NAME						@"RenRenUserNickName"
//#define SHKRenrenUserNickNameLabelTag					7734



// Delicious - https://developer.apps.yahoo.com/projects
#define SHKDeliciousConsumerKey		@""
#define SHKDeliciousSecretKey		@""

// Facebook - http://www.facebook.com/developers
// If SHKFacebookUseSessionProxy is enabled then SHKFacebookSecret is ignored and should be left blank

#define SHKFacebookUseSessionProxy  NO 
#define SHKFacebookKey				@"ad964fe3b361d0b65a4ddde9496da879"
#define SHKFacebookSecret			@"f07edf3fb9109989cdbd903b44352fde"
#define SHKFacebookSessionProxyURL  @""

// Read It Later - http://readitlaterlist.com/api/?shk
#define SHKReadItLaterKey			@""

// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */
#define SHKTwitterConsumerKey		@"YDunPGAyBsNzdsRIYuxPRw"
#define SHKTwitterSecret			@"FTMP8AUQj8b9nzC75YSFcqznqZo76AUQH5SiPJu3os"
#define SHKTwitterCallbackUrl		@"http://itunes.apple.com/cn/app/id428426017?mt=8" // You need to set this if using OAuth, see note above (xAuth users can skip it)
#define SHKTwitterUseXAuth			0 // To use xAuth, set to 1
#define SHKTwitterUsername			@"" // Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)

// Bit.ly (for shortening URLs on Twitter) - http://bit.ly/account/register - after signup: http://bit.ly/a/your_api_key
#define SHKBitLyLogin				@""
#define SHKBitLyKey					@""

// ShareMenu Ordering
#define SHKShareMenuAlphabeticalOrder 1 // Setting this to 1 will show list in Alphabetical Order, setting to 0 will follow the order in SHKShares.plist

// Append 'Shared With 'Signature to Email (and related forms)
#define SHKSharedWithSignature		0



/*
 UI Configuration : Basic
 ------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

// Toolbars
#define SHKBarStyle					@"UIBarStyleDefault" // See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIKitDataTypesReference/Reference/reference.html#//apple_ref/c/econst/UIBarStyleDefault
#define SHKBarTintColorRed			-1 // Value between 0-255, set all to -1 for default
#define SHKBarTintColorGreen		-1 // Value between 0-255, set all to -1 for default
#define SHKBarTintColorBlue			-1 // Value between 0-255, set all to -1 for default

// Forms
#define SHKFormFontColorRed			-1 // Value between 0-255, set all to -1 for default
#define SHKFormFontColorGreen		-1 // Value between 0-255, set all to -1 for default
#define SHKFormFontColorBlue		-1 // Value between 0-255, set all to -1 for default

#define SHKFormBgColorRed			-1 // Value between 0-255, set all to -1 for default
#define SHKFormBgColorGreen			-1 // Value between 0-255, set all to -1 for default
#define SHKFormBgColorBlue			-1 // Value between 0-255, set all to -1 for default

// iPad views
#define SHKModalPresentationStyle	@"UIModalPresentationFormSheet" // See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalPresentationStyle
#define SHKModalTransitionStyle		@"UIModalTransitionStyleCoverVertical" // See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalTransitionStyle

// ShareMenu Ordering
#define SHKShareMenuAlphabeticalOrder 1 // Setting this to 1 will show list in Alphabetical Order, setting to 0 will follow the order in SHKShares.plist

// Append 'Shared With 'Signature to Email (and related forms)
#define SHKSharedWithSignature		0

/*
 UI Configuration : Advanced
 ------
 If you'd like to do more advanced customization of the ShareKit UI, like background images and more,
 check out http://getsharekit.com/customize
 */



/*
 Debugging
 ------
 To show debug output in the console:
 1. uncomment section A below
 2. comment out section B below
 
 To hide debug output in the console:
 1. uncomment section B below
 2. comment out section A below
 */

// A : show debug output
#define SHKDebugShowLogs			1
#define SHKLog( s, ... ) DLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

// B : hide debug output
//#define SHKDebugShowLogs			0
//#define SHKLog( s, ... ) 



/*
 Advanced Configuration
 ------
 These settings can be left as is.  This only need to be changed for uber custom installs.
 */

#define SHK_MAX_FAV_COUNT			3
#define SHK_FAVS_PREFIX_KEY			@"SHK_FAVS_"
#define SHK_AUTH_PREFIX				@"SHK_AUTH_"