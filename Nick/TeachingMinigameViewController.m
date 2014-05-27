//
//  TeachingMinigameViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/13/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "TeachingMinigameViewController.h"
#import "AudioHandler.h"

// The board dimensions
#define NUM_ROWS 5
#define NUM_COLS 6

// The beeper location
#define BEEPER_X 1
#define BEEPER_Y 3

// The size of the board, in points
#define WORLD_WIDTH 376
#define WORLD_HEIGHT 313

// The size of a single square, in points
#define SQUARE_WIDTH WORLD_WIDTH / NUM_COLS
#define SQUARE_HEIGHT WORLD_HEIGHT / NUM_ROWS

// Karel's initial position
#define KAREL_X NUM_COLS - 1
#define KAREL_Y 0


// Thanks to http://stackoverflow.com/questions/707512/what-is-a-typedef-enum-in-objective-c
// for help with enum
typedef enum : NSUInteger {
    East = 0,
    North = 1,
    West = 2,
    South = 3,
    EastRepeat = 4
} Direction;


@interface TeachingMinigameViewController () <UIDynamicAnimatorDelegate>
{
    // Thanks to http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
    // for help with UIKit Dynamics
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
}

// The locations (as grid indices) of karel and the beeper (0 to NUM_ROWS - 1, 0 to NUM_COLS - 1)
@property (nonatomic) CGPoint karelLocation;
@property (nonatomic, readonly) CGPoint beeperlocation;

// The direction Karel is facing
@property (nonatomic) Direction direction;
@end

@implementation TeachingMinigameViewController
@synthesize karelLocation = _karelLocation, direction = _direction;




- (Direction)direction
{
    return _direction;
}


// Turns Karel in the specified direction if that direction is 90 degrees
// away from Karel's current direction
- (void)setDirection:(Direction)direction
{
    // If Karel is turning more than once or isn't turning at all, don't do
    // anything
    NSUInteger diff = direction - _direction;
    if (direction == South && _direction == East) diff = -1;
    else if (direction == East && _direction == South) diff = 1;
    
    if (abs(diff) > 1 || diff == 0) return;
    
    // Thanks to http://stackoverflow.com/questions/3362180/rotating-a-calayer-90-degrees
    // for help with CGAffineTransforms
    self.karelImageView.transform = CGAffineTransformMakeRotation(M_PI_2 * -1 * direction);
    
    _direction = direction;
}



- (CGPoint)karelLocation
{
    return _karelLocation;
}


// Sets Karel's location if the new location is one square distance away
// from Karel's current location
- (void)setKarelLocation:(CGPoint)karelLocation
{
    CGFloat xDiff = karelLocation.x - _karelLocation.x;
    CGFloat yDiff = karelLocation.y - _karelLocation.y;
    
    
    // If Karel is only moving one square, move
    if ((abs(xDiff) == 1 && yDiff == 0) ||
        (xDiff == 0 && abs(yDiff) == 1) ||
        (abs(xDiff) == 1 && abs(yDiff) == 1)) {
                
        CGPoint oldPoint = self.karelView.frame.origin;
        CGPoint newPoint = CGPointMake(oldPoint.x + (xDiff * SQUARE_WIDTH), oldPoint.y - (yDiff * SQUARE_HEIGHT));
        
        CGRect newFrame = CGRectMake(newPoint.x, newPoint.y, self.karelView.frame.size.width, self.karelView.frame.size.height);
        [self.karelView setFrame:newFrame];
        
        
        _karelLocation = karelLocation;
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [AudioHandler pauseAudio];

    // Set Karel's initial direction, location, and the initial beeper location
    [self setDirection:East];
    _karelLocation = CGPointMake(KAREL_X, KAREL_Y);
    _beeperlocation = CGPointMake(BEEPER_X, BEEPER_Y);
    [self checkIfMoveIsPossible];
}


// Moves Karel forward one square in whatever direction he's facing
- (void)move:(id)sender
{
    switch (self.direction) {
        case North:
            [self setKarelLocation:CGPointMake(self.karelLocation.x, self.karelLocation.y + 1)];
            break;
            
        case East:
            [self setKarelLocation:CGPointMake(self.karelLocation.x + 1, self.karelLocation.y)];
            break;
            
        case South:
            [self setKarelLocation:CGPointMake(self.karelLocation.x, self.karelLocation.y - 1)];
            break;
            
        case West:
            [self setKarelLocation:CGPointMake(self.karelLocation.x - 1, self.karelLocation.y)];
            break;
            
        default:
            break;
    }
    
    [self checkIfMoveIsPossible];
    
    // If Karel is on the beeper, remove the beeper and go to the win screen
    if (CGPointEqualToPoint(self.karelLocation, self.beeperlocation)) {
        [self.beeper setHidden:YES];
        [self.turnLeftButton setEnabled:NO];
        [self.moveButton setEnabled:NO];
        [self.karelView setHidden:YES];
        
        // Fade in the check mark
        [self.check.layer setOpacity:0.0];
        [self.check setHidden:NO];
        
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fade setFromValue:[NSNumber numberWithFloat:0.0]];
        [fade setToValue:[NSNumber numberWithFloat:1.0]];
        [fade setDuration:0.5];
        [fade setDelegate:self];
        [self.check.layer setOpacity:1.0];
        [self.check.layer addAnimation:fade
                                forKey:@"fade"];
    }
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
    [gravityView setBackgroundColor:[UIColor colorWithRed:50.0/255.0
                                                    green:125.0/255.0
                                                     blue:36.0/255.0
                                                    alpha:1.0]];
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
    [self performSegueWithIdentifier:@"winGame2" sender:self];
}



// Turns Karel 90 degrees to the left
- (void)turnLeft:(id)sender
{
    Direction newDirection = self.direction + 1;
    if (newDirection == EastRepeat) newDirection = East;
    [self setDirection:newDirection];
    
    [self checkIfMoveIsPossible];
}



// Enables or disables the move button if Karel is facing a wall
- (void)checkIfMoveIsPossible
{
    BOOL isMoveEnabled = TRUE;
    
    // Check if Karel is at the left or right of the grid
    if (self.karelLocation.x == 0) {
        if (self.direction == West) isMoveEnabled = FALSE;
    } else if (self.karelLocation.x == NUM_COLS - 1) {
        if (self.direction == East) isMoveEnabled = FALSE;
    }
    
    
    // Check if Karel is at the top or bottom of the grid
    if (self.karelLocation.y == 0) {
        if (self.direction == South) isMoveEnabled = FALSE;
    } else if (self.karelLocation.y == NUM_ROWS - 1) {
        if (self.direction == North) isMoveEnabled = FALSE;
    }
    
    [self.moveButton setEnabled:isMoveEnabled];
}



@end
