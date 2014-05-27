//
//  MainMenuViewController.h
//  Nick
//
//  Created by Nick Troccoli on 4/8/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioControllerDelegate.h"


@interface MainMenuViewController : UIViewController <AudioControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *theGameSign;

- (IBAction)viewAllMinigames:(id)sender;

@end

