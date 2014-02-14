//
//  AddGoal.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AddGoal.h"
#import "GoalsUITableViewController.h"


@interface AddGoal ()

@end

@implementation AddGoal

@synthesize dateFormatter;
@synthesize DeadlineLabelText;

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
    
    if(DeadlineLabelText!=nil)
    {
    self.deadlineLabel.text=DeadlineLabelText;
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PickADeadlineDate:(UIButton *)sender {
   
    
}


- (IBAction)Save:(UIBarButtonItem *)sender {
    
    NSLog(@"Save is Pressed");
    
    [self performSegueWithIdentifier:@"FromAddGoalToListOfGoalsSegue" sender:sender];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FromAddGoalToListOfGoalsSegue"])
    {
        GoalsUITableViewController *update = [segue destinationViewController];
        update.newg_goalname=self.goalNameTextField.text;
        update.newg_goalsdescription=self.goalDescriptionTextField.text;
        update.newg_goaldeadline=self.deadlineLabel.text;
        
    }
}
@end
