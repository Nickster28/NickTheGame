//
//  SocialRadarMinigameCollectionViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "SocialRadarMinigameCollectionViewController.h"
#import "AudioHandler.h"
#import "SocialRadarTile.h"


@interface SocialRadarMinigameCollectionViewController () <UIDynamicAnimatorDelegate>
{
    // Thanks to http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
    // for help with UIKit Dynamics
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
}

@property (nonatomic, strong, readonly) NSArray *namesGrid;

// The previously selected tile (if any)
@property (nonatomic) NSIndexPath *selectedTile;

@property (nonatomic) NSUInteger numPairs;

@end

@implementation SocialRadarMinigameCollectionViewController
@synthesize namesGrid = _namesGrid;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [AudioHandler pauseAudio];
    self.numPairs = 0;
}


- (NSArray *)namesGrid
{
    if (!_namesGrid) {
        _namesGrid = @[@[@"Alex", @"Amanda", @"Alex", @"Ben"],
                       @[@"Julia", @"Andrew", @"Ben", @"John"],
                       @[@"Andrew", @"John", @"Amanda", @"Julia"]];
    }
    
    return _namesGrid;
}


// Returns the name to be displayed at the given index path
- (NSString *)nameAtIndexPath:(NSIndexPath *)ip
{
    return [[self.namesGrid objectAtIndex:(ip.row / [self numCols])] objectAtIndex:(ip.row % [self numCols])];
}


- (NSUInteger)numRows
{
    return self.namesGrid.count;
}


- (NSUInteger)numCols
{
    return [[self.namesGrid objectAtIndex:0] count];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.namesGrid.count * [[self.namesGrid objectAtIndex:0] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SocialRadarTile *tile = [collectionView dequeueReusableCellWithReuseIdentifier:@"SocialRadarTile"
                                                                      forIndexPath:indexPath];
    
    // Configure the cell
    [tile bindTileToName:[self nameAtIndexPath:indexPath]];
    
    return tile;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If the user already selected one tile (and this is their second)...
    if (self.selectedTile) {
        
        // If the second tile is the same as the first, do nothing
        if (self.selectedTile.row == indexPath.row) return;
        
        // Get the tiles
        __weak SocialRadarTile *currTile = (SocialRadarTile *)[collectionView cellForItemAtIndexPath:indexPath];
        __weak SocialRadarTile *prevTile = (SocialRadarTile *)[collectionView cellForItemAtIndexPath:self.selectedTile];
        
        // If the selected tile is already flipped, do nothing
        if ([currTile isFlipped]) return;
        
        [currTile flipTileToVisible];
        
        NSString *prevName = [self nameAtIndexPath:self.selectedTile];
        [self setSelectedTile:nil];
        
        // If this tile doesn't have the same name as the previously selected one,
        // flip them both back
        if (![[self nameAtIndexPath:indexPath] isEqualToString:prevName]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [currTile flipTileToHidden];
                [prevTile flipTileToHidden];
            });
            
        // Otherwise, it's a pair!
        } else {
            self.numPairs++;
            
            if (self.numPairs == [self numRows] * [self numCols] / 2) {
                [self displayWinScreen];
            }
        }
        
        
    // Otherwise, this is the first tile the user selected of the two
    } else {
        
        __weak SocialRadarTile *currTile = (SocialRadarTile *)[collectionView cellForItemAtIndexPath:indexPath];

        // If the tile has already been flipped, do nothing
        if ([currTile isFlipped]) return;
        
        // Flip the tile
        [currTile flipTileToVisible];
        [self setSelectedTile:indexPath];
    }
}


- (void)displayWinScreen
{
    // Create the check mark image
    UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
    [check setFrame:CGRectMake(184.0, 60.0, 200.0, 200.0)];
    [check.layer setOpacity:0.0];
    [self.view addSubview:check];
    
    // Animate in the check mark after a small delay
    SocialRadarMinigameCollectionViewController * __weak weakSelf = self;
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
    [gravityView setBackgroundColor:[UIColor colorWithRed:254.0/255.0
                                                    green:112.0/255.0
                                                     blue:21.0/255.0
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
    [self performSegueWithIdentifier:@"winGame4" sender:self];
}


@end
