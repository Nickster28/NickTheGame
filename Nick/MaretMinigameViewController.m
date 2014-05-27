//
//  MaretMinigameViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "MaretMinigameViewController.h"
#import "AudioHandler.h"

@interface MaretMinigameViewController () <UIDynamicAnimatorDelegate>
{
    // Thanks to http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
    // for help with UIKit Dynamics
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
}
@property (nonatomic, weak) UIImageView *selectedImage;
@property (nonatomic) NSUInteger matches;
@end

@implementation MaretMinigameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AudioHandler pauseAudio];
    self.matches = 0;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self.view];
    
    self.selectedImage = [self getOverlappingHWWithPoint:p];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self.view];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.selectedImage.layer setPosition:p];
    [CATransaction commit];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.selectedImage == self.mathHW) {
        if (CGRectContainsPoint(self.mathCircle.frame, self.selectedImage.layer.position)) {
            [self removeHW:self.selectedImage];
        }
    } else if (self.selectedImage == self.englishHW) {
        if (CGRectContainsPoint(self.englishCircle.frame, self.selectedImage.layer.position)) {
            [self removeHW:self.selectedImage];
        }
    } else if (self.selectedImage == self.scienceHW) {
        if (CGRectContainsPoint(self.scienceCircle.frame, self.selectedImage.layer.position)) {
            [self removeHW:self.selectedImage];
        }
    }
    
    [self setSelectedImage:nil];
}


// Returns the homework image (if any) that overlaps the given point
- (UIImageView *)getOverlappingHWWithPoint:(CGPoint)p
{
    NSArray *hw = @[self.mathHW, self.englishHW, self.scienceHW];
    for (UIImageView *iv in hw) {
        CGRect frame = iv.frame;
        if (CGRectContainsPoint(frame, p)) {
            return iv;
        }
    }
    
    return nil;
}



- (void)removeHW:(UIImageView *)hw
{
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setFromValue:[NSNumber numberWithFloat:1.0]];
    [fade setToValue:[NSNumber numberWithFloat:0.0]];
    [fade setDuration:0.5];
    
    [hw.layer setOpacity:0.0];
    [hw.layer addAnimation:fade forKey:@"fadeHW"];
    self.matches++;
    if (self.matches == 3) [self displayWinScreen];
}



#pragma mark Win Animation
- (void)displayWinScreen
{
    // Create the check mark image
    UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
    [check setFrame:CGRectMake(184.0, 60.0, 200.0, 200.0)];
    [check.layer setOpacity:0.0];
    [self.view addSubview:check];
    
    // Animate in the check mark after a small delay
    MaretMinigameViewController * __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fade setFromValue:[NSNumber numberWithFloat:0.0]];
        [fade setToValue:[NSNumber numberWithFloat:1.0]];
        [fade setDuration:0.5];
        [fade setDelegate:weakSelf];
        [check.layer setOpacity:1.0];
        [check.layer addAnimation:fade
                           forKey:@"fade"];
    });
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
    [gravityView setBackgroundColor:[UIColor colorWithRed:16.0/255.0
                                                    green:184.0/255.0
                                                     blue:58.0/255.0
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
    [self performSegueWithIdentifier:@"winGame3" sender:self];
}
@end
