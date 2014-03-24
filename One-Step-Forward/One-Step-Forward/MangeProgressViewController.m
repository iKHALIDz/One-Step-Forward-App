//
//  MangeProgressViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MangeProgressViewController.h"

@interface MangeProgressViewController ()

@end


@implementation MangeProgressViewController



@synthesize currentProgress;
@synthesize currentGoalProgressPercentage;
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
    
    //    NSLog(@"%d",currentProgress.progressID);
    //
    //
    //    NSLog(@"%d",currentProgress.goalID);
    
    NSLog(@"Selected Progress %f",currentProgress.progressPercentageToGoal);
    NSLog(@"Ovarall Progress %f",currentGoal.goalProgress);
    
    self.progressDescriptionTextField.text=self.currentProgress.progressDescription;
    self.progressPersntageTextField.text=[NSString stringWithFormat:@"%.2f",self.currentProgress.progressPercentageToGoal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)deleteProgress:(UIButton *)sender {
    
    
    [currentProgress DeleteProgressFromDatabase];
    
    Goal *goal=currentGoal;
    goal.goalSteps=goal.goalSteps-1;
    
    [goal UpdataGoalWithProgress:currentProgress.progressPercentageToGoal WithMark:@"-"];
    
    goal.goalProgress=goal.goalProgress-currentProgress.progressPercentageToGoal;
    [[self delegate]setGoal:goal];


    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveChanges:(UIBarButtonItem *)sender {
    
    Progress *progress=[[Progress alloc]init];
    
    progress.progressDescription=self.progressDescriptionTextField.text;
    progress.progressID=currentProgress.progressID;
    progress.goalID=currentProgress.goalID;

    int check = [self checkTheEnteredProgress];
    
    if (check==1) // meaning the currentGoalProgress+new progress < 100
    {
        progress.progressPercentageToGoal=[self.progressPersntageTextField.text doubleValue];
        [progress UpdateProgress];

        Goal *goal=currentGoal;
        
        [goal UpdataGoalWithProgress:currentProgress.progressPercentageToGoal WithMark:@"-"];
        goal.goalProgress=goal.goalProgress-currentProgress.progressPercentageToGoal;

        [goal UpdataGoalWithProgress:[self.progressPersntageTextField.text doubleValue] WithMark:@"+"];
        
        NSString *sum=[NSString stringWithFormat:@"%.2f",goal.goalProgress+[self.progressPersntageTextField.text doubleValue]];
        
        goal.goalProgress=[sum doubleValue];
        
        [[self delegate]setGoal:goal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if(check==0)
    {
        progress.progressPercentageToGoal=[self.progressPersntageTextField.text doubleValue];
        [progress UpdateProgress];
        Goal *goal=[[Goal alloc]init];
        goal.goalID=currentProgress.goalID;
        [goal declareGoalAsAchieved];
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

-(int) checkTheEnteredProgress
{
    NSLog(@"min %f",(currentGoal.goalProgress-currentProgress.progressPercentageToGoal)+[self.progressPersntageTextField.text doubleValue]);
    int X=-1;
    
    
    //invalid input
    if ([self.progressPersntageTextField.text isEqual:@""])
    {
        
        X=-3;
    }
    
    // curent goal progress + new progress < 100
    
    else if ((currentGoal.goalProgress-currentProgress.progressPercentageToGoal)+[self.progressPersntageTextField.text doubleValue] < 100)
    {
        
        X=1;
    }
    
    // curent goal progress + new progress = 100
    
    else if ((currentGoal.goalProgress-currentProgress.progressPercentageToGoal)+[self.progressPersntageTextField.text doubleValue] == 100)
    {
        X=0;
    }
    
    // invalid input
    else if ([self.progressPersntageTextField.text doubleValue] > 100)
    {
        X=-2;
    }
    
    NSLog(@"x= %d",X);
    return X;
}

@end
