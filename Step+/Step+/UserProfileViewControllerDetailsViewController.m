//
//  UserProfileViewControllerDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "UserProfileViewControllerDetailsViewController.h"

@interface UserProfileViewControllerDetailsViewController ()

@end

@implementation UserProfileViewControllerDetailsViewController

@synthesize cgoal;
@synthesize currentUser;

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
    
    NSLog(@"T: %d",cgoal.goalID);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)send:(UIButton *)sender {
    
    NSLog(@"Goal%@",cgoal.createdBy);
    NSLog(@"Goal%@",currentUser.userUsername);
    NSLog(@"Goal%d",cgoal.goalID);
    
    PFObject *newGoalSuggestion= [PFObject objectWithClassName:@"GoalSuggestion"];
    
    [newGoalSuggestion setObject: cgoal.createdBy forKey:@"To"];
    
    [newGoalSuggestion setObject: currentUser.userUsername  forKey:@"From"];
    
    [newGoalSuggestion setObject: [NSString stringWithFormat:@"%d",cgoal.goalID ] forKey:@"GoalID"];
    
    [newGoalSuggestion setObject: self.suggestionTextField.text forKey:@"SuggestionText"];
    
    
    NSData *pictureData = UIImagePNGRepresentation(currentUser.userProfileImage);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [newGoalSuggestion setObject:file forKey:@"FromuserProfilePic"];
        [newGoalSuggestion saveEventually];
    }];
}

@end
