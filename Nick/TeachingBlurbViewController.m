//
//  TeachingBlurbViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "TeachingBlurbViewController.h"
#import "AudioHandler.h"



@implementation TeachingBlurbViewController

// Depending on how we were presented (modally - the user went through the all minigames screen)
// or not (the user is playing through all the games) transition to the appropriate place.
- (IBAction)continueToNextGame:(id)sender
{
    if ([self presentingViewController]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"goToGame3" sender:sender];
    }
}

// Resume the audio
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AudioHandler resumeAudio];
}

@end
