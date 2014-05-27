//
//  AudioHandler.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "AudioHandler.h"

// Keep one audio delegate as a class variable so it can be accessed from anywhere
static id<AudioControllerDelegate> audioDelegate;

@implementation AudioHandler

+(void)setAudioDelegate:(id<AudioControllerDelegate>)delegate
{
    audioDelegate = delegate;
}


+(void)pauseAudio
{
    [audioDelegate pauseAudio];
}


+(void)resumeAudio
{
    [audioDelegate resumeAudio];
}

@end
