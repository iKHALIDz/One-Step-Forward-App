//
//  LogAndStatViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "LogAndStatViewController.h"

@interface LogAndStatViewController ()

@end

@implementation LogAndStatViewController

@synthesize tableView=_tableView;

@synthesize array;
@synthesize currentUser;
@synthesize inProgressArray;
@synthesize achievedArray;
@synthesize pieChartRight = _pieChart;
@synthesize radialView,radialView2,radialView3;
@synthesize createdGoals;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(30,25);
    
	return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.contentSize=self.contentView.bounds.size;
    self.scrollView.scrollEnabled=YES;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:applicationFrame];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    
    [_calendarView setFrame:CGRectMake(0, 0, 320,350)];

    
    [self.contentView addSubview: _calendarView];

    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    
    
    [self.navigationItem setRightBarButtonItem:todayButton];
    self.navigationItem.title=@"Logs";
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self clearsSelectionOnViewWillAppear]) {
        [[self calendarView] deselectDayCellAtIndex:[[self calendarView] indexForSelectedDayCell] animated:YES];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSString *currentData= [dateFormatter stringFromDate:[NSDate date]];
    
    array=[self getGoalsListOfMonth:[currentData integerValue]];
    
    [self.tableView reloadData];
    
    inProgressArray=[[NSMutableArray alloc]init];
    achievedArray=[[NSMutableArray alloc]init];
    createdGoals=[[NSMutableArray alloc]init];
    
    
    inProgressArray=[self getinProgressGoalsFromDB:[currentData integerValue]];
    achievedArray=[self getDoneGoalsFromDB:[currentData integerValue]];
    createdGoals=[self getCreatedGoalsFromDB:[currentData integerValue]];
    
    NSLog(@"In Progress %d",[inProgressArray count]);
    NSLog(@"Done %d",[achievedArray count]);
    NSLog(@"Created %d",[createdGoals count]);

    
    CGRect frame1 = CGRectMake(0,0, 50, 50);
    
    radialView = [self progressViewWithFrame:frame1];
    radialView.progressTotal = 100;
    radialView.progressCounter = 100;
    radialView.theme.completedColor=[UIColor blueColor];
    radialView.theme.incompletedColor=[UIColor blueColor];
    radialView.theme.thickness=10;
    radialView.theme.sliceDividerHidden = NO;
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 0;
    
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    radialView.label.text=[NSString stringWithFormat:@"%d",[createdGoals count]];
    radialView.label.pointSizeToWidthFactor=0.3;
    
    [self.createdGoalView addSubview:radialView];
    
    
    
    /////
    
    
    
    CGRect frame2 = CGRectMake(0,0, 50, 150);
    
    radialView2 = [self progressViewWithFrame:frame2];
    radialView2.progressTotal = 100;
    radialView2.progressCounter = 100;
    radialView2.theme.completedColor=[UIColor blueColor];
    radialView2.theme.incompletedColor=[UIColor blueColor];
    radialView2.theme.thickness=10;
    radialView2.theme.sliceDividerHidden = NO;
    radialView2.startingSlice = 3;
    radialView2.theme.sliceDividerThickness = 0;
    
    radialView2.label.textColor = [UIColor blueColor];
    radialView2.label.shadowColor = [UIColor clearColor];
    
    
    radialView2.label.pointSizeToWidthFactor=0.3;
    radialView2.label.text=[NSString stringWithFormat:@"%d",[inProgressArray count]];

    [self.InProgressView addSubview:radialView2];
    
    /////
    
    
    CGRect frame3 = CGRectMake(0,0, 50, 250);
    
    radialView3 = [self progressViewWithFrame:frame3];
    radialView3.progressTotal = 100;
    radialView3.progressCounter = 100;
    radialView3.theme.completedColor=[UIColor blueColor];
    radialView3.theme.incompletedColor=[UIColor blueColor];
    radialView3.theme.thickness=10;
    radialView3.theme.sliceDividerHidden = NO;
    radialView3.startingSlice = 3;
    radialView3.theme.sliceDividerThickness = 0;
    
    radialView3.label.textColor = [UIColor blueColor];
    radialView3.label.shadowColor = [UIColor clearColor];
    
    radialView3.label.text=[NSString stringWithFormat:@"%d",[achievedArray count]];

    radialView3.label.pointSizeToWidthFactor=0.3;
    
    [self.DoneGoalView addSubview:radialView3];



}


- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *currentData= [dateFormatter stringFromDate:_calendarView.selectedDate];
    
    NSLog(@"%@",currentData);
    
    array=[self getGoalsList:currentData];
    
    [self.tableView reloadData];
    
}

-(void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
    
    NSInteger m = [month month];
    
    array=[self getGoalsListOfMonth:m];
    [self.tableView reloadData];
    
    
    inProgressArray=[self getinProgressGoalsFromDB:m];
    achievedArray=[self getDoneGoalsFromDB:m];
    createdGoals=[self getCreatedGoalsFromDB:m];
    
    NSLog(@"In Progress %d",[inProgressArray count]);
    NSLog(@"Done %d",[achievedArray count]);
    NSLog(@"Created %d",[createdGoals count]);
    
    
    [radialView removeFromSuperview];
    
    CGRect frame1 = CGRectMake(0,0, 50, 50);
    
    radialView = [self progressViewWithFrame:frame1];
    radialView.progressTotal = 100;
    radialView.progressCounter = 100;
    radialView.theme.completedColor=[UIColor blueColor];
    radialView.theme.incompletedColor=[UIColor blueColor];
    radialView.theme.thickness=10;
    radialView.theme.sliceDividerHidden = NO;
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 0;
    
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    radialView.label.text=[NSString stringWithFormat:@"%d",[createdGoals count]];
    radialView.label.pointSizeToWidthFactor=0.3;
    
    [self.createdGoalView addSubview:radialView];
    
    
    
    /////
    
    [radialView2 removeFromSuperview];
    
    
    CGRect frame2 = CGRectMake(0,0, 50, 150);
    
    radialView2 = [self progressViewWithFrame:frame2];
    radialView2.progressTotal = 100;
    radialView2.progressCounter = 100;
    radialView2.theme.completedColor=[UIColor blueColor];
    radialView2.theme.incompletedColor=[UIColor blueColor];
    radialView2.theme.thickness=10;
    radialView2.theme.sliceDividerHidden = NO;
    radialView2.startingSlice = 3;
    radialView2.theme.sliceDividerThickness = 0;
    
    radialView2.label.textColor = [UIColor blueColor];
    radialView2.label.shadowColor = [UIColor clearColor];
    
    
    radialView2.label.pointSizeToWidthFactor=0.3;
    radialView2.label.text=[NSString stringWithFormat:@"%d",[inProgressArray count]];
    
    [self.InProgressView addSubview:radialView2];
    
    /////
    
    [radialView3 removeFromSuperview];

    CGRect frame3 = CGRectMake(0,0, 50, 250);
    
    radialView3 = [self progressViewWithFrame:frame3];
    radialView3.progressTotal = 100;
    radialView3.progressCounter = 100;
    radialView3.theme.completedColor=[UIColor blueColor];
    radialView3.theme.incompletedColor=[UIColor blueColor];
    radialView3.theme.thickness=10;
    radialView3.theme.sliceDividerHidden = NO;
    radialView3.startingSlice = 3;
    radialView3.theme.sliceDividerThickness = 0;
    
    radialView3.label.textColor = [UIColor blueColor];
    radialView3.label.shadowColor = [UIColor clearColor];
    
    radialView3.label.text=[NSString stringWithFormat:@"%d",[achievedArray count]];
    
    radialView3.label.pointSizeToWidthFactor=0.3;
    
    [self.DoneGoalView addSubview:radialView3];

    NSLog(@"ttt %d",m);
    
}

- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index
{
    
    if (calendarView )
    {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell3";
    
    logCell *cell = (logCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"logCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    [cell.logContent setText:(NSString *)[[array objectAtIndex:indexPath.row] logContent]];
    
    
    if ([[[array objectAtIndex:indexPath.row]logAction] isEqualToString:@"Create"])
    {
        cell.picContent.image=[UIImage imageNamed:@"C.png"];
    }
    else if ([[[array objectAtIndex:indexPath.row]logAction] isEqualToString:@"Achieve"])
    {
        cell.picContent.image=[UIImage imageNamed:@"A.png"];
    }
    
    else if ([[[array objectAtIndex:indexPath.row]logAction] isEqualToString:@"Deleted"])
    {
        cell.picContent.image=[UIImage imageNamed:@"Re.png"];
    }
    
    else if ([[[array objectAtIndex:indexPath.row]logAction] isEqualToString:@"Log"])
    {
        cell.picContent.image=[UIImage imageNamed:@"P.png"];
    }
    
    
    [cell.logDate setText:(NSString *)[[array objectAtIndex:indexPath.row] logDate]];
    
    return cell;
}

-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}


-(NSMutableArray *) getGoalsList:(NSString*)Data
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    
    NSString *qr=[NSString stringWithFormat:@"select * from Logs where logDate='%@' AND userUsername='%@'",Data,currentUser.userUsername];
    
    NSString *s=[qr stringByAppendingString:@"ORDER BY logDate DESC;"];
    
    NSLog(@"RR %@",s);
    
    FMResultSet *result =[db executeQuery:s];
    
    while ([result next])
    {
        Log*log=[[Log alloc]init];
        
        log.logID=[result intForColumn:@"logID"];
        log.userUsername=[result stringForColumn:@"userUsername"];
        log.logDate=[result stringForColumn:@"logDate"];
        log.logAction=[result stringForColumn:@"logAction"];
        log.logContent=[result stringForColumn:@"logContent"];
        log.logType=[result stringForColumn:@"logType"];
        [list addObject:log];
    }
    
    return list;
}

-(NSMutableArray *) getGoalsListOfMonth:(NSInteger)month
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *qr=[NSString stringWithFormat:@"select * from Logs where month='%d' AND userUsername='%@'",month,currentUser.userUsername];
    
    NSString *s=[qr stringByAppendingString:@"ORDER BY logDate DESC;"];
    
    FMResultSet *result =[db executeQuery:s];
    
    while ([result next])
    {
        Log*log=[[Log alloc]init];
        
        log.logID=[result intForColumn:@"logID"];
        log.userUsername=[result stringForColumn:@"userUsername"];
        log.logDate=[result stringForColumn:@"logDate"];
        log.logAction=[result stringForColumn:@"logAction"];
        log.logContent=[result stringForColumn:@"logContent"];
        log.logType=[result stringForColumn:@"logType"];
        [list addObject:log];
    }
    
    return list;
}

- (IBAction)backToMain:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *) getDoneGoalsFromDB:(NSInteger) month
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='1' AND isGoalinPregress='0' AND CreatedBy='%@' AND month='%d' ",currentUser.userUsername,month];
    
    NSString *Finalquery= [query stringByAppendingString:@"ORDER BY goalpriority DESC;"];
    
    NSLog(@"%@",Finalquery);
    
    FMResultSet *result =[db executeQuery:Finalquery];
    
    
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
        goal.goalPriority=[result intForColumn:@"goalPriority"];
        
        [list addObject:goal];
    }
    return list;
}

-(NSMutableArray *) getinProgressGoalsFromDB :(NSInteger) month
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='0' AND isGoalinPregress='1' AND CreatedBy='%@' AND month <='%d' ",currentUser.userUsername,month];
    
    
    NSString *Finalquery= [query stringByAppendingString:@"ORDER BY goalpriority DESC;"];
    
    NSLog(@"%@",Finalquery);
    
    FMResultSet *result =[db executeQuery:Finalquery];
    
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
        goal.goalPriority=[result intForColumn:@"goalPriority"];
        
        [list addObject:goal];
    }
    return list;
}


-(NSMutableArray *) getCreatedGoalsFromDB :(NSInteger) month
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where  CreatedBy='%@' AND month='%d' ",currentUser.userUsername,month];
    
    
    NSString *Finalquery= [query stringByAppendingString:@"ORDER BY goalpriority DESC;"];
    
    NSLog(@"%@",Finalquery);
    
    FMResultSet *result =[db executeQuery:Finalquery];
    
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
        goal.goalPriority=[result intForColumn:@"goalPriority"];
        
        [list addObject:goal];
    }
    return list;
}


@end
