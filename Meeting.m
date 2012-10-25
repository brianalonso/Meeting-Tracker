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

NSString *personBillingRateKeypath = @"hourlyRate";

NSString *keyStartingTime = @"startingTime";
NSString *keyEndingTime = @"endingTime";
NSString *keyPersonsPresent = @"personsPresent";

#pragma mark -
#pragma mark Class methods

+ (Meeting *)meetingWithStooges
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
    
    Person *p;
    p = [[Person alloc] initWithName:@"Moe" rate:100.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Larry" rate:75.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Curly" rate:50.];
    [m addToPersonsPresent:[p autorelease]];
   
    p = [[Person alloc] initWithName:@"Shemp" rate:25.];
    [m addToPersonsPresent:[p autorelease]];
   
    [m startObservingPersonsPresent];
    return m;
}

+ (Meeting *)meetingWithMarxBrothers
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
    
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
    
    [m startObservingPersonsPresent];
    return m;
}

+ (Meeting *)meetingWithCaptains
{
    Meeting *m = [[[Meeting alloc] init] autorelease];
        
    Person *p;
    p = [[Person alloc] initWithName:@"Kirk" rate:100.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Archer" rate:75.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Janeway" rate:50.];
    [m addToPersonsPresent:[p autorelease]];
    
    p = [[Person alloc] initWithName:@"Picard" rate:50.];
    [m addToPersonsPresent:[p autorelease]];

    [m startObservingPersonsPresent];
    return m;
}

+ (NSSet *)keyPathsForValuesAffectingTotalBillingRate
{
    // to determine when total billing rate changes, need
    // to observe personsPresent
    return [NSSet setWithObject:@"personsPresent"];
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        // Alloc the personsPresent array
        _personsPresent = [[[NSMutableArray alloc] init] retain];
    }
    return self;
}

#pragma mark -
#pragma mark Instance methods

- (NSMutableArray *)personsPresent
{
    
    if (_personsPresent == nil) {
        // Lazy loading of personsPresent arrary
        [_personsPresent = [[NSMutableArray alloc] init] retain];
    }
    
    return _personsPresent;
}

- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent
{
    if (_personsPresent != nil) {
        [aPersonsPresent retain];
        
        // stop observing
        [self stopObservingPersonsPresent];
        [_personsPresent release];
        _personsPresent = aPersonsPresent;
        
        // start observing
        [self startObservingPersonsPresent];
    }
}

- (void)stopObservingPersonsPresent
{
    // Remove self as an observer for the hourlyRate
    for (Person *p in _personsPresent) {
        [p removeObserver:self forKeyPath:personBillingRateKeypath];
    }
}

- (void) startObservingPersonsPresent
{
    // Add self as an observer for the hourlyRate
    for (Person *p in _personsPresent) {
        [p addObserver:self forKeyPath:personBillingRateKeypath options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void) addToPersonsPresent:(id)personsPresentObject
{
    [[self personsPresent] addObject:personsPresentObject];
}

- (void) removeFromPersonsPresent:(id)personsPresentObject
{
    // remove person from the array
    [[self personsPresent] removeObject:personsPresentObject];
}

- (void) removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    // remove the observer for the hourly rate
    [[[self personsPresent] objectAtIndex:idx] removeObserver:self forKeyPath:personBillingRateKeypath];
    
    // Remove the person from the array
    [[self personsPresent] removeObjectAtIndex:idx];
}

- (void) insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx
{
    // Add a person to the array
    [[self personsPresent] insertObject:anObject atIndex:idx];
    
    // start observing the hourly rate
    [anObject addObserver:self forKeyPath:personBillingRateKeypath options:NSKeyValueObservingOptionNew context:nil];
}

- (NSDate *) startingTime
{
    return _startingTime;
}

- (void) setStartingTime:(NSDate *)aStartingTime
{
    if (_startingTime != aStartingTime) {
        [aStartingTime retain];
        [_startingTime release];
        _startingTime = aStartingTime;
    }
}

- (NSDate *) endingTime
{
    return _endingTime;
}

- (void) setEndingTime:(NSDate *)anEndingTime
{
    if (_endingTime != anEndingTime) {
        [anEndingTime retain];
        [_endingTime release];
        _endingTime = anEndingTime;
    }
}

- (NSUInteger)countOfPersonsPresent
{
    // Don't lazy load if just checking the count
    if (_personsPresent == nil) {
        return 0;
    }
    return [[self personsPresent] count];
    
}

- (NSNumber *) totalBillingRate
{
    /*
    double totalrate = 0.;
    
    for (Person *person in [self personsPresent])
    {
        totalrate += [[person hourlyRate] doubleValue];
    }
    return [NSNumber numberWithDouble:totalrate];
    */
    
    // Using a block
    return [NSNumber numberWithDouble:[self blockComputedTotalBillingRate]];
}

- (double)blockComputedTotalBillingRate
{
    __block double total = 0.;
    [[self personsPresent] enumerateObjectsUsingBlock:^(Person *p, NSUInteger idx, BOOL *stop) {
        total += [[p hourlyRate] doubleValue];
    }];
    return total;
}

- (NSNumber *) accruedCost
{
    double totalcost = 0.;
    
    for (Person *person in [self personsPresent])
    {
        totalcost += [[person hourlyRate] doubleValue];
    }
    return [NSNumber numberWithDouble:totalcost * [self elapsedHours]];
    
    // Using a block
    // return [NSNumber numberWithDouble: [self blockComputedTotalBillingRate] * [self elapsedHours]];

}

#pragma mark -
#pragma mark Key-Value methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Update the total billing rate
    [self totalBillingRate];
}


