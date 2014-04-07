//
//  newProgressViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "Progress.h"
#import "TimelinePost.h"
#import "User.h"

@protocol updateGoal<NSObject>

//-(void)setGoalPercentage:(double)goalPerc;
-(void)setGoal:(Goal*)updatedGoal;

@end


@interface newProgressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *progressDescription;
@property (weak, nonatomic) IBOutlet UITextField *progressPercenatge;

@property (weak,nonatomic) Goal* currentGoal;

- (IBAction)isSaveisPressed:(UIBarButtonItem *)sender;


@property (retain) id <updateGoal> delegate;
@property (nonatomic,strong) User *currentUser;


@end
