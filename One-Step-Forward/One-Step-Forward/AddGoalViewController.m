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

- (IBAction)isSavePressed:(UIBarButtonItem *)sender {
    
    PFObject *newGoal = [PFObject objectWithClassName:@"Goal"];
    [newGoal setObject:self.goalName.text forKey:@"GoalName"];
    [newGoal setObject:self.goalDesc.text forKey:@"GoalDesc"];
    
    [newGoal setObject:[PFUser currentUser] forKey:@"CreatedBy"];
    
    [newGoal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [[self navigationController] popViewControllerAnimated:YES];


        }}];
    
    
    
    
    
}

@end
