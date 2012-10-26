//
//  AppController.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/24/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize
{
	// Create a dictionary to hold the preferences values
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	// Put default values in the dictionary
	[defaultValues setObject:[NSNumber numberWithDouble:20.] forKey:keyAttendeeHourlyRate];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:keyAttendees];
    [defaultValues setObject:@"<name>" forKey:keyAttendeeName];
    
    // Archive the color object
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:
						   [NSColor lightGrayColor]];
	
	// Put color default in the dictionary
	[defaultValues setObject:colorAsData forKey:keyAttendeeGridBackgroundColor];
	
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
    NSLog(@"registered defaults: %@", defaultValues);
}

- (IBAction)showPreferencePanel:(id)sender
{
    // Is the preferenceControll nil ?
    if (!preferenceController) {
        preferenceController = [[[PreferenceController alloc] init] retain];
    }
    
    // Display the preferences windows
    NSLog(@"Display the %@", preferenceController);
    [preferenceController showWindow:self];
}

- (void) dealloc
{
    [preferenceController release];
    preferenceController = nil;
    
    [super dealloc];
}
@end
