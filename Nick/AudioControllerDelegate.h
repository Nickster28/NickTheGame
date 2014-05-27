//
//  AudioControllerDelegate.h
//  Nick
//
//  Created by Nick Troccoli on 4/13/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioControllerDelegate <NSObject>
- (void)resumeAudio;
- (void)pauseAudio;
@end
