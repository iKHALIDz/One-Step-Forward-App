//
//  UserProfileViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController


@synthesize selectedUsername;
@synthesize tableview=_tableview;
@synthesize inProgressArrayFromParse;
@synthesize radialView;
@synthesize currentGoal;
@synthesize currentUser;
@synthesize selectedUser;
@synthesize avatar;


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
    
    
    [self getUserInfromationAsObject];
    
    self.userFullname.text=[NSString stringWithFormat:@"%@ %@",selectedUser.userFirsname,selectedUser.userLastname];
    self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%d",selectedUser.numberOfAchievedGoals];
    self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%d",selectedUser.numberOfInProgressGoals];
    
    [avatar removeFromSuperview];
    avatar = [[AMPAvatarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [self getDoneGoalsFromParse];
    [self.tableview reloadData];
    
    
    currentGoal=[[Goal alloc]init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableview.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

    
    

}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(30,22);
    
	return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inProgressArrayFromParse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"goalCell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.GoalName setText:(NSString *)[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalName]];
    
    [cell.DueDate setText:[NSString stringWithFormat:@"%d Steps Taken",[[inProgressArrayFromParse objectAtIndex:indexPath.row] numberOfGoalSteps]]];
    
    
    CGRect frame = CGRectMake(0,-10, 40, 40);
    
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = [[inProgressArrayFromParse objectAtIndex:indexPath.row] goalProgress];
    radialView.theme.completedColor=[UIColor blueColor];
    radialView.theme.incompletedColor=[UIColor colorWithHexString:@"8795b1"];
    radialView.theme.thickness=10;
    radialView.theme.sliceDividerHidden = NO;
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 0;
    
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    
    radialView.label.pointSizeToWidthFactor=0.3;
    
    [cell.contentView addSubview:radialView];
    
    cell.MoveCell.hidden=YES;
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserInfromationAsObject
{
    PFQuery *query = [PFUser query];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"username" equalTo:self.selectedUsername];
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(getuserinfCallBack:error:)];
}


- (void)getuserinfCallBack:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        PFObject *object=[objects objectAtIndex:0];
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            NSLog(@"ttttt");
            selectedUser=[[User alloc]init];
            // The find succeeded.
            selectedUser.userFirsname=[NSString stringWithFormat:@"%@",[object objectForKey:@"FirstName"]];
            NSLog(@"ttttt2");
            
            selectedUser.userLastname=[NSString stringWithFormat:@"%@",[object objectForKey:@"LastName"]];
            selectedUser.userUsername=[NSString stringWithFormat:@"%@",[object objectForKey:@"username"]];
            selectedUser.userPassword=[NSString stringWithFormat:@"%@",[object objectForKey:@"password"]];
            selectedUser.userEmailAddres=[NSString stringWithFormat:@"%@",[object objectForKey:@"email"]];
            NSLog(@"ttttt2");
            
            selectedUser.numberOfAchievedGoals=[[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfAchievedGoals"]] integerValue];
            selectedUser.numberOfInProgressGoals=[[NSString stringWithFormat:@"%@",[object objectForKey:@"numberOfInProgressGoals"]]integerValue];
            PFFile *image = (PFFile *)[object objectForKey:@"ProfileImage"];
            
            selectedUser.userProfileImage=[UIImage imageWithData:[image getData]];
            avatar.image=[UIImage imageWithData:[image getData]];
            
            [self.profileview addSubview:avatar];

            
            PFFile *image2 = (PFFile *)[object objectForKey:@"BackgroundPic"];
            selectedUser.userBackgroundImage=[UIImage imageWithData:[image2 getData]];

            
            self.userFullname.text=[NSString stringWithFormat:@"%@ %@",selectedUser.userFirsname,selectedUser.userLastname];
            self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%d",selectedUser.numberOfAchievedGoals];
            self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%d",selectedUser.numberOfInProgressGoals];
            self.img.image=selectedUser.userProfileImage;
            
            self.background.image=selectedUser.userBackgroundImage;
            
            
            
        }
        
    }
}

-(void) getDoneGoalsFromParse
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"createdBy" equalTo:self.selectedUsername];
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
    
}

- (void)findCallback:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        inProgressArrayFromParse=[[NSMutableArray alloc]init];
        
        for(PFObject *obj in objects)
        {
            Goal *goal=[[Goal alloc]init];
            goal.goalID= [[obj objectForKey:@"goalID"] integerValue];
            goal.goalName=[obj objectForKey:@"GoalName"];
            goal.goalDescription=[obj objectForKey:@"GoalDesc"];
            goal.goalDeadline=[obj objectForKey:@"GoalDeadline"];
            goal.isGoalCompleted=NO;
            goal.isGoalinProgress=YES;
            goal.goalProgress=[[obj objectForKey:@"goalPercentage"] doubleValue];
            
            goal.createdBy =[obj objectForKey:@"createdBy"];
            
            goal.numberOfGoalSteps=[[obj objectForKey:@"numberOfGoalSteps"] integerValue];
            goal.goalDate=[obj objectForKey:@"goalDate"];
            
            goal.goalType=[obj objectForKey:@"goalType"];
            
            [inProgressArrayFromParse addObject:goal];
        }
        
        [self.tableview reloadData];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentGoal.goalID=[[NSString stringWithFormat:@"%d",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalID]] integerValue];
    
    currentGoal.goalName=[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalName]];
    
    currentGoal.goalDescription=[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalDescription]];
    
    currentGoal.goalDeadline=[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalDeadline]];
    
    currentGoal.goalProgress=[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalProgress];
    
    currentGoal.createdBy=[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] createdBy]];
    
    currentGoal.goalDate=[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalDate]];
    
    currentGoal.numberOfGoalSteps=[[inProgressArrayFromParse objectAtIndex:indexPath.row] numberOfGoalSteps];
    currentGoal.isGoalinProgress=[[inProgressArrayFromParse objectAtIndex:indexPath.row] isGoalinProgress];
    currentGoal.isGoalCompleted=[[inProgressArrayFromParse objectAtIndex:indexPath.row] isGoalCompleted];
    currentGoal.goalType=[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalType];
    currentGoal.goalPriority=[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalPriority];
    
    
    [self performSegueWithIdentifier:@"userProfileToD" sender:nil];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"userProfileToD"])
    {
        UINavigationController *nav=[segue destinationViewController];
        
        UserProfileViewControllerDetailsViewController *vc = (UserProfileViewControllerDetailsViewController*) nav.topViewController;
        [vc setCgoal:currentGoal];
        [vc setCurrentUser:currentUser];
    }
}

- (IBAction)back:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"$");
    
    
}
@end
