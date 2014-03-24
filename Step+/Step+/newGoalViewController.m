//
//  newGoalViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "newGoalViewController.h"

@interface newGoalViewController ()
{
    
    Goal *goal;
}

@end


@implementation newGoalViewController

@synthesize goalTypes;
@synthesize currentUser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *today=[NSDate date];
    [self.datePicker setDate:today animated:YES];
    self.datePicker.hidden=YES;
    self.pickerToolbar.hidden=YES;
    self.goalTypepicker.hidden=YES;
    
    self.goalTypes  = [[NSArray alloc]         initWithObjects:@"Health",@"Work",@"Travel",@"Fun",@"Learn",@"Money",@"Relatioship",@"Event",@"Spirit",@"Home",nil];
    
    self.saveButton.enabled=NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)chooseDeadline:(UIButton *)sender
{
    [self.goalNameTextfield resignFirstResponder];
     [self.goalDescriptionTextfield resignFirstResponder];
    
    self.datePicker.hidden=NO;
    self.pickerToolbar.hidden=NO;
    
}
- (IBAction)hidepickerView:(UIBarButtonItem *)sender {
    
    
    self.goalTypepicker.hidden=YES;
    
    NSDate *selectedDate=[self.datePicker date];
    
    BOOL correctDate=[self compareBetweenTwoDates:selectedDate];
    
    
    if (correctDate==YES )
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        
        NSString *currentData= [dateFormatter stringFromDate:selectedDate];
        
        self.goalDeadlineTextField.text=currentData;
        self.datePicker.hidden=YES;
        self.pickerToolbar.hidden=YES;
    }
    
    else
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"The selected date is invaid"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];

    }
}


- (IBAction)chooseGoalType:(UIButton *)sender {
    
    [self.goalNameTextfield resignFirstResponder];
     [self.goalDescriptionTextfield resignFirstResponder];
   
    self.goalTypepicker.hidden=NO;
    self.pickerToolbar.hidden=NO;
    self.datePicker.hidden=YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    
    return 10;
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    return [self.goalTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    self.goalTypeTextFiled.text=[self.goalTypes objectAtIndex:row];
}

-(IBAction)editingChanged
{
    // make sure all fields are have something in them
    
    if ((self.goalNameTextfield.text.length > 0) &&  (self.goalDescriptionTextfield.text.length > 0) && ( self.goalDeadlineTextField.text.length > 0)&& (self.goalTypeTextFiled.text.length > 0))
    {
        self.saveButton.enabled=YES;
    }
    
    else
    {
        self.saveButton.enabled=NO;
    }
}


- (IBAction)isSavePressed:(UIBarButtonItem *)sender {
    
    
    
    goal=[[Goal alloc]init];
    goal.goalID=[[self nextIdentifies] integerValue];
    goal.createdBy=currentUser.userUsername;
    goal.goalName=self.goalNameTextfield.text;
    goal.goalDescription=self.goalDescriptionTextfield.text;
    goal.goalDeadline=self.goalDeadlineTextField.text;
    goal.isGoalCompleted=0;
    goal.isGoalinProgress=1;
    goal.goalProgress=0.0;
    goal.goalType=self.goalTypeTextFiled.text;
    goal.goalDate=[self getCurrentDataAndTime];
    
    [goal AddGoaltoDatabase];
    [goal AddGoalToParse];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSString *)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    return [NSString stringWithFormat:@"%ld",(long)identifier];
}
            

-(BOOL) compareBetweenTwoDates:(NSDate*) pickerDate
{
    BOOL isSelectedData=YES;
    
    NSDate *today = [NSDate date];
    
    
    NSComparisonResult compareResult = [today compare:pickerDate];
    
    if (compareResult == NSOrderedAscending)
    {
        isSelectedData=YES;
    }
    else if (compareResult == NSOrderedDescending)
    {
        isSelectedData=NO;
    }
    
    else
        isSelectedData=YES;
    
    return isSelectedData;
}

-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}



@end
