//
//  CalenderLogsEventsViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 3/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "CalenderLogsEventsViewController.h"

@interface CalenderLogsEventsViewController ()


@end

@implementation CalenderLogsEventsViewController

@synthesize calendar,dateFormatter,selctedDate;


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
    
    calendar = [[CKCalendarView alloc] init];
    [self.CalenderView addSubview:calendar];
    
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    
    selctedDate=[self.dateFormatter stringFromDate:date];
    NSLog(@"%@",selctedDate);
    
//    NSMutableArray *array=[self getGoalsList:selctedDate];
    
    //if ([array count] != 0)
   // {
     //   NSLog(@"%@",[[array objectAtIndex:0]goalName]);
    //}
    
}


-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}


/*
-(NSMutableArray *) getGoalsList:(NSString*)Data
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *qr=[NSString stringWithFormat:@"select * from Goals where goalDate='%@';",Data];
    
    
    FMResultSet *result =[db executeQuery:qr];
    
    while ([result next])
    {
        NSLog(@"44");
        
        Goal *goal=[[Goal alloc]init];
        goal.goalID=[result intForColumn:@"goalId"];
        goal.goalName=[result stringForColumn:@"GoalName"];
        goal.goalDescription=[result stringForColumn:@"GoalDesc"];
        goal.goalDeadline=[result stringForColumn:@"GoalDeadline"];
        goal.isGoalCompleted=[result intForColumn:@"isGoalCompleted"];
        goal.isGoalinProgress=[result intForColumn:@"isGoalinPregress"];
        goal.goalProgress=[result doubleForColumn:@"goalPercentage"];
        goal.createdBy =[result stringForColumn:@"CreatedBy"];
        goal.goalDate=[result stringForColumn:@"goalDate"];
        [list addObject:goal];
    }
    return list;
}
*/

@end

