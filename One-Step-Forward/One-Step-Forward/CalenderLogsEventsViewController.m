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

@synthesize calenderLog;
@synthesize array;
@synthesize currentUserID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320,450)];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _calendarView = [[RDVCalendarView alloc] initWithFrame:applicationFrame];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    
    [_calendarView setFrame:CGRectMake(3, -80, 320,360)];
    
    [self.scroller addSubview: _calendarView];
    
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
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *currentData= [dateFormatter stringFromDate:[NSDate date]];
    array=[self getGoalsList:currentData];
    [self.tableview reloadData];
}


- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *currentData= [dateFormatter stringFromDate:_calendarView.selectedDate];
    
    NSLog(@"%@",currentData);
    
    array=[self getGoalsList:currentData];
    
    [self.tableview reloadData];
    
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
    
    
    if ([[[array objectAtIndex:indexPath.row]logType] isEqualToString:@"Goal"])
    {
         cell.picContent.image=[UIImage imageNamed:@"G.png"];
    }
    else
    {
        cell.picContent.image=[UIImage imageNamed:@"P.png"];
    }
    
    
    
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
    
    NSString *qr=[NSString stringWithFormat:@"select * from Logs where logDate='%@' AND userID='%d';",Data,[currentUserID integerValue]];
    
    
    FMResultSet *result =[db executeQuery:qr];
    
    while ([result next])
    {
         Log*log=[[Log alloc]init];
        
        log.logID=[result intForColumn:@"logID"];
        log.userID=[result intForColumn:@"userID"];
        log.logDate=[result stringForColumn:@"logDate"];
        log.logAction=[result stringForColumn:@"logAction"];
        log.logContent=[result stringForColumn:@"logContent"];
        log.logType=[result stringForColumn:@"logType"];
        [list addObject:log];
    }
    
    return list;
}


@end

