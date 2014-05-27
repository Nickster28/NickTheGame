//
//  FadeSegue.m
//  Nick
//
//  Created by Nick Troccoli on 4/13/14.
//  Copyright (c) 2014 Nick. All rights reserved.
//
// Thanks to http://stackoverflow.com/questions/10961926/how-do-i-do-a-fade-no-transition-between-view-controllers
// for how to make a fade transition segue

#import "FadeSegue.h"

@implementation FadeSegue


- (void) perform
{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self.sourceViewController navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:NO];
}


@end
