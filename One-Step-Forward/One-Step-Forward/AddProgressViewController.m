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



- (IBAction)cancelIsPressed:(UIBarButtonItem *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addProgress:(UIButton *)sender {
    
    
    
    PFObject *newProgress = [PFObject objectWithClassName:@"Progress"];
    
    int m=[self checkTheEnteredProgress];
    
    if(m==1)
    {
        
        [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
        [newProgress setObject:self.progressPercentage.text forKey:@"ProgressPercentage"];
        
        //Realationship
        [newProgress setObject:currentGoalID forKey:@"goalID"];
        
        NSLog(@"Less Than 100");
        
        
        NSError *error;
        
        [newProgress save:&error];
        
        {
            if (!error) {
                
                
                [self updateGoal:[self.progressPercentage.text doubleValue]];
                
                [self dismissViewControllerAnimated:YES completion:nil];

            }}
        
    }
    
    
    else if (m==0)
    {
        [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
        [newProgress setObject:self.progressPercentage.text forKey:@"ProgressPercentage"];
        
        //Realationship
        [newProgress setObject:currentGoalID forKey:@"goalID"];
        
        NSLog(@"Less Than 100");
        
        
        NSError *error;
        
        [newProgress save:&error];
        
        [self declareAchieved];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    else if (m==-1)
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Errot!"
                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoalProgressPercentage]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        
        [message show];
        
        
        
    }
    
    else if (m==-2 || m==-3)
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
    NSLog(@"currentGoalProgressPercentage %f",self.currentGoalProgressPercentage);
    NSLog(@"entred progressPercentage %f",[self.progressPercentage.text doubleValue]);
    
    int X=-1;
    
    if ([self.progressPercentage.text isEqual:@""])
    {
        
        X=-3;
        
    }
    
    else if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] < 100) {
        
        X=1;
        
    }
    else if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] == 100)
    {
        X=0;
    }
    
    else if ([self.progressPercentage.text doubleValue] > 100)
    {
        X=-2;
        
    }
    
    
    NSLog(@"x= %d",X);
    
    return X;
    
}


-(void) updateGoal :(double) progressPercentge
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    NSError *error;
    
    PFObject *object=[postQuery getFirstObject:&error ];
    
    if (!error) {
        
        NSLog(@"RRR");
        NSString *sum=[NSString stringWithFormat:@"%.2f",progressPercentge+currentGoalProgressPercentage];
        
        NSLog(@"rr%@",sum);
        [object setObject:sum forKey:@"goalPercentage"];
        
        [object save];
        [[self delegate]setGoalPercentage:[sum doubleValue]];
        
    }
}

- (void) declareAchieved
{
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {
            
            [object setObject:@YES forKey:@"isGoalCompleted"];
            [object setObject:@NO forKey:@"isGoalinPregress"];
            [object setObject:@"100" forKey:@"goalPercentage"];
            [object saveInBackground];
        }
    }];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                      message:@"You did Achive your goal"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];

    
    [message show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}



@end
