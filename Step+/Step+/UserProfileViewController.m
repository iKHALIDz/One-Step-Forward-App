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
@synthesize goalPosts;
@synthesize currentGoal;
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
    
    User *user=[[User alloc]init];
    
    user=[self getUserInfromationAsObject];
    
    self.userFullname.text=[NSString stringWithFormat:@"%@ %@",user.userFirsname,user.userLastname];
    self.NumberAchievedGoals.text=[NSString stringWithFormat:@"%d",user.numberOfAchievedGoals];
    self.NumberInProgressGoals.text=[NSString stringWithFormat:@"%d",user.numberOfInProgressGoals];
    self.img.image=user.userProfileImage;
    self.img.layer.borderWidth = 1.0f;
    self.img.clipsToBounds = YES;
    self.img.layer.cornerRadius = 2.0f;
    
    inProgressArrayFromParse=[[NSMutableArray alloc]init];

    inProgressArrayFromParse=[self getDoneGoalsFromParse];
    [self.tableview reloadData];
    
    goalPosts=[[NSMutableArray alloc]init];
    
    currentGoal=[[Goal alloc]init];
    
    
    
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
    
    CGRect frame = CGRectMake(0,-10, 40, 40);
    
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = [[inProgressArrayFromParse objectAtIndex:indexPath.row] goalProgress];
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
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

-(User *)getUserInfromationAsObject
{
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:self.selectedUsername];
    
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


-(NSMutableArray *) getDoneGoalsFromParse
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"createdBy" equalTo:self.selectedUsername];
    
    NSError *error=nil;
    
    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
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
        
        [list addObject:goal];
    }
    
    return list;
}


-(NSMutableArray *) getPostsFromSelectedGoal:(int) goalID AndUsername :(NSString *)username
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Timeline"];
    
    NSLog(@"username: %@",username);
    NSLog(@"username: %d",goalID);
    
    [query whereKey:@"username" equalTo:username];
    [query whereKey:@"PostOtherRelatedInFormationContent" equalTo:[NSString stringWithFormat:@"%d",goalID]];
    
    [query orderByDescending:@"PostDate"];
    
    NSError *error=nil;

    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
    {
        TimelinePost *post=[[TimelinePost alloc]init];
        post.userFirstName=[obj objectForKey:@"userFirstName"];
        post.userLastName=[obj objectForKey:@"userLastName"];
        post.username=[obj objectForKey:@"username"];
        post.PostDate=[obj objectForKey:@"PostDate"];
        post.PostContent=[obj objectForKey:@"PostContent"];
        post.postID=[obj objectForKey:@"postID"];
        post.PostOtherRelatedInFormationContent=[obj objectForKey:@"PostOtherRelatedInFormationContent"];
        
        PFFile *image = (PFFile *)[obj objectForKey:@"userProfilePic"];
        post.userProfilePic=[UIImage imageWithData:[image getData]];
        
        [list addObject:post];
    }
    
    NSLog(@"List Count %d",[list count]);
    

    return list;
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
    
    
    goalPosts=[self getPostsFromSelectedGoal:[[NSString stringWithFormat:@"%d",[[inProgressArrayFromParse objectAtIndex:indexPath.row] goalID]] integerValue]
                                 AndUsername:[NSString stringWithFormat:@"%@",[[inProgressArrayFromParse objectAtIndex:indexPath.row] createdBy]]];
    
    
    [self performSegueWithIdentifier:@"userProfileToD" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"userProfileToD"])
    {
        UserProfileViewControllerDetailsViewController *nav = [segue destinationViewController];
        [nav setCgoal:currentGoal];
        [nav setGPosts:goalPosts];
        [nav setCurrentUser:currentUser];
    }
}

@end
