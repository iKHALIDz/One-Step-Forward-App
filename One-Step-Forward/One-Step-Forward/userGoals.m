//
//  userGoals.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "userGoals.h"

@implementation userGoals

@synthesize goalsdescription,goalsName,goalDeadline;


- (void)viewDidLoad
{
    
    goalsName=[[NSMutableArray alloc]initWithObjects:@"Ahmed",@"Ali",nil];
    goalsdescription=[[NSMutableArray alloc]initWithObjects:@"Ahmed Description",@"Ali Description",nil];
    goalDeadline = [[NSMutableArray alloc]initWithObjects:@"22/5/2013",@"22/5/2014",nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [goalsName count];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    goalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.goalDescription.text=[goalsdescription objectAtIndex:indexPath.row];
    //cell.goalDeadline.text = [goalDeadline objectAtIndex:indexPath.row];
    cell.goalName.text=[goalsName objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
