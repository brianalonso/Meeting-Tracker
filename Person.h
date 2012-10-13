//
//  Person.h
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    NSString   *_name;
    NSNumber   *_hourlyRate;
}

// Properties
- (NSString *)name;
- (void)setName:(NSString *)aParticipantName;
- (NSNumber *) hourlyRate;
- (void) setHourlyRate:(double) rate;

+ (Person *)personWithName:(NSString *)name
                hourlyRate:(double)rate;
- (id)initWithName:(NSString*)aParticipantName rate:(double)aRate;

@end
