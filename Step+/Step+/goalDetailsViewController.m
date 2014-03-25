//
//  goalDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/24/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "goalDetailsViewController.h"

@interface goalDetailsViewController ()

@end

@implementation goalDetailsViewController

@synthesize currentGoal;

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
    
    NSLog(@"Goal Type %@",currentGoal.goalType);
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320,1000)];

    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.GoalNameLable.text=currentGoal.goalName;
    self.GoalDescriptionLable.text=currentGoal.goalDescription;
    self.GoalTypeLable.text=currentGoal.goalType;
    self.TotalPercentageLable.text=[[NSString stringWithFormat:@"%.2f",currentGoal.goalProgress] stringByAppendingString:@"%"];
    
    self.NumberofStepsTakenLable.text=[NSString stringWithFormat:@"Step Taken: %d",currentGoal.numberOfGoalSteps];
    
    NSInteger days=[self daysBetweenDate:currentGoal.goalDate andDate:[self getCurrentDataAndTime]];
    NSInteger days2=[self daysBetweenDate:[self getCurrentDataAndTime] andDate:currentGoal.goalDeadline];
    
    self.numberofDaysSinceCreated.text=[NSString stringWithFormat:@"Number of days since Createted: %d",days];
    
    self.NumberofdaysyillDeadline.text=[NSString stringWithFormat:@"Number of days till Deadline %d",days2];

}


-(NSInteger)daysBetweenDate:(NSString*)fromDateTime andDate:(NSString*)toDateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"mm/dd/yyyy"];
    
    NSDate *fromDate = [format dateFromString: fromDateTime];
    NSDate *toDate = [format dateFromString: toDateTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDate];
    
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}


-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

@end
