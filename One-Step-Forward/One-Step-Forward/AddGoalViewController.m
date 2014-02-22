//
//  AddGoalViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AddGoalViewController.h"

@interface AddGoalViewController ()

@end



@implementation AddGoalViewController

@synthesize deadlineLabel;
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
}


-(void)viewDidAppear:(BOOL)animated
{
    
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

- (IBAction)isSavePressed:(UIBarButtonItem *)sender {
    
    PFObject *newGoal = [PFObject objectWithClassName:@"Goal"];
    [newGoal setObject:self.goalName.text forKey:@"GoalName"];
    [newGoal setObject:self.goalDesc.text forKey:@"GoalDesc"];
    [newGoal setObject:self.deadlineLabel.text forKey:@"GoalDeadline"];
    [newGoal setObject:[NSNumber numberWithBool:NO] forKey:@"isGoalCompleted"];
    [newGoal setObject:[NSNumber numberWithBool:YES] forKey:@"isGoalinPregress"];
    
    
    
    //Realationship
    [newGoal setObject:[PFUser currentUser] forKey:@"CreatedBy"];
    
    
    [newGoal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [[self navigationController] popViewControllerAnimated:YES];

        }}];
}


-(void)setDeadline:(NSString*)deadline;
{
    
    self.deadlineLabel.text=deadline;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"VC"])
    {
        UINavigationController *nav = [segue destinationViewController];
        CalenderViewController *vc =(CalenderViewController*)nav.topViewController;
        
        [vc setDelegate:self];
        
    }
    
}

- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (! [self isFirstResponder])
    {
        {
            if ([self.goalName isFirstResponder]) {
                [self.goalName resignFirstResponder];
            }
            if ([self.goalDesc isFirstResponder]) {
                [self.goalDesc resignFirstResponder];
                
            }
            
        }
    }
}

- (IBAction)PickADeadlineDate:(UIButton *)sender
{
    
    
}

@end
