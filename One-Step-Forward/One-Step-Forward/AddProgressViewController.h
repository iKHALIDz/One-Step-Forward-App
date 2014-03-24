//
//  AddProgressViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/4/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Progress.h"
#import "Goal.h"



@protocol updateGoalPercentage <NSObject>

//-(void)setGoalPercentage:(double)goalPerc;
-(void)setGoal:(Goal*)updatedGoal;

@end

@interface AddProgressViewController : UIViewController

- (IBAction)isDonePressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancelIsPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *progressTextField;

@property (weak, nonatomic) IBOutlet UITextField *progressPercentage;

@property (nonatomic,retain) NSString *currentGoalID;
@property double currentGoalProgressPercentage;

@property (nonatomic,retain) Goal *currentGoal;

@property (retain) id <updateGoalPercentage> delegate;


@end
