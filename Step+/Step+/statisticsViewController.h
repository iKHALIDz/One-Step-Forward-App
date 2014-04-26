//
//  statisticsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/16/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "Goal.h"
#import "FMDatabase.h"
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "BENPedometerChart.h"
#import "BENPedometerBarView.h"

@interface statisticsViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource,BENPedometerChartDataSource>

@property (nonatomic,strong) User *currentUser;
@property(nonatomic,retain) NSMutableArray *inProgressArray;
@property(nonatomic,retain) NSMutableArray *achievedArray;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property (strong,nonatomic) IBOutlet BENPedometerBarView *barChart;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end


