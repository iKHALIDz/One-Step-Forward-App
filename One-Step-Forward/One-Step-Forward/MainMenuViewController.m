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

@synthesize postArray;
@synthesize doneGoals;
@synthesize currentGoal;
@synthesize currentGoalProgressPercentage;
@synthesize currentUserID;
@synthesize array,array2;
@synthesize radialView;


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
    
    
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	// Only required in this demo to align vertically the progress views.
	view.center = CGPointMake(30,30);
    
	return view;
}


-(void) viewWillAppear:(BOOL)animated
{
    
    array=[self getinProgressGoalsFromDB];
    array2=[self getDoneGoalsFromDB];
    
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section==0)
    {
        return array.count;
    }
    else return array2.count;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)isSignOutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return @"Goals In Progress";
        
    }
    else
        return @"Goals are Done";
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    if (indexPath.section==0)
    {
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
    }
    
    if (indexPath.section==1)
    {
        
        [cell.goalName setText:(NSString *)[[array2 objectAtIndex:indexPath.row] goalName]];
        CGRect frame = CGRectMake(50,20, 50, 50);
        radialView = [self progressViewWithFrame:frame];
        radialView.progressTotal = 100;
        radialView.progressCounter = [[array2 objectAtIndex:indexPath.row] goalProgress];
        radialView.startingSlice = 3;
        radialView.theme.sliceDividerThickness = 1;
        radialView.theme.sliceDividerHidden = NO;
        radialView.label.textColor = [UIColor blueColor];
        radialView.label.shadowColor = [UIColor clearColor];
        [cell.progressPercentageView addSubview:radialView];

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        currentGoalProgressPercentage=[[array objectAtIndex:indexPath.row] goalProgress];
        currentGoal = [NSString stringWithFormat:@"%d",[[array objectAtIndex:indexPath.row] goalID]] ;
        
    }
    if (indexPath.section==1)
    {
        currentGoalProgressPercentage=[[array2 objectAtIndex:indexPath.row] goalProgress];
        currentGoal = [NSString stringWithFormat:@"%d",[[array2 objectAtIndex:indexPath.row] goalID]] ;
    }
    
    [self performSegueWithIdentifier:@"GoalToDetails" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoalToDetails"])
    {
        detailsViewController *nav = [segue destinationViewController];
        
        [nav setCurrentGoalID:self.currentGoal];
        [nav setCurrentGoalProgressPercentage:currentGoalProgressPercentage];
        
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
    
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
    
    [db executeUpdate:createSQL];
    
    
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
    
    
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
    
    [db executeUpdate:createSQL];
    
    
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
        
        [list addObject:goal];
    }
    
    return list;
}

@end
