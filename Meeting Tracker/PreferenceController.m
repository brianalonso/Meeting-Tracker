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
NSString *const keyAttendeesCumulative = @"meetingAttendeesCumulative";

// Notification constants
NSString *const notificationKeyAttendeeHourlyRate = @"notificationAttendeeHourlyRate";
NSString *const notificationKeyAttendees = @"notificationMeetingAttendees";
NSString *const notificationKeyAttendeeName = @"notificationAttendeeDefaultName";
NSString *const notificationKeyAttendeeGridBackgroundColor = @"notificationAttendeeGridBackgroundColor";
NSString *const notificationKeyAttendeesCumulative = @"notificationMeetingAttendeesCumulative";
NSString *const notificationKeyGetCurrentAttendees = @"notificationGetCurrentAttendees";
NSString *const notificationKeyReplyCurrentAttendees = @"notificationReplyCurrentAttendees";

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

+ (NSNumber *)preferenceAttendeesCumulative
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults valueForKey:keyAttendeesCumulative];
}
+ (void)setPreferenceAttendeesCumulative:(NSNumber *)aAttendeesCumulative
{
    [self willChangeValueForKey:keyAttendeesCumulative];
    
    [[NSUserDefaults standardUserDefaults] setValue:aAttendeesCumulative forKey:keyAttendeesCumulative];

    [self didChangeValueForKey:keyAttendeesCumulative];
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
        // so we can update the 'real time' value
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
			   selector:@selector(handleAttendeeCountChange:)
				   name:notificationKeyAttendees
				 object:nil];
        
        [nc addObserver:self
			   selector:@selector(handleAttendeeTotalCount:)
				   name:notificationKeyReplyCurrentAttendees
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

- (void)savePreferenceValues
{
    [PreferenceController setPreferenceAttendeeName:[[self txtAttendeeName] stringValue]];
    [PreferenceController setPreferenceHourlyRate:[NSNumber numberWithDouble:[[self txtHourlyRate] doubleValue]]];
    
    // Save the background color
    NSColor *color = [[self colorWell] color];
	[PreferenceController setPreferenceTableBgColor:color];
    
    // Launch the notification center to notify the app of
    // any preferences changes for the grid background color
	NSDictionary *dict = [NSDictionary dictionaryWithObject:color
                                                     forKey:keyAttendeeGridBackgroundColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"Sending grid color notification");
	[nc postNotificationName:notificationKeyAttendeeGridBackgroundColor
					  object:self
					userInfo:dict];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Post to allow documents to send all of their current attendees to
    // support the 'real time' counter
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notificationKeyGetCurrentAttendees
                      object:self
                    userInfo:nil];
    
    [self loadPreferenceValues];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	return YES;
}

#pragma mark -
#pragma mark Action methods

// Respond to the slider move
- (IBAction)sliderMoved:(id)sender {
    // Convert the slider value to a float
    [[self txtHourlyRate] setFloatValue:[[self sliderHourlyRate] floatValue]];
}

// User clicked the Save preferences
- (IBAction)btnSave:(id)sender {
    [self savePreferenceValues];
}

// User clicked the Reset button
- (IBAction)btnReset:(id)sender {
    
    // Show the user an alert
    NSAlert *alert = [NSAlert alertWithMessageText:
					  @"Do you really want to reset the preferences?"
									 defaultButton:@"OK"
								   alternateButton:@"Cancel"
									   otherButton:nil
						 informativeTextWithFormat:@"All preferences values will be reset to their factory defaults"
					  ];
	NSLog(@"Starting alert sheet");
	[alert beginSheetModalForWindow:[[self sliderHourlyRate] window]
					  modalDelegate:self
					 didEndSelector:@selector(alertEnded:code:context:)
						contextInfo:NULL];
}
- (void)alertEnded:(NSAlert *)alert
			  code:(NSInteger)choice
		   context:(void *)v
{
	NSLog(@"Alert sheet ended");
	// If the user chose "OK", tell the array controller to
	// reset the preferences values
	if (choice == NSAlertDefaultReturn) {
		// Remove all of the preference values from the standardUserDefaults
        // NOTE: Don't remove the keyAttendees which keeps track of the number of attendees
        NSArray *allDefaultKeys = [NSArray arrayWithObjects:keyAttendeeHourlyRate, keyAttendeeName, keyAttendeeGridBackgroundColor, keyAttendeesCumulative, nil];
        
        // Use fast enumeration to walk through the list of dictionary Preference keys
        for (NSString *key in allDefaultKeys)
        {
            // Remove the preference from the standardUserDefaults
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [self loadPreferenceValues];
        [self savePreferenceValues];
    }
}

#pragma mark -
#pragma mark Notification methods

// Notification: meeting attendees changed.  Update the 'real time' value
- (void)handleAttendeeCountChange:(NSNotification *)notification
{
    // Update the label
	NSLog(@"Received notification: %@", notification);
	NSNumber *attendees = [[notification userInfo] objectForKey:keyAttendees];
    NSInteger countOfAttendees = [[self lblMeetingAttendees] integerValue];
    countOfAttendees += [attendees integerValue];
	[[self lblMeetingAttendees] setStringValue:[NSString stringWithFormat:@"%li",countOfAttendees]];
}

// Initial count of attendees for all open Documents.  Update the 'real time' value
- (void)handleAttendeeTotalCount:(NSNotification *)notification
{
    // Update the label
	NSLog(@"Received notification: %@", notification);
	NSNumber *attendees = [[notification userInfo] objectForKey:keyAttendees];
    NSInteger countOfAttendees = [[self lblMeetingAttendees] integerValue];
    countOfAttendees += [attendees integerValue];
	[[self lblMeetingAttendees] setStringValue:[NSString stringWithFormat:@"%li",countOfAttendees]];
}

@end
