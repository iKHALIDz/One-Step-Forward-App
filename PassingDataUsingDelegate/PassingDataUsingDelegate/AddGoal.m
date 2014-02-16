//
//  AddGoal.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AddGoal.h"


@interface AddGoal ()

@end

@implementation AddGoal

@synthesize dateFormatter;
@synthesize DeadlineLabelText;
@synthesize deadlineLabel;

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



- (IBAction)PickADeadlineDate:(UIButton *)sender {
   
    
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
            if ([self.goalNameTextField isFirstResponder]) {
                [self.goalNameTextField resignFirstResponder];
            }
            if ([self.goalDescriptionTextField isFirstResponder]) {
                [self.goalDescriptionTextField resignFirstResponder];
                
            }
            
        }
    }
}
@end
