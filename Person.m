//
//  Person.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "Person.h"

@implementation Person

NSString *keyPersonName = @"name";
NSString *keyHourlyRate = @"hourlyRate";

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
    return [self initWithName:@"<name>"
                         rate:20.0];
}
- (id)initWithName:(NSString *)aParticipantName
              rate:(double)aRate
{
    self = [super init];
    if (self)
    {
        // Assign values to the ivars directly
        _name = [aParticipantName copy];
        _hourlyRate = [[NSNumber numberWithDouble:aRate] retain];
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
        _name = [aParticipantName copy];
    }
   }

- (NSNumber *) hourlyRate
{
    return _hourlyRate;
}

- (void) setHourlyRate:(NSNumber *) anHourlyRate
{
    if (_hourlyRate != anHourlyRate) {
        [_hourlyRate release];
         _hourlyRate = [anHourlyRate retain];
    }
}

#pragma mark -
#pragma mark Archiving methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // Don't uses accessors since this is a type of initializer
    [encoder encodeObject:_name forKey:keyPersonName];
    [encoder encodeObject:_hourlyRate forKey:keyHourlyRate];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        // Don't uses accessors since this is a type of initializer
        // Retain the objects
        _name = [[decoder decodeObjectForKey:keyPersonName] retain];
        _hourlyRate = [[decoder decodeObjectForKey:keyHourlyRate]retain];
    }
    return self;
}


#pragma mark -
#pragma mark Description method

- (NSString *) description
{
    return [NSString stringWithFormat:@"<Person: %@  rate: %@>",[self name], [self hourlyRate]];
}

- (void) dealloc
{
    [_name release];
    _name = nil;
    
    [_hourlyRate release];
    _hourlyRate = nil;
    
    [super dealloc];
}

@end
