//
//  Person.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark -
#pragma mark Class methods

+ (Person *)personWithName:(NSString *)name
                hourlyRate:(double)rate
{
    Person *p = [[[Person alloc] initWithName:name rate:rate] autorelease];
    return p;
}

#pragma mark -
#pragma mark Initialization

- (id)init {
    return [self initWithName:@"some person"
                         rate:0.0];
}
- (id)initWithName:(NSString *)aParticipantName
              rate:(double)aRate
{
    self = [super init];
    if (self)
    {
        _name = aParticipantName;
        _hourlyRate = [NSNumber numberWithDouble:aRate];
    }
    return self;
}

#pragma mark -
#pragma mark Properties

- (NSString *) name
{
    return _name;
}

- (void) setName:(NSString *)aParticipantName
{
    if (_name != aParticipantName) {
        [_name release];
    }
    _name = [aParticipantName copy];
}

- (NSNumber *) hourlyRate
{
    return _hourlyRate;
}

- (void) setHourlyRate:(double) anHourlyRate
{
    if (_hourlyRate != [NSNumber numberWithDouble:anHourlyRate]) {
        [_hourlyRate release];
    }
    _hourlyRate = [[NSNumber numberWithDouble:anHourlyRate] retain];
}

#pragma mark -
#pragma mark Description method

- (NSString *) description
{
    return [NSString stringWithFormat:@"<participant: %@  rate: %@>",[self name], [self hourlyRate]];
}

- (void) dealloc
{
    [super dealloc];
}

@end
