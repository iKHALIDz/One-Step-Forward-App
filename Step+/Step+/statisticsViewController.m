//
//  statisticsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/16/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "statisticsViewController.h"

@interface statisticsViewController ()

@property NSArray *barHeights, *innerTitles, *underTitles;
@property CGFloat target;

@end

@implementation statisticsViewController

@synthesize inProgressArray;
@synthesize achievedArray;
@synthesize currentUser;
@synthesize pieChartRight = _pieChart;
@synthesize barChart=_barChart;


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
    
    
    self.scrollView.contentSize=self.contentView.bounds.size;
    self.scrollView.scrollEnabled=YES;

    
    inProgressArray=[[NSMutableArray alloc]init];
    achievedArray=[[NSMutableArray alloc]init];
    
    inProgressArray=[self getinProgressGoalsFromDB];
    achievedArray=[self getDoneGoalsFromDB];
    
    NSLog(@"%d",[inProgressArray count]);
    NSLog(@"%d",[achievedArray count]);
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setPieCenter:CGPointMake(135, 135)];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    [self.pieChartRight setShowPercentage:YES];
    
    
    
    ////// Bar ///
    self.barHeights = @[@80, @10 , @100, @80];
    
	self.innerTitles = @[@"Fri", @"Sat", @"Sun",@"Sun"];
	self.underTitles = @[@"Fri", @"Sat", @"Sun",@"Sun"];
	//self.target = 100;
    
	BENPedometerChart *chart = [[BENPedometerChart alloc] init];
	chart.translatesAutoresizingMaskIntoConstraints = NO;
	chart.dataSource = self;
	[self.barChart addSubview:chart];
    
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[chart]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chart)]];
//    
//	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chart]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chart)]];
//	
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:chart
//														  attribute:NSLayoutAttributeHeight
//														  relatedBy:NSLayoutRelationEqual
//															 toItem:self.view
//														  attribute:NSLayoutAttributeHeight
//														 multiplier:0.48
//                                                        constant:0]];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='1' AND isGoalinPregress='0' AND CreatedBy='%@'",currentUser.userUsername];
    
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

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    
    return 2;
    
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    if (index==0) {
        
        return [inProgressArray count];
    }
    else
    {
        return [achievedArray count];
        
    }
    
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if (index==0) {
        
        return [UIColor grayColor];
    }
    
    else
    {
        return [UIColor greenColor];
        
    }

    
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    if (index==0) {

        return @"In Progress Goals";
    }

    else
    {
        return @"Achieved Goals";

    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartRight reloadData];
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
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='0' AND isGoalinPregress='1' AND CreatedBy='%@'",currentUser.userUsername];
    
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

-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}


#pragma mark - bar chart data source

- (NSUInteger)numberOfBars
{
	return self.barHeights.count;
}

- (CGFloat)relativeHeightForBarAtIndex:(NSUInteger)barIndex
{
	NSNumber *height = [self.barHeights objectAtIndex:barIndex];
	return height.floatValue;
}

- (UIColor *)colorForBarAtIndex:(NSUInteger)barIndex
{
	//green = 100% of target, orange = 50%, otherwise red
	if ([self relativeHeightForBarAtIndex:barIndex] > self.target)
	{
		return [UIColor colorWithRed:0.3 green:0.85 blue:0.25 alpha:1.0];
	}
	else if ([self relativeHeightForBarAtIndex:barIndex] > self.target / 2)
	{
		return [UIColor colorWithRed:0.96 green:0.47 blue:0.15 alpha:1.0];
	}
	else
	{
		return [UIColor colorWithRed:0.97 green:0.22 blue:0.24 alpha:1.0];
	}
    
	return nil;
}

- (NSString *)innerTitleForBarAtIndex:(NSUInteger)barIndex
{
	return [self.innerTitles objectAtIndex:barIndex];
}

- (NSString *)underTitleForBarAtIndex:(NSUInteger)barIndex
{
	return [self.underTitles objectAtIndex:barIndex];
}

- (NSString *)overTitleForBarAtIndex:(NSUInteger)barIndex
{
	NSNumberFormatter *formatter = [NSNumberFormatter new];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return [formatter stringFromNumber:[self.barHeights objectAtIndex:barIndex]];
}

- (CGFloat)relativeHeightForTargetLine
{
	return self.target;
}


- (UIColor *)colorForTargetLine
{
	return [UIColor colorWithRed:0.3 green:0.85 blue:0.25 alpha:1.0];
}


@end
