//
//  CustomTests.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "CustomTests.h"
#import "Person.h"

@implementation CustomTests {
    Person *person;
}


- (void)setUp
{
    [super setUp];
    
    // Instantiate a person object for the tests
    person = [[Person alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    // Release the person object
    [person release];
}

- (void)testParticipantName
{
    
    [person setName:@"Brian"];
    STAssertEqualObjects(@"Brian", [person name], @"Test #1: Failed.  Name Mismatch");
}

- (void)testSetHourlyRate
{
    [person setHourlyRate:40.1];
    STAssertEqualObjects([NSNumber numberWithDouble:40.1], [person hourlyRate], @"Test #2: Failed.  Hourly rate incorrect");
}
@end
