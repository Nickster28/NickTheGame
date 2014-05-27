//
//  AboutViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/9/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

// Pops our view controller off and goes back to the main menu
- (IBAction)backToMainMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
