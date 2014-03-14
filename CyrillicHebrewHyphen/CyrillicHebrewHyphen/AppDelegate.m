//
//  AppDelegate.m
//  CyrillicHebrewHyphen
//
//  Created by Kolyvan on 14.03.14.
//  Copyright (c) 2014 Konstantin Bukreev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];

    [self reproduceBug];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) reproduceBug
{
    // 1. make sure what a current locale is ru_RU
    
    NSLocale *locale = [NSLocale currentLocale];
    if (![locale.localeIdentifier isEqualToString:@"ru_RU"])
    {
        UIAlertView *v;
        v = [[UIAlertView alloc] initWithTitle:@"Locale"
                                       message:@"Please, set Settings -> General -> International -> Region Format into Russia for reproducing the bug."
                                      delegate:nil
                             cancelButtonTitle:@"Close"
                             otherButtonTitles:nil];
        [v show];
        return;
    }
    
    // 2. include cyrillic and hebrew words into the sample string
    
    NSString *sampleString = @"кириллица и עברית";

    // 3. enable hyphenation
    
    NSMutableParagraphStyle *mPara = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    [mPara setHyphenationFactor:1.0f];
    NSParagraphStyle *para = [mPara copy];
    
    NSAttributedString *attrString;
    attrString = [[NSAttributedString alloc] initWithString:sampleString
                                                 attributes:@{ NSParagraphStyleAttributeName : para }];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attrString];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    // 4. force to hyphenate a word by reducing of text container's width
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:(CGSize){30, 999}];
    
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    
    // 5. run layouting and catch EXC_BAD_ACCESS in _NSGlyphTreeGetCGGlyphsInRange
    
    [layoutManager ensureLayoutForCharacterRange:NSMakeRange(0, attrString.length)];
}


@end
