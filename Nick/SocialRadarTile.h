//
//  SocialRadarTile.h
//  Nick
//
//  Created by Nick Troccoli on 4/14/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialRadarTile : UICollectionViewCell


// The image view covering the name label that displays the back of the card
@property (nonatomic, weak) IBOutlet UIImageView *tileBack;

// The label underneath the image view displaying the tile name
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;


// Initializes the cell with the given name and sets the cell as 
- (void)bindTileToName:(NSString *)name;


// Flip the tile
- (void)flipTileToHidden;
- (void)flipTileToVisible;

- (BOOL)isFlipped;

@end
