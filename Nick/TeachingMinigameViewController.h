//
//  TeachingMinigameViewController.h
//  Nick
//
//  Created by Nick Troccoli on 4/13/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachingMinigameViewController : UIViewController


/** There are 2 Karel views - this is because I use the outer view to move
 * and the inner image view to rotate.  That way I don't run into issues with
 * rotating and moving the same view
 */
// The Karel image view (inside of the Karel view)
@property (nonatomic, weak) IBOutlet UIImageView *karelImageView;

// The Karel view (containing the Karel image view)
@property (nonatomic, weak) IBOutlet UIView *karelView;

@property (nonatomic, weak) IBOutlet UIImageView *beeper;
@property (nonatomic, weak) IBOutlet UIButton *moveButton;
@property (nonatomic, weak) IBOutlet UIImageView *check;
@property (nonatomic, weak) IBOutlet UIButton *turnLeftButton;

// The move and turn left button actions
- (IBAction)move:(id)sender;
- (IBAction)turnLeft:(id)sender;

@end
