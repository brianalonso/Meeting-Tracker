//
//  PreferenceController.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/24/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "PreferenceController.h"

NSString *keyAttendeeHourlyRate = @"attendeeHourlyRate";
NSString *keyAttendees = @"meetingAttendees";
NSString *keyAttendeeName = @"attendeeDefaultName";


@implementation PreferenceController

// Class methods
+ (NSString *)preferenceAttendeeName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:keyAttendeeName];
}
+ (void)setPreferenceAttendeeName:(NSString *)aAttendeeName
{
    [[NSUserDefaults standardUserDefaults] setValue:aAttendeeName forKey:keyAttendeeName];
}

+ (NSNumber *)preferenceHourlyRate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults valueForKey:keyAttendeeHourlyRate];
}
+ (void)setPreferenceHourlyRate:(NSNumber *)aHourlyRate
{
    [[NSUserDefaults standardUserDefaults] setValue:aHourlyRate forKey:keyAttendeeHourlyRate];
}

+ (NSNumber *)preferenceAttendees
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults valueForKey:keyAttendees];
}
+ (void)setPreferenceAttendees:(NSNumber *)aAttendees
{
    [[NSUserDefaults standardUserDefaults] setValue:aAttendees forKey:keyAttendees];
}

// Instance methods
- (id)init
{
    self = [super initWithWindowNibName:@"PreferenceController"];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Set the preference values
    [[self txtAttendeeName] setStringValue:[PreferenceController preferenceAttendeeName]];
    [[self txtHourlyRate] setObjectValue:[PreferenceController preferenceHourlyRate]];
    [[self lblMeetingAttendees] setObjectValue:[PreferenceController preferenceAttendees]];
}


// Respond to the slider move
- (IBAction)sliderMoved:(id)sender {
    // Convert the value to a float
    float sliderFloat = [[self sliderHourlyRate] floatValue];
    
    [[self txtHourlyRate] setFloatValue:sliderFloat];
}

// User clicked the Save preferences
- (IBAction)btnSave:(id)sender {
    [PreferenceController setPreferenceAttendeeName:[[self txtAttendeeName] stringValue]];
    [PreferenceController setPreferenceAttendees:[NSNumber numberWithInteger:[[self lblMeetingAttendees] integerValue]]];
    [PreferenceController setPreferenceHourlyRate:[NSNumber numberWithDouble:[[self txtHourlyRate] doubleValue]]];
}

// User clicked the Reset button
- (IBAction)btnReset:(id)sender {
}
@end
