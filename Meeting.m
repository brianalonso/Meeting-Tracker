//
//  Meeting.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/12/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

#pragma mark -
#pragma mark Class methods

+ (Meeting *)meetingWithStooges
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
    [m setStartingTime:[NSDate date]];
    [m setEndingTime:[NSDate date]];
    
    Person *p;
    p = [[Person alloc] initWithName:@"Moe" rate:100.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Larry" rate:75.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Curly" rate:50.];
    [m addToPersonsPresent:[p autorelease]];
   
    p = [[Person alloc] initWithName:@"Shemp" rate:25.];
    [m addToPersonsPresent:[p autorelease]];
   
    return m;
}

+ (Meeting *)meetingWithMarxBrothers
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
    [m setStartingTime:[NSDate date]];
    [m setEndingTime:[NSDate date]];
    
    Person *p;
    p = [[Person alloc] initWithName:@"Harpo" rate:100.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Groucho" rate:75.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Chico" rate:50.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Gummo" rate:25.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Zeppo" rate:10.];
    [m addToPersonsPresent:[p autorelease]];
    
    return m;
}

+ (Meeting *)meetingWithCaptains
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
    [m setStartingTime:[NSDate date]];
    [m setEndingTime:[NSDate date]];
    
    Person *p;
    p = [[Person alloc] initWithName:@"Kirk" rate:100.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Archer" rate:75.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Janeway" rate:50.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Picard" rate:50.];
    [m addToPersonsPresent:[p autorelease]];

    return m;
}

#pragma mark -
#pragma mark Initialization

- (id)init 
{
    self = [super init];
    if (self)
    {
        // set the PersonsPresent array to nil as it will lazy load
        _personsPresent = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Instance methods

- (NSMutableArray *)personsPresent
{
    if (_personsPresent == nil) {
        // Lazy loading of personsPresent arrary
        [_personsPresent = [[NSMutableArray alloc] init] autorelease];
    }
    
    return _personsPresent;
}

- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent
{
    if (_personsPresent != nil) {
        [_personsPresent release];
    }
    _personsPresent = aPersonsPresent;
}

- (void) addToPersonsPresent:(id)personsPresentObject
{
    [[self personsPresent] addObject:personsPresentObject];
}

- (void) removeFromPersonsPresent:(id)personsPresentObject
{
    [[self personsPresent] removeObject:personsPresentObject];
}

- (void) removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    [[self personsPresent] removeObjectAtIndex:idx];
}

- (void) insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx
{
    [[self personsPresent] insertObject:anObject atIndex:idx];
}

- (NSDate *) startingTime
{
    return _startingTime;
}

- (void) setStartingTime:(NSDate *)aStartingTime
{
    if (_startingTime != aStartingTime) {
        [_startingTime release];
    }
    _startingTime = [aStartingTime retain];
}

- (NSDate *) endingTime
{
    return _endingTime;
}

- (void) setEndingTime:(NSDate *)anEndingTime
{
    if (_endingTime != anEndingTime) {
        [_endingTime release];
    }
    _endingTime = [anEndingTime retain];
}

- (NSUInteger)countOfPersonsPresent
{
    return [[self personsPresent] count];
}

- (NSNumber *) totalBillingRate
{
    double totalrate = 0.;
    
    for (Person *person in [self personsPresent])
    {
        totalrate += [[person hourlyRate] doubleValue];
    }
    return [NSNumber numberWithDouble:totalrate];
}

- (NSNumber *) accruedCost
{
    double totalcost = 0.;
    
    for (Person *person in [self personsPresent])
    {
        totalcost += [[person hourlyRate] doubleValue];
    }
    return [NSNumber numberWithDouble:totalcost * [self elapsedHours]];

}

- (NSUInteger) elapsedSeconds
{
    NSTimeInterval secondsBetween = [[self endingTime] timeIntervalSinceDate:[self startingTime]];
    return secondsBetween;
}

- (double) elapsedHours
{
    NSTimeInterval secondsBetween = [[self endingTime] timeIntervalSinceDate:[self startingTime]];
    double hoursBetween = secondsBetween/3600.;

    return hoursBetween;
}

- (NSString *) elapsedTimeDisplayString
{
    NSTimeInterval elapsedTime = [[self endingTime] timeIntervalSinceDate:[self startingTime]];
    return [NSString stringWithFormat:@"%.2f", -elapsedTime];
}

- (void) dealloc
{
    // Release retained objects
    [_startingTime release];
    [_endingTime release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Description method

- (NSString *) description
{
    return [NSString stringWithFormat:@"<Meeting: %lu participants %@/hour>",[self countOfPersonsPresent], [self totalBillingRate]];
}

@end
