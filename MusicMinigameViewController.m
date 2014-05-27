//
//  MusicMinigameViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/12/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "MusicMinigameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioHandler.h"

#define ALL_NOTES_PLAYED -1


@interface MusicMinigameViewController () <UIDynamicAnimatorDelegate, AVAudioPlayerDelegate>
{
    SystemSoundID _ogdsSound; // The recording of "On Green Dolphin Street"
    
    // Thanks to http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
    // for help with UIKit Dynamics
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

// The notes the user has to play
@property (nonatomic, strong, readonly) NSArray *notes;


// Thanks to http://stackoverflow.com/questions/2820366/nsmutabledictionary-with-uibutton-as-keys-iphone-development
// for recommending -[NSValue valueWithNonretainedObject] to have the UIButton *s as keys

// A dictionary from UIButton *s to strings of notes (eg. "Ab")
@property (nonatomic, strong) NSDictionary *keysToNotesMap;

// A dictionary from UIButton *s to the button's corresponding "dot" (for showing the user what to play next)
@property (nonatomic, strong) NSDictionary *keysToDotsMap;

// A dictionary from strings of notes (eg. "Ab") to UIButton *s for each note
@property (nonatomic, strong) NSDictionary *notesToKeysMap;

// The dot that is currently displayed
@property (nonatomic, weak) UIImageView *currentDot;

// The index of the required note that the user is on
@property (nonatomic) NSUInteger currentNoteIndex;

@end

@implementation MusicMinigameViewController
@synthesize notes = _notes, keysToDotsMap = _keysToDotsMap, keysToNotesMap = _keysToNotesMap, notesToKeysMap = _notesToKeysMap, currentDot = _currentDot;



- (NSArray *)notes
{
    if (!_notes) {
        _notes = @[@"Chi", @"Chi", @"B", @"G", @"E", @"Bb"];
    }
    
    return _notes;
}



- (void)setKeysToDotsMap:(NSDictionary *)keysToDotsMap
{
    _keysToDotsMap = keysToDotsMap;
}


- (NSDictionary *)keysToDotsMap
{
    if (!_keysToDotsMap) {
        _keysToDotsMap = @{[NSValue valueWithNonretainedObject:self.cButton]: [NSValue valueWithNonretainedObject:self.cDot],
                           [NSValue valueWithNonretainedObject:self.dbButton]: [NSValue valueWithNonretainedObject:self.dbDot],
                           [NSValue valueWithNonretainedObject:self.dButton]: [NSValue valueWithNonretainedObject:self.dDot],
                           [NSValue valueWithNonretainedObject:self.ebButton]: [NSValue valueWithNonretainedObject:self.ebDot],
                           [NSValue valueWithNonretainedObject:self.eButton]: [NSValue valueWithNonretainedObject:self.eDot],
                           [NSValue valueWithNonretainedObject:self.fButton]: [NSValue valueWithNonretainedObject:self.fDot],
                           [NSValue valueWithNonretainedObject:self.gbButton]: [NSValue valueWithNonretainedObject:self.gbDot],
                           [NSValue valueWithNonretainedObject:self.gButton]: [NSValue valueWithNonretainedObject:self.gDot],
                           [NSValue valueWithNonretainedObject:self.abButton]: [NSValue valueWithNonretainedObject:self.abDot],
                           [NSValue valueWithNonretainedObject:self.aButton]: [NSValue valueWithNonretainedObject:self.aDot],
                           [NSValue valueWithNonretainedObject:self.bbButton]: [NSValue valueWithNonretainedObject:self.bbDot],
                           [NSValue valueWithNonretainedObject:self.bButton]: [NSValue valueWithNonretainedObject:self.bDot],
                           [NSValue valueWithNonretainedObject:self.cHiButton]: [NSValue valueWithNonretainedObject:self.cHiDot],
                           [NSValue valueWithNonretainedObject:self.dbHiButton]: [NSValue valueWithNonretainedObject:self.dbHiDot],
                           [NSValue valueWithNonretainedObject:self.dHiButton]: [NSValue valueWithNonretainedObject:self.dHiDot],
                           [NSValue valueWithNonretainedObject:self.ebHiButton]: [NSValue valueWithNonretainedObject:self.ebHiDot],
                           [NSValue valueWithNonretainedObject:self.eHiButton]: [NSValue valueWithNonretainedObject:self.eHiDot],
                           [NSValue valueWithNonretainedObject:self.fHiButton]: [NSValue valueWithNonretainedObject:self.fHiDot],
                           [NSValue valueWithNonretainedObject:self.gbHiButton]: [NSValue valueWithNonretainedObject:self.gbHiDot]};
    }
    
    return _keysToDotsMap;
}


- (void)setKeysToNotesMap:(NSDictionary *)keysToNotesMap
{
    _keysToNotesMap = keysToNotesMap;
}


- (NSDictionary *)keysToNotesMap
{
    if (!_keysToNotesMap) {
        _keysToNotesMap = @{[NSValue valueWithNonretainedObject:self.cButton]: @"C",
                            [NSValue valueWithNonretainedObject:self.dbButton]: @"Db",
                            [NSValue valueWithNonretainedObject:self.dButton]: @"D",
                            [NSValue valueWithNonretainedObject:self.ebButton]: @"Eb",
                            [NSValue valueWithNonretainedObject:self.eButton]: @"E",
                            [NSValue valueWithNonretainedObject:self.fButton]: @"F",
                            [NSValue valueWithNonretainedObject:self.gbButton]: @"Gb",
                            [NSValue valueWithNonretainedObject:self.gButton]: @"G",
                            [NSValue valueWithNonretainedObject:self.abButton]: @"Ab",
                            [NSValue valueWithNonretainedObject:self.aButton]: @"A",
                            [NSValue valueWithNonretainedObject:self.bbButton]: @"Bb",
                            [NSValue valueWithNonretainedObject:self.bButton]: @"B",
                            [NSValue valueWithNonretainedObject:self.cHiButton]: @"Chi",
                            [NSValue valueWithNonretainedObject:self.dbHiButton]: @"Dbhi",
                            [NSValue valueWithNonretainedObject:self.dHiButton]: @"Dhi",
                            [NSValue valueWithNonretainedObject:self.ebHiButton]: @"Ebhi",
                            [NSValue valueWithNonretainedObject:self.eHiButton]: @"Ehi",
                            [NSValue valueWithNonretainedObject:self.fHiButton]: @"Fhi",
                            [NSValue valueWithNonretainedObject:self.gbHiButton]: @"Gbhi"};
    }
    
    return _keysToNotesMap;
}


- (void)setNotesToKeysMap:(NSDictionary *)notesToKeysMap
{
    _notesToKeysMap = notesToKeysMap;
}


- (NSDictionary *)notesToKeysMap
{
    if (!_notesToKeysMap) {
        _notesToKeysMap = @{@"C": [NSValue valueWithNonretainedObject:self.cButton],
                            @"Db": [NSValue valueWithNonretainedObject:self.dbButton],
                            @"D": [NSValue valueWithNonretainedObject:self.dButton],
                            @"Eb": [NSValue valueWithNonretainedObject:self.ebButton],
                            @"E": [NSValue valueWithNonretainedObject:self.eButton],
                            @"F": [NSValue valueWithNonretainedObject:self.fButton],
                            @"Gb": [NSValue valueWithNonretainedObject:self.gbButton],
                            @"G": [NSValue valueWithNonretainedObject:self.gButton],
                            @"Ab": [NSValue valueWithNonretainedObject:self.abButton],
                            @"A": [NSValue valueWithNonretainedObject:self.aButton],
                            @"Bb": [NSValue valueWithNonretainedObject:self.bbButton],
                            @"B": [NSValue valueWithNonretainedObject:self.bButton],
                            @"Chi": [NSValue valueWithNonretainedObject:self.cHiButton],
                            @"Dbhi": [NSValue valueWithNonretainedObject:self.dbHiButton],
                            @"Dhi": [NSValue valueWithNonretainedObject:self.dHiButton],
                            @"Ebhi": [NSValue valueWithNonretainedObject:self.ebHiButton],
                            @"Ehi": [NSValue valueWithNonretainedObject:self.eHiButton],
                            @"Fhi": [NSValue valueWithNonretainedObject:self.fHiButton],
                            @"Gbhi": [NSValue valueWithNonretainedObject:self.gbHiButton]};
    }
    
    return _notesToKeysMap;
}



- (UIImageView *)currentDot
{
    return _currentDot;
}


- (void)setCurrentDot:(UIImageView *)currentDot
{
    // Hide the old dot
    if (_currentDot) {
        [_currentDot setHidden:YES];
    }
    
    // Unhide the new dot
    _currentDot = currentDot;
    [_currentDot setHidden:NO];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fade out the game music
    [AudioHandler pauseAudio];
    
    // Display the first dot
    self.currentNoteIndex = 0;
    [self setCurrentDot:[self dotForNote:[self.notes objectAtIndex:self.currentNoteIndex]]];
}



// Returns the imageview for the dot on the given note (eg. "Ab")
- (UIImageView *)dotForNote:(NSString *)note
{
    UIButton *currKey = [self.notesToKeysMap[note] nonretainedObjectValue];
    UIImageView *currDot = [self.keysToDotsMap[[NSValue valueWithNonretainedObject:currKey]] nonretainedObjectValue];
    
    return currDot;
}



// Key sounds from http://theremin.music.uiowa.edu/MISpiano.html
// Thanks to http://code.tutsplus.com/tutorials/ios-sdk_playing-systemsoundid--mobile-5579
// for suggesting using touchDown
- (IBAction)keyPressed:(UIButton *)sender
{
    // If the user still has notes to play, let them play
    if (self.currentNoteIndex != ALL_NOTES_PLAYED) {
        self.audioPlayer = [self audioPlayerWithSoundForButton:sender];
        [self.audioPlayer setVolume:1.0];
        [self.audioPlayer play];
        
        [sender setBackgroundColor:[UIColor grayColor]];
        
        // If the user tapped the right note...
        if ([self.keysToDotsMap[[NSValue valueWithNonretainedObject:sender]] nonretainedObjectValue] == self.currentDot) {
            
            // If there are no more notes left, the user won
            if (self.currentNoteIndex == self.notes.count - 1) {
                
                self.currentNoteIndex++;
                [self setCurrentDot:nil];
                
                [self displayCorrectAnswer];
                
                // Otherwise, display the next dot
            } else {
                NSString *nextNote = [self.notes objectAtIndex:++self.currentNoteIndex];
                [self setCurrentDot:[self dotForNote:nextNote]];
            }
        }
    }
    
}


- (AVAudioPlayer *)audioPlayerWithSoundForButton:(UIButton *)button
{
    // Load the key sound depending on which key was pressed
    NSString *resourceName = self.keysToNotesMap[[NSValue valueWithNonretainedObject:button]];
    
    // Create the AVAudioPlayer for the given sound
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:resourceName
                                                          ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    return [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL
                                                  error:nil];
}



// Triggered when the user ends a tap on one of the piano keys
- (IBAction)keyReleased:(UIButton *)sender
{
    // If the user still has notes to play, let them play
    if (self.currentNoteIndex != ALL_NOTES_PLAYED) {
        [self fadeVolume];
        [sender setBackgroundColor:nil];
        if (self.currentNoteIndex == self.notes.count) self.currentNoteIndex = ALL_NOTES_PLAYED;
    }
}


// Thanks to http://stackoverflow.com/questions/1216581/avaudioplayer-fade-volume-out
// for help with volume fading recursively
- (void)fadeVolume
{
    if (self.audioPlayer.volume > 0.1) {
        self.audioPlayer.volume = self.audioPlayer.volume - 0.1;
        [self performSelector:@selector(fadeVolume)
                   withObject:nil
                   afterDelay:0.1];
    } else [self.audioPlayer stop];
}



// Plays the On Green Dolphin Street melody
- (void)displayCorrectAnswer
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ogds" ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_ogdsSound);
    
