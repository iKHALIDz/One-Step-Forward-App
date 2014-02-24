//
//  detailsViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController


@synthesize currentGoalID;
@synthesize postArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder
{
    
    self=[super initWithCoder:aDecoder];
    if (self)
    {
    
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {
            
            
           //self.label.text=[object objectForKey:@"ProgressName"];
            
        }
    }];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) declareAchieved:(UIButton *)sender
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
    
}



- (IBAction)addProgress:(UIButton *)sender {
    
    PFObject *newProgress = [PFObject objectWithClassName:@"Progress"];
    
    [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
    
    
    //Realationship
    [newProgress setObject:currentGoalID forKey:@"goalID"];
    
    
    [newProgress saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

        }}];
}
@end
