//
//  MainMenuViewController.m
//  TestingLogin
//
//  Created by KHALID ALAHMARI on 1/29/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize tableView = _tableView;

@synthesize currentGoal;
@synthesize currentGoalProgressPercentage;
@synthesize currentUserID;
@synthesize array,array2;
@synthesize radialView;
@synthesize cGoal;


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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if (![currentUserID isEqualToString:@""])
    {
        PFUser *curreUser = [PFUser currentUser];
        currentUserID=[curreUser objectForKey:@"UserID"];
        
    }
    
    
    
    NSLog(@"User ID: %@",currentUserID);
    array=[[NSMutableArray alloc]init];
    array2=[[NSMutableArray alloc]init];
    
    array=[self getinProgressGoalsFromDB];
    array2=[self getDoneGoalsFromDB];
    
    cGoal=[[Goal alloc]init];
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(30,30);
    
	return view;
}


-(void) viewWillAppear:(BOOL)animated
{
    
    array=[self getinProgressGoalsFromDB];
    array2=[self getDoneGoalsFromDB];
    
    [self.tableView reloadData];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    self.numberofOngoingGoals.text=[NSString stringWithFormat:@"Number of ongoing goals: %d",[array count]];
    
    self.numberofAchieviedGoals.text=[NSString stringWithFormat:@"Number of achieved goals: %d",[array2 count]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return array.count;
}




- (IBAction)isSignOutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        [cell.goalName setText:(NSString *)[[array objectAtIndex:indexPath.row] goalName]];
        CGRect frame = CGRectMake(50,50, 50, 50);
        radialView = [self progressViewWithFrame:frame];
        radialView.progressTotal = 100;
        radialView.progressCounter = [[array objectAtIndex:indexPath.row] goalProgress];
        radialView.startingSlice = 3;
        radialView.theme.sliceDividerThickness = 1;
        radialView.theme.sliceDividerHidden = NO;
        radialView.label.textColor = [UIColor blueColor];
        radialView.label.shadowColor = [UIColor clearColor];
        [cell.progressPercentageView addSubview:radialView];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        cGoal.goalID=[[NSString stringWithFormat:@"%d",[[array objectAtIndex:indexPath.row] goalID]] integerValue];
        cGoal.goalName=[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] goalName]];
        cGoal.goalDescription=[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] goalDescription]];
        cGoal.goalDeadline=[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] goalDeadline]];
        cGoal.goalProgress=[[array objectAtIndex:indexPath.row] goalProgress];
        cGoal.createdBy=[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] createdBy]];
        cGoal.goalDate=[NSString stringWithFormat:@"%@",[[array objectAtIndex:indexPath.row] goalDate]];
        cGoal.goalSteps=[[array objectAtIndex:indexPath.row] goalSteps];
    
    [self performSegueWithIdentifier:@"GoalToDetails" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoalToDetails"])
    {
        detailsViewController *nav = [segue destinationViewController];
        [nav setCurrentGoal:cGoal];
    }
    else if ([[segue identifier] isEqualToString:@"toLogs"])
    {
        CalenderLogsEventsViewController *nav = [segue destinationViewController];
        
        [nav setCurrentUserID:self.currentUserID];
    }
    
    else if ([[segue identifier] isEqualToString:@"toAchievedGoals"])
    {
        achievedGoalsUIViewController *nav = [segue destinationViewController];
        [nav setAchievedGoalsArray:array2];
        
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
    
    FMResultSet *result =[db executeQuery:@"select * from Goals where isGoalCompleted='1' AND isGoalinPregress='0';"];
    
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
        goal.goalSteps=[result intForColumn:@"numberofStepTaken"];
        goal.goalDate=[result stringForColumn:@"goalDate"];

        
        [list addObject:goal];
    }
    return list;
}



-(NSMutableArray *) getinProgressGoalsFromDB
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    FMResultSet *result =[db executeQuery:@"select * from Goals where isGoalinPregress='1' AND isGoalCompleted='0';"];
    
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
        goal.goalSteps=[result intForColumn:@"numberofStepTaken"];
        goal.goalDate=[result stringForColumn:@"goalDate"];
        
        [list addObject:goal];
    }
    
    return list;
}






@end
