//
//  PreferenceController.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/24/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "PreferenceController.h"

NSString *const keyAttendeeHourlyRate = @"attendeeHourlyRate";
NSString *const keyAttendees = @"meetingAttendees";
NSString *const keyAttendeeName = @"attendeeDefaultName";
NSString *const keyAttendeeGridBackgroundColor = @"attendeeGridBackgroundColor";

// Notification constants
NSString *const notificationKeyAttendeeHourlyRate = @"notificationAttendeeHourlyRate";
NSString *const notificationKeyAttendees = @"notificationMeetingAttendees";
NSString *const notificationKeyAttendeeName = @"notificationAttendeeDefaultName";
NSString *const notificationKeyAttendeeGridBackgroundColor = @"notificationAttendeeGridBackgroundColor";

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

+ (NSColor *)preferenceTableBgColor
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorAsData = [defaults objectForKey:keyAttendeeGridBackgroundColor];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}
+ (void)setPreferenceTableBgColor:(NSColor *)color
{
	NSData *colorAsData =
	[NSKeyedArchiver archivedDataWithRootObject:color];
	[[NSUserDefaults standardUserDefaults] setObject:colorAsData
											  forKey:keyAttendeeGridBackgroundColor];
}

// Instance methods
- (id)init
{
    self = [super initWithWindowNibName:@"PreferenceController"];
    if (self) {
        // Add ourselves as an observer in case a meeting attendee is added
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
			   selector:@selector(handleAttendeeCountChange:)
				   name:notificationKeyAttendees
				 object:nil];
		NSLog(@"Registered with notification center");
    }
    return self;
}

- (void)loadPreferenceValues
{
    // Load the preference values
    [[self txtAttendeeName] setStringValue:[PreferenceController preferenceAttendeeName]];
    [[self txtHourlyRate] setObjectValue:[PreferenceController preferenceHourlyRate]];
    //[[self lblMeetingAttendees] setObjectValue:[PreferenceController preferenceAttendees]];
    [[self lblMeetingAttendees] setStringValue:@"0"];
    
    [[self colorWell] setColor:[PreferenceController preferenceTableBgColor]];
    
    // Launch the notification center to notify the app of
    // any preferences changes (in case the user reset to factory defaults)
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[PreferenceController preferenceTableBgColor]
                                                         forKey:keyAttendeeGridBackgroundColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSLog(@"Sending notifications");
    [nc postNotificationName:notificationKeyAttendeeGridBackgroundColor
                      object:self
                    userInfo:dict];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self loadPreferenceValues];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	return YES;
}

// Respond to the slider move
- (IBAction)sliderMoved:(id)sender {
    // Convert the slider value to a float
    [[self txtHourlyRate] setFloatValue:[[self sliderHourlyRate] floatValue]];
}

// User clicked the Save preferences
- (IBAction)btnSave:(id)sender {
    [PreferenceController setPreferenceAttendeeName:[[self txtAttendeeName] stringValue]];
    //[PreferenceController setPreferenceAttendees:[NSNumber numberWithInteger:[[self lblMeetingAttendees] integerValue]]];
    [PreferenceController setPreferenceHourlyRate:[NSNumber numberWithDouble:[[self txtHourlyRate] doubleValue]]];
    
    // Save the background color
    NSColor *color = [[self colorWell] color];
	[PreferenceController setPreferenceTableBgColor:color];
    
    // Launch the notification center to notify the app of
    // any preferences changes
	NSDictionary *dict = [NSDictionary dictionaryWithObject:color
												  forKey:keyAttendeeGridBackgroundColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"Sending notifications");
	[nc postNotificationName:notificationKeyAttendeeGridBackgroundColor
					  object:self
					userInfo:dict];
}

// User clicked the Reset button
- (IBAction)btnReset:(id)sender {
    
    // Remove all of the preference values from the standardUserDefaults
    // NOTE: Don't remove the keyAttendees which keeps track of the number of attendees
    NSArray *allDefaultKeys = [NSArray arrayWithObjects:keyAttendeeHourlyRate, keyAttendeeName, keyAttendeeGridBackgroundColor, nil];
    
    // Use fast enumeration to walk through the list of dictionary Preference keys
	for (NSString *key in allDefaultKeys)
	{
        // Remove the preference from the standardUserDefaults
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	}
	[self loadPreferenceValues];
}

// Notification: meeting attendees changed
- (void)handleAttendeeCountChange:(NSNotification *)notification
{
    // Update the label
	NSLog(@"Received notification: %@", notification);
	NSNumber *attendees = [[notification userInfo] objectForKey:keyAttendees];
    NSInteger countOfAttendees = [[self lblMeetingAttendees] integerValue];
    countOfAttendees += [attendees integerValue];
	[[self lblMeetingAttendees] setStringValue:[NSString stringWithFormat:@"%li",countOfAttendees]];
}
@end
