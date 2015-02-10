//
//  Silentium-Header.h
//  Silentium
//
//  Created by Timm Kandziora on 06.02.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <substrate.h>
#import "Flipswitch/Flipswitch.h"

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.silentium.plist"

@interface BBBulletin
@property (copy) NSString *sectionID;
@end

@interface SBBulletinBannerItem
- (BBBulletin *)pullDownNotification;
@end

@interface SBUIBannerContext
- (SBBulletinBannerItem *)item;
@end

@interface SBBannerController
- (void)_playSoundForContext:(SBUIBannerContext *)bannerContext;
- (void)_presentBannerForContext:(SBUIBannerContext *)bannerContext reason:(long long)reason;
@end

@interface SBLockScreenNotificationListController
-(void)_playSoundForBulletinIfPossible:(BBBulletin *)bulletin;
@end
