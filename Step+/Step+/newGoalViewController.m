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
    BOOL isDate;
    BOOL isReminder;
    
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
    
    self.goalTypes  = [[NSArray alloc] initWithObjects:@"Health",@"Work",@"Travel",@"Fun",@"Learn",@"Money",@"Relatioship",@"Event",@"Spirit",@"Home",nil];
    
    //NSLog(@"%d",self.currentUser.numberOfInProgressGoals);
    //NSLog(@"%d",self.currentUser.numberOfAchievedGoals);
    
    self.saveButton.enabled=NO;
    
    //NSLog(@"66 %d",currentUser.wantsToShare);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseDeadline:(UIButton *)sender
{
    isDate=YES;
    isReminder=NO;
    
    [self.goalNameTextfield resignFirstResponder];
    [self.goalDescriptionTextfield resignFirstResponder];
    
    self.datePicker.hidden=NO;
    self.pickerToolbar.hidden=NO;
    self.goalTypepicker.hidden=YES;

}

- (IBAction)hidepickerView:(UIBarButtonItem *)sender {
    
    if (isDate==NO)
    {
        
        self.goalTypepicker.hidden=YES;
        self.pickerToolbar.hidden=YES;
    }
    
    else if (isDate==YES)
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

- (IBAction)chooseGoalType:(UIButton *)sender {
    
    isDate=NO;
    isReminder=NO;
    
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
    
    if ((self.goalNameTextfield.text.length > 0) &&  (self.goalDescriptionTextfield.text.length > 0) && (self.goalDeadlineTextField.text.length > 0)&& (self.goalTypeTextFiled.text.length > 0))
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
    goal.goalPriority=[self getLargestGoalPriority]+1;
    goal.month=[[self getMonth] integerValue];
    goal.year=[[self getYear]integerValue];
    
    
    [goal AddGoaltoDatabase];
    [goal AddGoalToParse];
    
    
    Progress *progress=[[Progress alloc]init];
    progress.progressDescription=@"New Goal Has Started";
    progress.goalID=goal.goalID;
    progress.LoggedBy=goal.createdBy;
    progress.progressPercentageToGoal=0;
    progress.progressDate=goal.goalDate;
    progress.stepOrder=0;
    progress.progressID=[[self nextIdentifies] integerValue];
    progress.numberOfCommentss=0;
    progress.numberOfLikes=0;
    
    [progress AddProgressltoDatabase];
    [progress AddProgresslToParse];
    
    // Add Post To Timeline
    
    TimelinePost *newPost=[[TimelinePost alloc]init];
    
    newPost.userFirstName=currentUser.userFirsname;
    newPost.userLastName=currentUser.userLastname;
    newPost.username=currentUser.userUsername;
    newPost.userProfilePic=currentUser.userProfileImage;
    
    newPost.PostContent=[NSString stringWithFormat:@"%@ started new goal: %@",currentUser.userFirsname,goal.goalName];
    
    newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",progress.progressID];
    
    newPost.PostType=@"Goal";
    newPost.PostDate=goal.goalDate;
    
    [newPost NewTimelinePost];
    
    currentUser.numberOfInProgressGoals=currentUser.numberOfInProgressGoals+1;
    [currentUser UpdateUserDataDB];
    [currentUser UpdateUserParse];
    
    Log *newLog=[[Log alloc]init];
    
    newLog.userUsername=currentUser.userUsername;
    newLog.logDate=[self getCurrentDataAndTimeForLogging];
    newLog.logContent=[NSString stringWithFormat:@"%@",self.goalNameTextfield.text];
    newLog.logType=@"Goal";
    newLog.logAction=@"Create";
    newLog.month=[[self getMonth] integerValue];
    newLog.year=[[self getYear] integerValue];
    
    [newLog addLOG];
    
    
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
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(NSString *)getCurrentDataAndTimeForLogging
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}



-(NSString *)getMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(NSString *)getYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}


-(IBAction) isCancelisPressed
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

-(int ) getLargestGoalPriority;
{
    int list = 0;
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
      //  NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select MAX(goalpriority) from Goals;"];
    
    //NSLog(@"%@",query);
    
    FMResultSet *result =[db executeQuery:query];
    
    while ([result next])
    {
        list=[result intForColumnIndex:0];
    }
    
    return list;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.pickerToolbar.hidden=YES;
    
    return YES;
}

@end
