//
//  AudioHandler.h
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//
// Thanks to http://stackoverflow.com/questions/11187530/does-objective-c-support-class-variables
// for help with static variables

#import <Foundation/Foundation.h>
#import "AudioControllerDelegate.h"

@interface AudioHandler : NSObject
+(void)setAudioDelegate:(id<AudioControllerDelegate>)delegate;
+(void)pauseAudio;
+(void)resumeAudio;
@end
