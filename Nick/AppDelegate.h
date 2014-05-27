//
//  AppDelegate.h
//  Nick
//
//  Created by Nick Troccoli on 4/8/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

// The NSUserDefaults key for tracking if the user has completed the game
extern NSString * const NickDidCompleteGameKey;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@end