#pragma mark -
#pragma mark Archiving methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // Don't uses accessors since this is a type of initializer
    [encoder encodeObject:_startingTime forKey:keyStartingTime];
    [encoder encodeObject:_endingTime forKey:keyEndingTime];
    [encoder encodeObject:_personsPresent forKey:keyPersonsPresent];
    
    NSLog(@"encodeWithCoder built %@ %@ %@", _startingTime, _endingTime, _personsPresent);
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
	if (self) 
    {
        // Don't uses accessors since this is a type of initializer
        _startingTime = [[decoder decodeObjectForKey:keyStartingTime] retain];
        _endingTime = [[decoder decodeObjectForKey:keyEndingTime] retain];
        _personsPresent = [[decoder decodeObjectForKey:keyPersonsPresent]retain];
        
        NSLog(@"initWithCoder built %@ %@ %@",  _startingTime, _endingTime, _personsPresent);
    }
    return self;
}

#pragma mark -
#pragma mark Meeting timing methods

- (BOOL) meetingInProgress
{
    // Return true if a meeting is in progress
    return (![self startingTime]);
}

// Elapsed seconds between the starting date and now
- (NSUInteger) elapsedSeconds
{
    NSUInteger seconds = 0;
    
    // Check if there is a meeting ending time
    if (![self endingTime]) {
        seconds = -1 * [[self startingTime] timeIntervalSinceNow];
    }
    else
    {
        seconds = [[self endingTime] timeIntervalSinceDate:[self startingTime]];
    }
    return seconds;
}

// Elapsed hours between the starting date and now
- (double) elapsedHours
{
    return [self elapsedSeconds]/3600.;
}

// Elapsed time of meeting
- (NSString *) elapsedTimeDisplayString
{
    NSUInteger elapsedSeconds = [self elapsedSeconds];
    NSUInteger displaySeconds;
    NSUInteger displayMinutes;
    NSUInteger displayHours;
    
    displayHours = elapsedSeconds / 3600;
    displayMinutes = (elapsedSeconds / 60) % 60;
    displaySeconds = elapsedSeconds % 60;
   
    return [NSString stringWithFormat:@"%0ld:%02ld:%02ld", displayHours, displayMinutes, displaySeconds];
}

- (void) dealloc
{
    // Release retained objects
    [_startingTime release];
    _startingTime = nil;
    [_endingTime release];
    _endingTime = nil;
    
    [_personsPresent release];
    _personsPresent = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Description method

- (NSString *) description
{
    return [NSString stringWithFormat:@"<Meeting: %lu participants %@/hour>",[self countOfPersonsPresent], [self totalBillingRate]];
}

@end
