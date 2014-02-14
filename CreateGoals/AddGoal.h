//
//  AddGoal.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>



@interface AddGoal : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *goalNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *goalDescriptionTextField;



@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;


- (IBAction)PickADeadlineDate:(UIButton *)sender;


@property(nonatomic, strong) NSDateFormatter *dateFormatter;


@property(nonatomic, strong) NSString *DeadlineLabelText;


@end

