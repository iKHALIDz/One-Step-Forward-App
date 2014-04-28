//
//  MainMenuViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

{
    int tag;
}

@end


@implementation MainMenuViewController


@synthesize currentUser;
@synthesize avatar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewDidLoad
{
    [super viewDidLoad];
    
//    
//    [self.scrollView setScrollEnabled:YES];
//    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 12,
//                                        self.scrollView.frame.size.height);
    
    
    // Generate content for our scroll view using the frame height and width as the reference
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    
    [super viewDidAppear:YES];
    
    PFUser *curreUser =[PFUser currentUser];
    
    if (currentUser==nil) // in Case if the user is already logged in
    {
        NSLog(@"User is already logged in");
        currentUser=[[User alloc]init];
        
        currentUser=[currentUser getUserInfo:curreUser.username];
        
        if (currentUser ==nil)
        {
            NSLog(@"User isn't in the Database");
            
            currentUser=[self getUserInfromationAsObject];
            
            
            [currentUser UserRegistrationUsingDatabase];
            NSLog(@"Got Data From Parse");
        }
        
        else
        {
            NSLog(@"We got the information form the database and the Username %@",currentUser.userUsername);

        }
    }
    
    else
        
    {

        //currentUser=[currentUser getUserInfo:curreUser.username];
        NSLog(@"User exists in the Database");
    }
    
    self.userFullname.text=[NSString stringWithFormat:@"%@ %@",currentUser.userFirsname,currentUser.userLastname];
    self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%d",currentUser.numberOfAchievedGoals];
    self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%d",currentUser.numberOfInProgressGoals];
    
    [avatar removeFromSuperview];
    
    
    avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    if (tag==1)
    {
        self.userbackground.image=currentUser.userBackgroundImage;
        avatar.image=currentUser.userProfileImage;
        [self.ProfileImageView addSubview:avatar];
    }

    else
    {
        [self getProfileImageInfoFromParse];

        [self.ProfileImageView addSubview:avatar];
        
    }
    
    
    NSLog(@"want to share %d",currentUser.wantsToShare);
    
    
    
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
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    [query whereKey:@"username" equalTo:curreUser.username];

    [query findObjectsInBackgroundWithTarget:self selector:@selector(findCallback:error:)];
}



- (void)findCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        for(PFObject *obj in objects)
        {
            PFFile *image = (PFFile *)[obj objectForKey:@"ProfileImage"];
            avatar.image=[UIImage imageWithData:[image getData]];
            currentUser.userProfileImage=[UIImage imageWithData:[image getData]];
            
            PFFile *image2 = (PFFile *)[obj objectForKey:@"BackgroundPic"];
            currentUser.userBackgroundImage=[UIImage imageWithData:[image2 getData]];
            self.userbackground.image=[UIImage imageWithData:[image2 getData]];
        }
        
    }
}

-(User *)getUserInfromationAsObject
{
    PFUser *curreUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
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
            PFFile *image2 = (PFFile *)[object objectForKey:@"BackgroundPic"];

            user.userProfileImage=[UIImage imageWithData:[image getData]];
            user.userBackgroundImage=[UIImage imageWithData:[image2 getData]];
            
        }
    
    return user;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toInProgressGoals"])
    {
        UINavigationController *nav = [segue destinationViewController];

        InProgressGoalsViewController*vc = (InProgressGoalsViewController*)nav.topViewController;
        //currentUser.userProfileImage=avatar.image;
        
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toSocialPart"])
    {
        UINavigationController *nav = [segue destinationViewController];
        TimelineViewController*vc = (TimelineViewController*)nav.topViewController;
        currentUser.userProfileImage=avatar.image;
        [vc setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"toSetting"])
    {
        UINavigationController *nav = [segue destinationViewController];
        SettingViewController*vc = (SettingViewController*)nav.topViewController;
        currentUser.userProfileImage=avatar.image;
        
        [vc setCurrentUser:self.currentUser];
        [vc setDelegate:self];

    }
    
    if ([[segue identifier] isEqualToString:@"toLogs"])
    {
        UINavigationController *nav = [segue destinationViewController];
        CalenderLogsEventsViewController*vc = (CalenderLogsEventsViewController*)nav.topViewController;
        currentUser.userProfileImage=avatar.image;
        [vc setCurrentUser:self.currentUser];
    }
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) updateUser:(User *)updatedUser
{
    tag=1;
    NSLog(@"Update User");
    
    currentUser=updatedUser;
    
    
}
@end
