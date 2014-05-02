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
@synthesize currentUser;



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
    [dateFormatter setDateFormat:@"MM"];
    
    NSString *currentData= [dateFormatter stringFromDate:[NSDate date]];
    
    array=[self getGoalsListOfMonth:[currentData integerValue]];
    
    [self.tableview reloadData];
}


- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *currentData= [dateFormatter stringFromDate:_calendarView.selectedDate];
    
    //NSLog(@"%@",currentData);
    
    array=[self getGoalsList:currentData];
    
    [self.tableview reloadData];
    
}

-(void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
    
    NSInteger m = [month month];
    
    array=[self getGoalsListOfMonth:m];
    [self.tableview reloadData];


//    NSLog(@"ttt %d",m);
    
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
      //  NSLog(@"Fail to open");
        
    }
    

    NSString *qr=[NSString stringWithFormat:@"select * from Logs where logDate='%@' AND userUsername='%@'",Data,currentUser.userUsername];

    NSString *s=[qr stringByAppendingString:@"ORDER BY logDate DESC;"];
    
   // NSLog(@"RR %@",s);
    
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
        //NSLog(@"Fail to open");
        
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

@end

