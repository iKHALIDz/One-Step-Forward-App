//
//  EditGoalViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/15/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "User.h"
#import "TimelinePost.h"
#import "FMDatabase.h"
#import <Parse/Parse.h>
#import "Progress.h"

@interface EditGoalViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;

@property (weak, nonatomic) IBOutlet UITextField *goalNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *goalDescriptionTextfield;

@property (weak, nonatomic) IBOutlet UITextField *goalTypeTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *goalDeadlineTextField;

- (IBAction)isSavePressed:(UIBarButtonItem *)sender;

@property (retain,nonatomic) NSArray *goalTypes;

@property (weak, nonatomic) IBOutlet UIPickerView *goalTypepicker;

@property (nonatomic,strong) User *currentUser;

-(IBAction)editingChanged;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

-(IBAction) isCancelisPressed;

@property (retain,nonatomic) Goal *currentGoal;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *isDoneisPressed1;
@property (weak, nonatomic) IBOutlet UIImageView *ik;

@end
