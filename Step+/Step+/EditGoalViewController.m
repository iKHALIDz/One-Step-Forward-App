//
//  EditGoalViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/15/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "EditGoalViewController.h"

@interface EditGoalViewController ()
{
    
    Goal *goal;
    BOOL isDate;
    
}

@end

@implementation EditGoalViewController

@synthesize goalTypes;
@synthesize currentUser;
@synthesize currentGoal;


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
    
    self.goalTypes  = [[NSArray alloc] initWithObjects:@"Health",@"Work",@"Travel",@"Fun",@"Learn",@"Money",@"Relatioship",@"Event",@"Spirit",@"Home",nil];
    
    self.goalNameTextfield.text=currentGoal.goalName;
    self.goalDescriptionTextfield.text=currentGoal.goalDescription;
    self.goalDeadlineTextField.text=currentGoal.goalDeadline;
    self.goalTypeTextFiled.text=currentGoal.goalType;
    
    self.ik.image=currentUser.userProfileImage;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseDeadline:(UIButton *)sender
{
    isDate=YES;
    [self.goalNameTextfield resignFirstResponder];
    [self.goalDescriptionTextfield resignFirstResponder];
    
    self.datePicker.hidden=NO;
    self.pickerToolbar.hidden=NO;
    self.goalTypepicker.hidden=YES;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *dateFromString = [[NSDate alloc]init];
    
    dateFromString = [dateFormatter dateFromString:currentGoal.goalDeadline];
    
  //  NSLog(@"%@",[dateFromString description]);
    
    if (dateFromString == nil) {
        dateFromString = [NSDate date];
    }
    
    [self.datePicker setDate:dateFromString];
    
}

- (IBAction)chooseGoalType:(UIButton *)sender {
    
    isDate=NO;
    
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


- (IBAction)hidepickerView:(UIBarButtonItem *)sender {

    if (isDate==NO) {
        self.goalTypepicker.hidden=YES;
        self.pickerToolbar.hidden=YES;
    }
    
    else
    {
        
    
    NSDate *selectedDate=[self.datePicker date];
    
    BOOL correctDate=[self compareBetweenTwoDates:selectedDate];
    
    
    if (correctDate==YES )
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        NSString *currentData= [dateFormatter stringFromDate:selectedDate];
        
        self.goalDeadlineTextField.text=currentData;
        self.datePicker.hidden=YES;
        currentGoal.goalDeadline=currentData;
        
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
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}


-(IBAction) isCancelisPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)isSavePressed:(UIBarButtonItem *)sender
{
    currentGoal.goalType=self.goalTypeTextFiled.text;
    currentGoal.goalName=self.goalNameTextfield.text;
    currentGoal.goalDescription=self.goalDescriptionTextfield.text;
    currentGoal.goalDeadline=self.goalDeadlineTextField.text;
    
    [currentGoal UpdateGoalDB];
    [currentGoal UpdateGoalParse];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(IBAction)editingChanged
{
    // make sure all fields are have something in them
    
    if ((self.goalNameTextfield.text.length > 0) &&  (self.goalDescriptionTextfield.text.length > 0) && (self.goalDeadlineTextField.text.length > 0)&& (self.goalTypeTextFiled.text.length > 0))
    {
        self.saveButton.enabled=YES;
    }
    else
    {
        self.saveButton.enabled=NO;
    }
}

@end
