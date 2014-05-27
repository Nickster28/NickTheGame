//
//  MusicMinigameViewController.h
//  Nick
//
//  Created by Nick Troccoli on 4/12/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MusicMinigameViewController : UIViewController

// Key buttons
@property (weak, nonatomic) IBOutlet UIButton *cButton;
@property (weak, nonatomic) IBOutlet UIButton *dbButton;
@property (weak, nonatomic) IBOutlet UIButton *dButton;
@property (weak, nonatomic) IBOutlet UIButton *ebButton;
@property (weak, nonatomic) IBOutlet UIButton *eButton;
@property (weak, nonatomic) IBOutlet UIButton *fButton;
@property (weak, nonatomic) IBOutlet UIButton *gbButton;
@property (weak, nonatomic) IBOutlet UIButton *gButton;
@property (weak, nonatomic) IBOutlet UIButton *abButton;
@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bbButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *cHiButton;
@property (weak, nonatomic) IBOutlet UIButton *dbHiButton;
@property (weak, nonatomic) IBOutlet UIButton *dHiButton;
@property (weak, nonatomic) IBOutlet UIButton *ebHiButton;
@property (weak, nonatomic) IBOutlet UIButton *eHiButton;
@property (weak, nonatomic) IBOutlet UIButton *fHiButton;
@property (weak, nonatomic) IBOutlet UIButton *gbHiButton;


// Key "dots" (for marking the next note a user has to play)
@property (weak, nonatomic) IBOutlet UIImageView *cDot;
@property (weak, nonatomic) IBOutlet UIImageView *dbDot;
@property (weak, nonatomic) IBOutlet UIImageView *dDot;
@property (weak, nonatomic) IBOutlet UIImageView *ebDot;
@property (weak, nonatomic) IBOutlet UIImageView *eDot;
@property (weak, nonatomic) IBOutlet UIImageView *fDot;
@property (weak, nonatomic) IBOutlet UIImageView *gbDot;
@property (weak, nonatomic) IBOutlet UIImageView *gDot;
@property (weak, nonatomic) IBOutlet UIImageView *abDot;
@property (weak, nonatomic) IBOutlet UIImageView *aDot;
@property (weak, nonatomic) IBOutlet UIImageView *bbDot;
@property (weak, nonatomic) IBOutlet UIImageView *bDot;
@property (weak, nonatomic) IBOutlet UIImageView *cHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *dbHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *dHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *ebHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *eHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *fHiDot;
@property (weak, nonatomic) IBOutlet UIImageView *gbHiDot;


// The checkmark image, displayed when the user completes the melody
@property (weak, nonatomic) IBOutlet UIImageView *check;


// When the user presses a key on the keyboard
- (IBAction)keyPressed:(UIButton *)sender;

// When the user releases a key on the keyboard
- (IBAction)keyReleased:(UIButton *)sender;

@end
