//
//  MangeProgressViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "Progress.h"
#import "Goal.h"


@protocol updateGoalPercentage2 <NSObject>

-(void)setGoalPercentage2:(double)goalPerc;

@end

@interface MangeProgressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *progressDescriptionTextField;

@property (weak, nonatomic) IBOutlet UITextField *progressPersntageTextField;


- (IBAction)deleteProgress:(UIButton *)sender;

- (IBAction)cancel:(UIBarButtonItem *)sender;

- (IBAction)saveChanges:(UIBarButtonItem *)sender;


@property (nonatomic,strong) Progress *currentProgress;

@property double currentGoalProgressPercentage;

@property (retain) id <updateGoalPercentage2> delegate;

@end
