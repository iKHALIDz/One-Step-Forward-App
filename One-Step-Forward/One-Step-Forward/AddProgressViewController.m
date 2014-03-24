//
//  AddProgressViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/4/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AddProgressViewController.h"

@interface AddProgressViewController ()

@end

@implementation AddProgressViewController

@synthesize currentGoalID;
@synthesize currentGoalProgressPercentage;
@synthesize delegate;
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
    //NSLog(@"Goal ID: %d",currentGoal.goalID);
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)isDonePressed:(UIBarButtonItem *)sender {
    
    Progress *progress=[[Progress alloc]init];
    
    progress.progressDescription=self.progressTextField.text;
    
    //progress.goalID=[currentGoalID integerValue];
    progress.goalID=[currentGoal goalID];
    
    
    progress.LoggedBy=[currentGoal.createdBy integerValue];
    
    int check=[self checkTheEnteredProgress];
    
    if (check==1) // meaning the currentGoalProgress+new progress < 100
    {
        progress.progressPercentageToGoal=[self.progressPercentage.text doubleValue];
        [progress AddProgressltoDatabase];
        
        Goal*goal=currentGoal;
        
        NSLog(@"Steps: %d",goal.goalSteps);
        
        goal.goalSteps=goal.goalSteps+1;
        
        //Goal *goal=[[Goal alloc]init];
        //goal.goalID=[currentGoalID integerValue];
        //goal.goalProgress=currentGoalProgressPercentage;
        
        [goal UpdataGoalWithProgress:[self.progressPercentage.text doubleValue] WithMark:@"+"];
        
        //Update the curent overall goall Progress
        NSString *sum=[NSString stringWithFormat:@"%.2f",[self.progressPercentage.text doubleValue]+goal.goalProgress];
        //[[self delegate]setGoalPercentage:[sum doubleValue]];

        goal.goalProgress=[sum doubleValue];

        [[self delegate]setGoal:goal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (check==0) // meaning the currentGoalProgress+new progress < 100
    {
        progress.progressPercentageToGoal=[self.progressPercentage.text doubleValue];
        [progress AddProgressltoDatabase];
       
        Goal *goal=currentGoal;
        [goal declareGoalAsAchieved];
        
        currentGoal.goalProgress=100.00;
        
        [[self delegate]setGoal:currentGoal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    else if (check==-1) // meaning the new progress is larger than the remaining
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Errot!"
                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoalProgressPercentage]
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

- (IBAction)cancelIsPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(int) checkTheEnteredProgress
{
    
    int X=-1;
    
    //invalid input
    if ([self.progressPercentage.text isEqual:@""])
    {
        
        X=-3;
    }
    
    // curent goal progress + new progress < 100
    else if (currentGoal.goalProgress+[self.progressPercentage.text doubleValue] < 100)
    {
        
        X=1;
    }
    // curent goal progress + new progress = 100
    
    else if (currentGoal.goalProgress+[self.progressPercentage.text doubleValue] == 100)
    {
        X=0;
    }
    
    // invalid input
    else if ([self.progressPercentage.text doubleValue] > 100)
    {
        X=-2;
    }
    
    //NSLog(@"x= %d",X);
    return X;
}



@end
