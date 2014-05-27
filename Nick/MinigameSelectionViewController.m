//
//  MinigameSelectionViewController.m
//  Nick
//
//  Created by Nick Troccoli on 4/8/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import "MinigameSelectionViewController.h"
#import "MinigameCell.h"


@interface MinigameSelectionViewController()
@property (nonatomic, strong, readonly) NSDictionary *gameNamesDictionary;
@end

@implementation MinigameSelectionViewController
@synthesize gameNamesDictionary = _gameNamesDictionary;



- (NSDictionary *)gameNamesDictionary
{
    if (!_gameNamesDictionary) {
        _gameNamesDictionary = @{[NSNumber numberWithInt:0]: @"Of Keys and Keyboards",
                                 [NSNumber numberWithInt:1]: @"Beeper Time",
                                 [NSNumber numberWithInt:2]: @"Get Organized",
                                 [NSNumber numberWithInt:3]: @"A Social Radar"};
    }
    
    return _gameNamesDictionary;
}



// Show the nav bar so the user can get back
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure the nav bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:@"All Minigames"];
}


// Hide the navigation bar
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gameNamesDictionary.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Put the correct minigame image and title in the cell
    MinigameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MinigameCell"
                                                     forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"game%d", indexPath.row];
    [cell.imgView setImage:[UIImage imageNamed:imageName]];
    
    NSString *gameName = [self.gameNamesDictionary objectForKey:[NSNumber numberWithInt:indexPath.row]];
    [cell.gameTitleLabel setText:gameName];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *segueName = [NSString stringWithFormat:@"playGame%d", [indexPath row]];
    [self performSegueWithIdentifier:segueName sender:nil];
}


@end
