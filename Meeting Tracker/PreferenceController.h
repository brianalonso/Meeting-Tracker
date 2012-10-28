//
//  PreferenceController.h
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/24/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// External key references
extern NSString *const keyAttendeeHourlyRate;
extern NSString *const keyAttendees;
extern NSString *const keyAttendeeName;
extern NSString *const keyAttendeeGridBackgroundColor;

extern NSString *const notificationKeyAttendeeHourlyRate;
extern NSString *const notificationKeyAttendees;
extern NSString *const notificationKeyAttendeeName;
extern NSString *const notificationKeyAttendeeGridBackgroundColor;

@interface PreferenceController : NSWindowController

// Outlets
@property (assign) IBOutlet NSTextField *txtHourlyRate;
@property (assign) IBOutlet NSTextField *lblMeetingAttendees;
@property (assign) IBOutlet NSSlider *sliderHourlyRate;
@property (assign) IBOutlet NSTextField *txtAttendeeName;
@property (assign) IBOutlet NSColorWell *colorWell;

// Class values
+ (NSString *)preferenceAttendeeName;
+ (void)setPreferenceAttendeeName:(NSString *)aAttendeeName;
+ (NSNumber *)preferenceHourlyRate;
+ (void)setPreferenceHourlyRate:(NSNumber *)aHourlyRate;
+ (NSNumber *)preferenceAttendees;
+ (void)setPreferenceAttendees:(NSNumber *)aAttendees;
+ (NSColor *)preferenceTableBgColor;
+ (void)setPreferenceTableBgColor:(NSColor *)color;

// Actions
- (IBAction)sliderMoved:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnReset:(id)sender;
@end
