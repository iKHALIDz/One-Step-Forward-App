//
//  newProgressViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "newProgressViewController.h"

@interface newProgressViewController ()

@end

@implementation newProgressViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(int) checkTheEnteredProgress
{
    
    int X=-1;
    
    //invalid input
    if ([self.progressPercenatge.text isEqual:@""])
    {
        
        X=-3;
    }
    
    // curent goal progress + new progress < 100
    else if (self.currentGoal.goalProgress+[self.progressPercenatge.text doubleValue] < 100)
    {
        
        X=1;
    }
    // curent goal progress + new progress = 100
    
    else if (self.currentGoal.goalProgress+[self.progressPercenatge.text doubleValue] == 100)
    {
        X=0;
    }
    
    // invalid input
    else if ([self.progressPercenatge.text doubleValue] > 100)
    {
        X=-2;
    }
    
    return X;
}

-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
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



- (IBAction)isSaveisPressed:(UIBarButtonItem *)sender {
    
    Progress *progress=[[Progress alloc]init];
    progress.progressDescription=self.progressDescription.text;
    progress.goalID=self.currentGoal.goalID;
    progress.LoggedBy=self.currentGoal.createdBy;
    
    
    int check=[self checkTheEnteredProgress];
    
    if (check==1) // meaning the currentGoalProgress+new progress < 100
    {
        progress.progressPercentageToGoal=[self.progressPercenatge.text doubleValue];
        progress.progressDate=[self getCurrentDataAndTime];
        progress.stepOrder=self.currentGoal.numberOfGoalSteps+1;
        progress.progressID=[[self nextIdentifies] integerValue];
        
        [progress AddProgressltoDatabase];
        [progress AddProgresslToParse];
        
        
        Goal*goal=currentGoal;
        Goal*parseGoal=currentGoal;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        
        [goal UpdataGoalWithProgress:[self.progressPercenatge.text doubleValue] WithMark:@"+"];
        [parseGoal UpdataGoalWithProgressInParse:[self.progressPercenatge.text doubleValue] WithMark:@"+"];

        
        NSString *sum=[NSString stringWithFormat:@"%.2f",[self.progressPercenatge.text doubleValue]+goal.goalProgress];
        goal.goalProgress=[sum doubleValue];
        
        [[self delegate]setGoal:goal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (check==0) // meaning the currentGoalProgress+new progress = 100
    {
        progress.progressPercentageToGoal=[self.progressPercenatge.text doubleValue];
        
        progress.progressDate=[self getCurrentDataAndTime];
        progress.progressID=[[self nextIdentifies] integerValue];
        progress.stepOrder=self.currentGoal.numberOfGoalSteps+1;
        progress.progressID=[[self nextIdentifies] integerValue];
        
        [progress AddProgressltoDatabase];
        
        Goal *goal=currentGoal;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        [goal declareGoalAsAchieved];
        [goal declareGoalAsAchievedinParse];
        
        currentGoal.goalProgress=100.00;
        
        [[self delegate]setGoal:currentGoal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (check==-1) // meaning the new progress is larger than the remaining
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Errot!"
                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoal.goalProgress]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        
        [message show];
    }
    
    
    else if (check==-2 || check==-3) //invalid
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"Invalid Input"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        
        [message show];
        
    }
}

@end
