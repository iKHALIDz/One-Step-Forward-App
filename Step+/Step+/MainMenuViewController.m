//
//  MainMenuViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end


@implementation MainMenuViewController


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
    currentUser=[[User alloc]init];
    
    [self getUserProfileInfoFromParse];
    
    PFUser *curreUser =[PFUser currentUser];
//    
//    User *u=[[User alloc]init];
//    [u getUserInfo:curreUser.username];

    NSLog(@"mm%@",curreUser.username);

    currentUser.userUsername=curreUser.username;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignOut:(UIBarButtonItem *)sender
{
    
    [PFUser logOut];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle: nil];
    LoginViewController*wViewController = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:wViewController animated:YES completion:nil];
}


-(void)getUserProfileInfoFromParse
{
    PFUser *curreUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    [query whereKey:@"username" equalTo:curreUser.username];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            self.userFullname.text=[NSString stringWithFormat:@"%@ %@",[object objectForKey:@"FirstName"],[object objectForKey:@"LastName"]];
            self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfAchievedGoals"]];
            self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfInProgressGoals"]];
            PFFile *image = (PFFile *)[object objectForKey:@"ProfileImage"];
            self.img.image=[UIImage imageWithData:[image getData]];
        }
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toInProgressGoals"])
    {
         InProgressGoalsViewController*vc =[segue destinationViewController];
        
        [vc setCurrentUser:self.currentUser];
    }
}


@end
