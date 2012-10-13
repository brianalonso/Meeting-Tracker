//
//  Meeting.h
//  Meeting Tracker
//
//  Created by CP120 on 10/8/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject
{
    NSDate *_startingTime;
	NSDate *_endingTime;
	
	NSMutableArray *_personsPresent;
}

- (NSDate *)startingTime;
- (void)setStartingTime:(NSDate *)aStartingTime;
- (NSDate *)endingTime;
- (void)setEndingTime:(NSDate *)anEndingTime;
- (NSMutableArray *)personsPresent;
- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent;
- (void)addToPersonsPresent:(id)personsPresentObject;
- (void)removeFromPersonsPresent:(id)personsPresentObject;

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx;

- (NSUInteger)countOfPersonsPresent;
- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;

- (NSNumber *)accruedCost;
- (NSNumber *)totalBillingRate;

+ (Meeting *)meetingWithStooges;
+ (Meeting *)meetingWithCaptains;
+ (Meeting *)meetingWithMarxBrothers;

@end
