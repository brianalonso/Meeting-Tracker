//
//  Meeting.h
//  Meeting Tracker
//
//  Created by CP120 on 10/8/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *personBillingRateKeypath;

@interface Meeting : NSObject <NSCoding>
{
    NSDate *_startingTime;
	NSDate *_endingTime;
	NSMutableArray *_personsPresent;
    NSUndoManager *_undo;
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

- (BOOL) meetingInProgress;

+ (Meeting *)meetingWithStooges;
+ (Meeting *)meetingWithCaptains;
+ (Meeting *)meetingWithMarxBrothers;

@end
