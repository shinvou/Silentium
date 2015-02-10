//
//  Tweak.xm
//  Silentium
//
//  Created by Timm Kandziora on 06.02.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "Silentium-Header.h"

static BOOL silentiumEnabled = YES;
static BOOL soundEnabled = NO;
static NSMutableArray *silencedApplications = nil;

#pragma mark - Helper

static BOOL SilenceApplicationWithIdentifier(NSString *identifier)
{
	for (NSString *silencedIdentifier in silencedApplications) {
		if ([silencedIdentifier isEqualToString:identifier]) {
			return YES;
		}
	}

	return NO;
}

#pragma mark - Notification Center

%hook SBBulletinObserverViewController

- (void)observer:(id)observer addBulletin:(BBBulletin *)bulletin forFeed:(unsigned long long)feed
{
	if (!silentiumEnabled) {
		%orig();
	} else {
		if (!SilenceApplicationWithIdentifier([bulletin sectionID])) {
			%orig();
		} else {
			NSLog(@"[Silentium] Didn't add %@ to notification center.", [bulletin sectionID]);
		}
	}
}

%end

#pragma mark - Lockscreen

%hook SBLockScreenNotificationListController

- (id)_newItemForBulletin:(BBBulletin *)bulletin
{
	if (!silentiumEnabled) {
		return %orig();
	} else {
		if (!SilenceApplicationWithIdentifier([bulletin sectionID])) {
			return %orig();
		} else {
			if (soundEnabled) [self _playSoundForBulletinIfPossible:bulletin];
			NSLog(@"[Silentium] Didn't add %@ to lockscreen.", [bulletin sectionID]);
			return nil;
		}
	}
}

%end

#pragma mark - Homescreen
%hook SBBannerController

- (void)_presentBannerForContext:(SBUIBannerContext *)bannerContext reason:(long long)reason
{
	if (!silentiumEnabled) {
		%orig();
	} else {
		SBUIBannerContext *context = bannerContext;
		SBBulletinBannerItem *bannerItem = [context item];
		BBBulletin *bulletin = [bannerItem pullDownNotification];
		NSString *sectionID = [bulletin sectionID];

		if (!SilenceApplicationWithIdentifier(sectionID)) {
			%orig();
		} else {
			if (soundEnabled) [self _playSoundForContext:bannerContext];
			NSLog(@"[Silentium] Presenting banner for %@ is disabled.", sectionID);
		}
	}
}

%end

static void ReloadSettings()
{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	if (settings) {
		if ([settings objectForKey:@"silentiumEnabled"]) {
			silentiumEnabled = [[settings objectForKey:@"silentiumEnabled"] boolValue];
		}

		if ([settings objectForKey:@"soundEnabled"]) {
			soundEnabled = [[settings objectForKey:@"soundEnabled"] boolValue];
		}

		silencedApplications = [[NSMutableArray alloc] init];

		for (NSString *key in settings) {
			if ([key hasPrefix:@"Silenced:"] && [[settings objectForKey:key] boolValue]) {
				[silencedApplications addObject:[key stringByReplacingOccurrencesOfString:@"Silenced:" withString:@""]];
			}
		}
	}

	[settings release];
}

%ctor {
	@autoreleasepool {
		ReloadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
										NULL,
										(CFNotificationCallback)ReloadSettings,
										CFSTR("com.shinvou.silentium/reloadSettings"),
										NULL,
										CFNotificationSuspensionBehaviorCoalesce);
	}
}
