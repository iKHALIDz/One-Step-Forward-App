//
//  FromAddGoalToListOfGoalsSegue.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "FromAddGoalToListOfGoalsSegue.h"

@implementation FromAddGoalToListOfGoalsSegue


- (void) perform {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    
    [[[[[self sourceViewController] view] window] layer] addAnimation:transition
                                                               forKey:kCATransitionFade];
    
    [[self sourceViewController]
     presentViewController:[self destinationViewController]
     animated:NO completion:NULL];
}

@end
