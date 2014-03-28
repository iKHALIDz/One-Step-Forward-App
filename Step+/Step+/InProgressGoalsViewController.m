//
//  InProgressGoalsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/23/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "InProgressGoalsViewController.h"

@interface InProgressGoalsViewController ()

@end

@implementation InProgressGoalsViewController

@synthesize currentUser;
@synthesize currentGoal;
@synthesize tableView=_tableView;
@synthesize radialView;
@synthesize inProgressArray;
@synthesize inProgressArrayFromParse;


- (void)viewDidLoad
{
    [super viewDidLoad];

    PFUser *curreUser = [PFUser currentUser];
    
    currentUser.userUsername=curreUser.username;

    currentGoal=[[Goal alloc]init];
    
    inProgressArray=[[NSMutableArray alloc]init];
    inProgressArrayFromParse=[[NSMutableArray alloc]init];

    inProgressArray=[self getDoneGoalsFromDB];
    
    
    if ([inProgressArray count]==0)
    {
        NSLog(@"Parse, We still need to add it to DB");
        inProgressArrayFromParse=[self getDoneGoalsFromParse];
        for (Goal *newgoal in inProgressArrayFromParse)
        {
            [newgoal AddGoaltoDatabase];
        }
    }
}


-(void) viewWillAppear:(BOOL)animated
{

    inProgressArray=[self getDoneGoalsFromDB];
    [self.tableView reloadData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableBackground.png"]];
    
    self.tableView.backgroundView = imageView;

    self.tableView.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(30,22);
    
	return view;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newGoal"])
    {
        UINavigationController *nav = [segue destinationViewController];
        newGoalViewController *vc =(newGoalViewController*)nav.topViewController;
        [vc setCurrentUser:self.currentUser];
    }
    
    else if ([[segue identifier] isEqualToString:@"GoalToDetails"])
    {
        goalDetailsViewController *nav = [segue destinationViewController];
        [nav setCurrentGoal:currentGoal];
        
    }
}


-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

-(NSMutableArray *) getDoneGoalsFromDB
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='0' AND isGoalinPregress='1' AND CreatedBy='%@';",currentUser.userUsername];
    
    NSLog(@"%@",query);
    
    
    FMResultSet *result =[db executeQuery:query];
    
    while ([result next])
    {
        Goal *goal=[[Goal alloc]init];
        goal.goalID=[result intForColumn:@"goalId"];
        goal.goalName=[result stringForColumn:@"GoalName"];
        goal.goalDescription=[result stringForColumn:@"GoalDesc"];
        goal.goalDeadline=[result stringForColumn:@"GoalDeadline"];
        goal.isGoalCompleted=[result intForColumn:@"isGoalCompleted"];
        goal.isGoalinProgress=[result intForColumn:@"isGoalinPregress"];
        goal.goalProgress=[result doubleForColumn:@"goalPercentage"];
        goal.createdBy =[result stringForColumn:@"CreatedBy"];
        goal.numberOfGoalSteps=[result intForColumn:@"numberofStepTaken"];
        goal.goalDate=[result stringForColumn:@"goalDate"];
        goal.goalType=[result stringForColumn:@"goalType"];
        
        [list addObject:goal];
    }
    return list;
}


-(NSMutableArray *) getDoneGoalsFromParse
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"createdBy" equalTo:currentUser.userUsername];
    [query whereKey:@"isGoalCompleted" equalTo:@NO];
    [query whereKey:@"isGoalinProgress" equalTo:@YES];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inProgressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"goalCell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.GoalName setText:(NSString *)[[inProgressArray objectAtIndex:indexPath.row] goalName]];
    
    CGRect frame = CGRectMake(0,-10, 40, 40);
    
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = [[inProgressArray objectAtIndex:indexPath.row] goalProgress];
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    [cell.contentView addSubview:radialView];
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentGoal.goalID=[[NSString stringWithFormat:@"%d",[[inProgressArray objectAtIndex:indexPath.row] goalID]] integerValue];
    
    currentGoal.goalName=[NSString stringWithFormat:@"%@",[[inProgressArray objectAtIndex:indexPath.row] goalName]];
    
    currentGoal.goalDescription=[NSString stringWithFormat:@"%@",[[inProgressArray objectAtIndex:indexPath.row] goalDescription]];
    
    currentGoal.goalDeadline=[NSString stringWithFormat:@"%@",[[inProgressArray objectAtIndex:indexPath.row] goalDeadline]];
    
    currentGoal.goalProgress=[[inProgressArray objectAtIndex:indexPath.row] goalProgress];
    
    currentGoal.createdBy=[NSString stringWithFormat:@"%@",[[inProgressArray objectAtIndex:indexPath.row] createdBy]];
    
    currentGoal.goalDate=[NSString stringWithFormat:@"%@",[[inProgressArray objectAtIndex:indexPath.row] goalDate]];
    
    currentGoal.numberOfGoalSteps=[[inProgressArray objectAtIndex:indexPath.row] numberOfGoalSteps];
    currentGoal.isGoalinProgress=[[inProgressArray objectAtIndex:indexPath.row] isGoalinProgress];
    currentGoal.isGoalCompleted=[[inProgressArray objectAtIndex:indexPath.row] isGoalCompleted];
    currentGoal.goalType=[[inProgressArray objectAtIndex:indexPath.row] goalType];
    
    
    [self performSegueWithIdentifier:@"GoalToDetails" sender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

@end
