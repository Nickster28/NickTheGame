//
//  WinViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "WinViewController.h"
#import "AppDelegate.h"

@interface WinViewController ()

@end

@implementation WinViewController

- (void)goToMainMenu:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NickDidCompleteGameKey];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
