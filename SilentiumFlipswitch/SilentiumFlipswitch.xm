//
//  SilentiumFlipswitch.xm
//  Silentium
//
//  Created by Timm Kandziora on 24.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <../Silentium-Header.h>

static BOOL silentiumEnabled = YES;

@interface SilentiumSwitch : NSObject <FSSwitchDataSource>
@end

@implementation SilentiumSwitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier
{
	return @"Silentium";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	if (settings) {
		if ([settings objectForKey:@"silentiumEnabled"]) {
			silentiumEnabled = [[settings objectForKey:@"silentiumEnabled"] boolValue];
		}
	}

	[settings release];

	return silentiumEnabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{

	if (newState == FSSwitchStateIndeterminate) {
		return;
	} else if (newState == FSSwitchStateOn) {
		silentiumEnabled = YES;
	} else {
		silentiumEnabled = NO;
	}

	NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
	[settings setObject:[NSNumber numberWithBool:silentiumEnabled] forKey:@"silentiumEnabled"];
	[settings writeToFile:settingsPath atomically:YES];
	[settings release];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.silentium/reloadSettings"), NULL, NULL, TRUE);
}

@end