    // Register our helper function (below) to execute once the sound is done playing
    MusicMinigameViewController * __weak weakSelf = self;
    AudioServicesAddSystemSoundCompletion(_ogdsSound, NULL, NULL, musicDidFinishPlaying, (__bridge void *)(weakSelf));
    AudioServicesPlaySystemSound(_ogdsSound);
}


// A helper function that's triggered once On Green Dolphin Street finishes playing
void musicDidFinishPlaying(SystemSoundID ssID, void *clientData)
{
    MusicMinigameViewController *weakSelf = (__bridge MusicMinigameViewController *)clientData;
    
    // Fade in the check mark
    [weakSelf.check.layer setOpacity:0.0];
    [weakSelf.check setHidden:NO];
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setFromValue:[NSNumber numberWithFloat:0.0]];
    [fade setToValue:[NSNumber numberWithFloat:1.0]];
    [fade setDuration:0.5];
    [fade setDelegate:weakSelf];
    [weakSelf.check.layer setOpacity:1.0];
    [weakSelf.check.layer addAnimation:fade
                                forKey:@"fade"];
}


// Display the results screen after the checkmark appears
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self performSelector:@selector(displayResultsScreen)
               withObject:nil
               afterDelay:0.5];
}



// Displays the win screen for the game by animating a view down on top of the screen and then
// transitioning to the next screen
- (void)displayResultsScreen
{
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Make the view that will "thump" down over the screen
    UIView *gravityView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -380.0, 568.0, 380.0)];
    [gravityView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:gravityView];
    
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[gravityView]];
    _collision = [[UICollisionBehavior alloc] initWithItems:@[gravityView]];
    [_collision setTranslatesReferenceBoundsIntoBoundary:NO];
    [_collision addBoundaryWithIdentifier:@"bottom"
                                fromPoint:CGPointMake(0.0, 321.0)
                                  toPoint:CGPointMake(568.0, 321.0)];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    [_animator setDelegate:self];
}


// When the view slides down, fade into the next screen
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self performSegueWithIdentifier:@"winGame1" sender:self];
}

@end
