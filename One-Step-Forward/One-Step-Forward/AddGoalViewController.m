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
@synthesize goalID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

}

- (IBAction)isSavePressed:(UIBarButtonItem *)sender {
    

    
            Goal *goal=[[Goal alloc]init];
            PFUser *curreUser = [PFUser currentUser];
            goal.createdBy=[curreUser objectForKey:@"UserID"];
            goal.goalName=self.goalName.text;
            goal.goalDescription=self.goalDesc.text;
            goal.goalDeadline=self.deadlineLabel.text;
            goal.isGoalCompleted=0;
            goal.isGoalinProgress=1;
            goal.goalProgress=0.0;
            
            [goal AddGoaltoDatabase];
            [[self navigationController] popViewControllerAnimated:YES];
    
    
    

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


#pragma mark Create a random number 


@end
