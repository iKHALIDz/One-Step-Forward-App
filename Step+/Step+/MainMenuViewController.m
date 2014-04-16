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

- (void)viewDidAppear:(BOOL)animated
{
    
    
    [super viewDidAppear:YES];
    
    PFUser *curreUser =[PFUser currentUser];
    
    if (currentUser==nil) // in Case if the user is already logged in
    {
        NSLog(@"rrrr");
        currentUser=[[User alloc]init];
        
        currentUser=[currentUser getUserInfo:curreUser.username];
        
        if (currentUser ==nil)
        {
            
            NSLog(@"rrr1");
            NSLog(@"User isn't in the Database");
            currentUser=[self getUserInfromationAsObject];
            NSLog(@"Username %@",currentUser.userUsername);
            
            [currentUser UserRegistrationUsingDatabase];
            NSLog(@"Got Data From Parse");
        }
        
        else
        {
            NSLog(@"rrr2");

        }
    }
    
    else
        
    {
        NSLog(@"rrr3");

        //currentUser=[currentUser getUserInfo:curreUser.username];
        NSLog(@"User exist in the Database");
    }
    
    self.userFullname.text=[NSString stringWithFormat:@"%@ %@",currentUser.userFirsname,currentUser.userLastname];
    self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%d",currentUser.numberOfAchievedGoals];
    self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%d",currentUser.numberOfInProgressGoals];
    
    [self getProfileImageInfoFromParse];
    
    self.img.layer.borderWidth = 1.0f;
    self.img.clipsToBounds = YES;
    self.img.layer.cornerRadius = 2.0f;
    
    NSLog(@"66 %d",currentUser.wantsToShare);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getProfileImageInfoFromParse
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
            PFFile *image = (PFFile *)[object objectForKey:@"ProfileImage"];
            self.img.image=[UIImage imageWithData:[image getData]];
            
        }
    }];
}

-(User *)getUserInfromationAsObject
{
    PFUser *curreUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [query whereKey:@"username" equalTo:curreUser.username];
    
    User *user=[[User alloc]init];
    PFObject *object=[query getFirstObject];
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            user.userFirsname=[NSString stringWithFormat:@"%@",[object objectForKey:@"FirstName"]];
            user.userLastname=[NSString stringWithFormat:@"%@",[object objectForKey:@"LastName"]];
            user.userUsername=[NSString stringWithFormat:@"%@",[object objectForKey:@"username"]];
            user.userPassword=[NSString stringWithFormat:@"%@",[object objectForKey:@"password"]];
            user.userEmailAddres=[NSString stringWithFormat:@"%@",[object objectForKey:@"email"]];
            
            user.numberOfAchievedGoals=[[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfAchievedGoals"]] integerValue];
            user.numberOfInProgressGoals=[[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfInProgressGoals"]]integerValue];
            PFFile *image = (PFFile *)[object objectForKey:@"ProfileImage"];
            
            user.userProfileImage=[UIImage imageWithData:[image getData]];
            
        }
    
    return user;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toInProgressGoals"])
    {
         InProgressGoalsViewController*vc =[segue destinationViewController];
        currentUser.userProfileImage=self.img.image;
        
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toDoneGoals"])
    {
        InProgressGoalsViewController*vc =[segue destinationViewController];
        currentUser.userProfileImage=self.img.image;
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toSocialPart"])
    {
        TimelineViewController*vc =[segue destinationViewController];
        currentUser.userProfileImage=self.img.image;
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toSetting"])
    {
        UINavigationController *nav = [segue destinationViewController];

        SettingViewController*vc = (SettingViewController*)nav.topViewController;
        
        currentUser.userProfileImage=self.img.image;
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toLogs"])
    {
        CalenderLogsEventsViewController*vc =[segue destinationViewController];
        currentUser.userProfileImage=self.img.image;
        [vc setCurrentUser:self.currentUser];
    }

    
}

@end
