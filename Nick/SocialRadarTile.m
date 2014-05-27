//
//  SocialRadarTile.m
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "SocialRadarTile.h"

@interface SocialRadarTile()
{
    // Thanks to http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
    // for help with UIKit Dynamics
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collisionDown;
    UICollisionBehavior *_collisionUp;
}

@property (nonatomic) BOOL tileIsFlipped;
@property (nonatomic, strong) NSString *name;
@end

@implementation SocialRadarTile

- (void)bindTileToName:(NSString *)name
{
    [self setName:name];
    [self setTileIsFlipped:NO];
    
    [self.nameLabel setText:name];
    
    // Reset the tile back to be visible
    CGRect tileBackFrame = CGRectMake(0.0, 0.0, self.tileBack.frame.size.width, self.tileBack.frame.size.height);
    [self.tileBack setFrame:tileBackFrame];
    
    // The behaviors for showing and hiding the tile back
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[self.tileBack]];
    [_gravity setGravityDirection:CGVectorMake(0.0, -3.0)];

    // Collision at the bottom, for when the tile back slides down
    _collisionDown = [[UICollisionBehavior alloc] initWithItems:@[self.tileBack]];
    [_collisionDown addBoundaryWithIdentifier:@"bottom"
                                    fromPoint:CGPointMake(0.0, 2.0 * self.frame.size.height)
                                      toPoint:CGPointMake(self.frame.size.width, 2.0 * self.frame.size.height)];
    
    // Collision at the top, for when the tile back slides up
    _collisionUp = [[UICollisionBehavior alloc] initWithItems:@[self.tileBack]];
    [_collisionUp addBoundaryWithIdentifier:@"top"
                                  fromPoint:CGPointZero
                                    toPoint:CGPointMake(self.frame.size.width, 0.0)];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collisionUp];
    [_animator addBehavior:_collisionDown];
}



- (void)flipTileToHidden
{
    if (self.tileIsFlipped) {
        [self setTileIsFlipped:NO];
        
        // Flip gravity so the tile slides back up
        [_gravity setGravityDirection:CGVectorMake(0.0, -3.0)];
    }
}



- (void)flipTileToVisible
{
    if (!self.tileIsFlipped) {
        [self setTileIsFlipped:YES];
        
        // Flip gravity so the tile slides down
        [_gravity setGravityDirection:CGVectorMake(0.0, 3.0)];
    }
}


- (BOOL)isFlipped
{
    return self.tileIsFlipped;
}

@end
