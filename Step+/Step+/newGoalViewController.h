//
//  newGoalViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "User.h"
#import "TimelinePost.h"
#import "FMDatabase.h"
#import <Parse/Parse.h>
#import "Progress.h"
#import "Log.h"
#import "InProgressGoalsViewController.h"

@interface newGoalViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)chooseDeadline:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *pickerToolbar;

- (IBAction)hidepickerView:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *goalNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *goalDescriptionTextfield;

@property (weak, nonatomic) IBOutlet UITextField *goalTypeTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *goalDeadlineTextField;

- (IBAction)isSavePressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *goalTypepicker;

@property (retain,nonatomic) NSArray *goalTypes;

@property (nonatomic,strong) User *currentUser;

-(IBAction)editingChanged;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

-(IBAction) isCancelisPressed;

@end
