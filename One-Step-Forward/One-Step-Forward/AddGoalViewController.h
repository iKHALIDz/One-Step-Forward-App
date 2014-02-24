//
//  AddGoalViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CalenderViewController.h"



@interface AddGoalViewController : UIViewController <passDate>

@property (weak, nonatomic) IBOutlet UITextField *goalName;

@property (weak, nonatomic) IBOutlet UITextField *goalDesc;

- (IBAction)isSavePressed:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;


- (IBAction)PickADeadlineDate:(UIButton *)sender;

@property(nonatomic, strong) NSString *DeadlineLabelText;


@property (nonatomic, strong) NSString *goalID;

-(void)nextIdentifies;





@end
