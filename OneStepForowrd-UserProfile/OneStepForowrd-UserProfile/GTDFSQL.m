//
//  GTDFSQL.m
//  MassTransitApp
//
//  Created by KHALID ALAHMARI on 11/8/13.
//  Copyright (c) 2013 Khalid. All rights reserved.
//


//create table users(id integer primary key,userFirstname text,userLastname text, userUsername text, userPassword text, userEmailAddres text, userProfileImage blob);

#import "GTDFSQL.h"

@implementation GTDFSQL

//-(NSString*) agencyName
//{
//    if (  _agencyName == nil)
//	{
//        SQLiteDB *Database= [SQLiteDB  databaseWithPath:self.dbpath];
//        
//        sqlite3* DBconnection=[Database getConnection];
//        
//        NSString* query = @"select agency_id from agency;";
//        sqlite3_stmt *statement;
//        const unsigned char* text;
//        
//        if (sqlite3_prepare_v2(DBconnection, [query UTF8String],
//                               [query length], &statement, nil) == SQLITE_OK) {
//            while (sqlite3_step(statement) == SQLITE_ROW) {
//                text = sqlite3_column_text(statement, 0);
//
//            if (text)
//                _agencyName = [NSString stringWithCString:
//                         (const char*)text encoding:NSUTF8StringEncoding];
//            else
//                _agencyName=nil;
//        }
//            
//        }
//    }
//	return _agencyName;
//}



//-(NSArray *) allRoutes
//{
//    SQLiteDB *Database= [SQLiteDB  databaseWithPath:self.dbpath];
//    sqlite3* DBconnection=[Database getConnection];
//    NSMutableArray *arrayList=[[NSMutableArray alloc]init];
//    NSString* query = @"SELECT route_id,route_long_name FROM routes ORDER BY route_id;";
//    sqlite3_stmt *statement;
//    NSString* TempRouteID;
//    NSString* TempRouteLongName;
//    
//    const unsigned char* text;
//    if (sqlite3_prepare_v2(DBconnection, [query UTF8String],
//                           [query length], &statement, nil) == SQLITE_OK)
//    {
//        while (sqlite3_step(statement) == SQLITE_ROW)
//        {
//            text = sqlite3_column_text(statement, 0);
//            if (text)
//            {
//                TempRouteID=[NSString stringWithCString:
//                       (const char*)text encoding:NSUTF8StringEncoding];
//            }
//                else
//
//                    TempRouteID = nil;
//            
//            text = sqlite3_column_text(statement, 1);
//            if (text)
//            {
//                TempRouteLongName=[NSString stringWithCString:
//                             (const char*)text encoding:NSUTF8StringEncoding];
//            }
//            else
//                
//                TempRouteLongName = nil;
//            
//            
//            Route *R=[[Route alloc]initWithrouteID:TempRouteID AndRouteLongName:TempRouteLongName];
//            
//            [arrayList addObject:R];
//
//        }
//        
//    }
//        sqlite3_finalize(statement);
//
//    return arrayList;
//}

//
//-(NSArray *) allStationInGivenRoute :(Route *) route
//{
//    SQLiteDB *Database= [SQLiteDB  databaseWithPath:self.dbpath];
//    sqlite3* DBconnection=[Database getConnection];
//    NSMutableArray *arrayList=[[NSMutableArray alloc]init];
//    
//    
//
//    //First Get the All the trips in a single a selected route, then get all the stops in a pulled trips, Final get the infomation we need about each single stops
//    
//    NSString *queryStart=@"select stop_id,stop_name,stop_lat,stop_lon from stops where stop_id IN (Select stop_id from stop_times where trip_id  IN (Select trip_id from trips INNER JOIN routes ON (trips.route_id=routes.route_id AND routes.route_id ='";
//    NSString* queryEnd = @"'))) ORDER BY stop_id;";
//    
//    NSString* Finalquery = [[queryStart stringByAppendingString:route.route_id] stringByAppendingString:queryEnd];
//    
//    sqlite3_stmt *statement;
//    NSString* StationID;
//    NSString* StationName;
//    double longitude, latitude;
//    
//    const unsigned char* text;
//    if (sqlite3_prepare_v2(DBconnection, [Finalquery UTF8String],                           [Finalquery length], &statement, nil) == SQLITE_OK)
//    {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            text = sqlite3_column_text(statement, 0);
//            if (text)
//                StationID = [NSString stringWithCString:
//                          (const char*)text encoding:NSUTF8StringEncoding];
//            else
//                StationID = nil;
//            
//            text = sqlite3_column_text(statement, 1);
//            if (text)
//                StationName = [NSString stringWithCString:
//                            (const char*)text encoding:NSUTF8StringEncoding];
//            else
//                StationName = nil;
//            
//            latitude = sqlite3_column_double(statement, 2);
//            
//            longitude = sqlite3_column_double(statement, 3);
//            
//            
//            Station *currentSt=[[Station alloc]initWithRouteID:route.route_id AndStationID:StationID AndStationName:StationName Andlatitude:latitude Andlongitud:longitude];
//            
//            //NSLog(@"DB %f",currentSt.latitude);
//            //NSLog(@"DB %f",currentSt.longitude);
//
//
//            [arrayList addObject:currentSt];
//            
//        }
//        
//        sqlite3_finalize(statement);
//    }
//        return arrayList;
//
//}



@end
