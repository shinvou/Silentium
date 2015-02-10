#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.silentium.plist"
#define UIColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface SilentiumBanner : PSTableCell
@end

@implementation SilentiumBanner

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"silentiumBannerCell" specifier:specifier];
    
    if (self) {
        self.backgroundColor = UIColorRGB(74, 74, 74);
        
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 206)];
        label.font = [UIFont fontWithName:@"Helvetica-Light" size:60];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"#pantarhei";
        
        [self addSubview:label];
    }
    
    return self;
}

@end

@interface SilentiumSettingsListController : PSListController
@end

@implementation SilentiumSettingsListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Silentium"];
        
        PSSpecifier *banner = [PSSpecifier preferenceSpecifierNamed:nil
                                                             target:self
                                                                set:NULL
                                                                get:NULL
                                                             detail:Nil
                                                               cell:PSStaticTextCell
                                                               edit:Nil];
        [banner setProperty:[SilentiumBanner class] forKey:@"cellClass"];
        [banner setProperty:@"206" forKey:@"height"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        
        PSSpecifier *silentiumEnabled = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                                       target:self
                                                                          set:@selector(setValue:forSpecifier:)
                                                                          get:@selector(getValueForSpecifier:)
                                                                       detail:Nil
                                                                         cell:PSSwitchCell
                                                                         edit:Nil];
        [silentiumEnabled setIdentifier:@"silentiumEnabled"];
        [silentiumEnabled setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:nil];
        [secondGroup setProperty:@"If enabled the notification sound will be played for silenced apps." forKey:@"footerText"];
        
        PSSpecifier *soundEnabled = [PSSpecifier preferenceSpecifierNamed:@"Sound enabled"
                                                                   target:self
                                                                      set:@selector(setValue:forSpecifier:)
                                                                      get:@selector(getValueForSpecifier:)
                                                                   detail:Nil
                                                                     cell:PSSwitchCell
                                                                     edit:Nil];
        [soundEnabled setIdentifier:@"soundEnabled"];
        [soundEnabled setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *thirdGroup = [PSSpecifier groupSpecifierWithName:nil];
        [thirdGroup setProperty:@"Choose the apps to be silenced by Silentium." forKey:@"footerText"];
        
        PSSpecifier *applicationsLink = [PSSpecifier preferenceSpecifierNamed:@"Applications"
                                                                       target:self
                                                                          set:NULL
                                                                          get:NULL
                                                                       detail:nil
                                                                         cell:PSLinkCell
                                                                         edit:Nil];
        applicationsLink->action = @selector(lazyLoadBundle:);
        [applicationsLink setProperty:@(YES) forKey:@"enabled"];
        [applicationsLink setProperty:@"/var/mobile/Library/Preferences/com.shinvou.silentium.plist" forKey:@"ALSettingsPath"];
        [applicationsLink setProperty:@"Silenced:" forKey:@"ALSettingsKeyPrefix"];
        [applicationsLink setProperty:@"/System/Library/PreferenceBundles/AppList.bundle" forKey:@"lazy-bundle"];
        
        PSSpecifier *fourthGroup = [PSSpecifier groupSpecifierWithName:@"contact developer"];
        [fourthGroup setProperty:@"Feel free to follow me on twitter for any updates on my apps and tweaks or contact me for support questions.\n \nThis tweak is Open-Source, so make sure to check out my GitHub." forKey:@"footerText"];
        
        PSSpecifier *twitter = [PSSpecifier preferenceSpecifierNamed:@"twitter"
                                                              target:self
                                                                 set:NULL
                                                                 get:NULL
                                                              detail:Nil
                                                                cell:PSLinkCell
                                                                edit:Nil];
        twitter.name = @"@biscoditch";
        twitter->action = @selector(openTwitter);
        [twitter setIdentifier:@"twitter"];
        [twitter setProperty:@(YES) forKey:@"enabled"];
        [twitter setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SilentiumSettings.bundle/twitter.png"] forKey:@"iconImage"];
        
        PSSpecifier *github = [PSSpecifier preferenceSpecifierNamed:@"github"
                                                             target:self
                                                                set:NULL
                                                                get:NULL
                                                             detail:Nil
                                                               cell:PSLinkCell
                                                               edit:Nil];
        github.name = @"https://github.com/shinvou";
        github->action = @selector(openGithub);
        [github setIdentifier:@"github"];
        [github setProperty:@(YES) forKey:@"enabled"];
        [github setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SilentiumSettings.bundle/github.png"] forKey:@"iconImage"];
        
        _specifiers = [NSArray arrayWithObjects:banner, firstGroup, silentiumEnabled, secondGroup, soundEnabled, thirdGroup, applicationsLink, fourthGroup, twitter, github, nil];
    }
    
    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if ([specifier.identifier isEqualToString:@"silentiumEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"silentiumEnabled"]) {
                return [settings objectForKey:@"silentiumEnabled"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    } else if ([specifier.identifier isEqualToString:@"soundEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"soundEnabled"]) {
                return [settings objectForKey:@"soundEnabled"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    }
    
    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    if ([specifier.identifier isEqualToString:@"silentiumEnabled"]) {
        [settings setObject:value forKey:@"silentiumEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"soundEnabled"]) {
        [settings setObject:value forKey:@"soundEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.silentium/reloadSettings"), NULL, NULL, TRUE);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.silentium/reloadSettings"), NULL, NULL, TRUE);
}

- (void)openTwitter
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=biscoditch"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/biscoditch"]];
    }
}

- (void)openGithub
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/shinvou"]];
}

@end
