//
//  MainMenuViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/8/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "MainMenuViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioHandler.h"


@interface MainMenuViewController ()
{
    SystemSoundID _splatSound;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation MainMenuViewController


// Animate in the game sign and play the background music
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareMusic];
    [self animateInGameSign];
    
    // Set ourself as the class variable audio delegate for AudioHandlingViewControllers
    MainMenuViewController * __weak weakSelf = self;
    [AudioHandler setAudioDelegate:weakSelf];
}


// Dispose our AudioServices sound
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AudioServicesDisposeSystemSoundID(_splatSound);
}


- (void)prepareMusic
{
    // Load the background music
    NSString *backgroundSoundPath = [[NSBundle mainBundle] pathForResource:@"nardis"
                                                                    ofType:@"m4a"];
    NSURL *backgroundSoundURL = [NSURL fileURLWithPath:backgroundSoundPath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundSoundURL
                                                              error:nil];
    [self.audioPlayer setNumberOfLoops:-1];
    [self.audioPlayer setVolume:0.4];
    [self.audioPlayer prepareToPlay];
    
    // Load the splat sound
    NSString *splatPath = [[NSBundle mainBundle] pathForResource:@"splat" ofType:@"m4a"];
    NSURL *splatURL = [NSURL fileURLWithPath:splatPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)splatURL, &_splatSound);
}


// Animates in the game sign (shrink) with a sound effect, and starts
// playing background music afterwards.
- (void)animateInGameSign
{
    CGRect bigRect = CGRectMake(55.0, -1.0, 458.0, 322.0);
    CGRect smallRect = CGRectMake(163.0, 97.0, 243.0, 171.0);
    
    // Make the sign invisible initially and set its bounds to the big rectangle (animation will go big->small)
    [self.theGameSign.layer setOpacity:0.0];
    
    MainMenuViewController * __weak weakSelf = self;
    [self.theGameSign.layer setBounds:bigRect];
    
    // Animate the sign in with a sound effect and play the background music
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [weakSelf.theGameSign.layer setOpacity:1.0];
        
        // Make the shrinking animation
        CABasicAnimation *shrinker = [CABasicAnimation animationWithKeyPath:@"bounds"];
        [shrinker setDuration:0.2];
        [shrinker setFromValue:[NSValue valueWithCGRect:bigRect]];
        [shrinker setToValue:[NSValue valueWithCGRect:smallRect]];
        [shrinker setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        // Perform the animation and play the boom sound
        [weakSelf.theGameSign.layer setBounds:smallRect];
        [weakSelf.theGameSign.layer addAnimation:shrinker forKey:@"shrink"];
        [weakSelf playSplatSound];
        
        // Start the background music
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.audioPlayer play];
        });
    });
}


// Splat sound used with permission from http://www.youtube.com/watch?v=rzhjY4ETXdA
- (void)playSplatSound
{
    AudioServicesPlaySystemSound(_splatSound);
}


- (IBAction)viewAllMinigames:(id)sender
{
    // If the user hasn't already completed the game, they can't go to this screen
    if (![[NSUserDefaults standardUserDefaults] boolForKey:NickDidCompleteGameKey]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                     message:@"You must complete the game first to view all of the individual minigames."
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok!"
                                           otherButtonTitles:nil];
        
        [av show];
    } else [self performSegueWithIdentifier:@"viewAllMinigames" sender:sender];
}




// Thanks to http://stackoverflow.com/questions/1216581/avaudioplayer-fade-volume-out
// for help with volume fading recursively
- (void)fadeAudioOut
{
    if (self.audioPlayer.volume > 0.1) {
        self.audioPlayer.volume = self.audioPlayer.volume - 0.1;
        [self performSelector:@selector(fadeAudioOut)
                   withObject:nil
                   afterDelay:0.1];
    } else [self.audioPlayer pause];
}


- (void)fadeAudioIn
{
    if (self.audioPlayer.volume < 0.4) {
        self.audioPlayer.volume = self.audioPlayer.volume + 0.1;
        [self performSelector:@selector(fadeAudioIn)
                   withObject:nil
                   afterDelay:0.2];
    }
}


#pragma mark AudioControllerDelegate methods
- (void)pauseAudio
{
    [self fadeAudioOut];
}


- (void)resumeAudio
{
    [self.audioPlayer play];
    [self fadeAudioIn];
}

@end
