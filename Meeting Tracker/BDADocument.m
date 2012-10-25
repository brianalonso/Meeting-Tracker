//
//  BDADocument.m
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "BDADocument.h"
#import "Meeting.h"
#import "Person.h"
#import "PreferenceController.h"

@interface BDADocument()

// Private properties
-(NSTimer *) timer;
-(void) setTimer:(NSTimer *)aTime;
-(Meeting *) meeting;
-(void) setMeeting:(Meeting *) aMeeting;

@end

@implementation BDADocument

#pragma mark -
#pragma mark Properties

- (Meeting *) meeting
{
    return _meeting;
}

- (void) setMeeting:(Meeting *) aMeeting
{
    if (_meeting != aMeeting) {
        [_meeting release];
        _meeting = [aMeeting retain];
    }
}

- (NSTimer *) timer
{
    return _timer;
}

- (void) setTimer:(NSTimer *)aTime
{
    if (_timer != aTime) {
        [_timer invalidate];
        [_timer release];
         _timer = [aTime retain];
    }
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self) {
        // Clear the dateformatter object
        _dateFormatter = nil;
        _numberFormatter = nil;
        
        // Create an empty Meeting instance
        _meeting = [[[Meeting alloc] init] retain];
        
        // Instantiate a meeting with the Stooges
        //_meeting = [[Meeting meetingWithStooges] retain];
    }
    return self;
}

#pragma mark -
#pragma mark Date formatter

- (NSDateFormatter *)dateFormatter {
	if (_dateFormatter == nil) {
        // Create an autoreleased DateFormatter object
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	}
	return _dateFormatter;
}

- (void) setDateFormatter:(NSDateFormatter *)aDateFormatter
{
    if (_dateFormatter != aDateFormatter) {
        [_dateFormatter release];
        _dateFormatter = [aDateFormatter retain];
    }
}

#pragma mark -
#pragma mark Number formatter

- (NSNumberFormatter *)numberFormatter {
	if (_numberFormatter == nil) {
        // Create an autoreleased DateFormatter object
		_numberFormatter = [[NSNumberFormatter alloc] init];
	}
	return _numberFormatter;
}

- (void) setNumberFormatter:(NSNumberFormatter *)aNumberFormatter
{
    if (_numberFormatter != aNumberFormatter) {
        [_numberFormatter release];
        _numberFormatter = [aNumberFormatter retain];
    }
}

#pragma mark -
#pragma mark Document Instance methods

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"BDADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    // Set the initial time value
    [[self dateFormatter] setDoesRelativeDateFormatting:NO];
    [[self lblTime] setStringValue:[[self dateFormatter] stringFromDate:[NSDate date]]];

    // Create a timer
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(updateGui:)
                                                  userInfo:nil
                                                   repeats:YES]];
    // Set the start/end buttons
    if (![[self meeting] meetingInProgress] == YES )
    {
        // Set the start/end buttons (coming from a saved instance)
        [[self btnStartMeeting] setEnabled:NO];
        [[self btnEndMeeting] setEnabled:YES];
    }
    else
    {
        // Normal startup
        [[self btnStartMeeting] setEnabled:YES];
        [[self btnEndMeeting] setEnabled:NO];
    }
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // End editing to tableview
	[[[self personsTableView] window] endEditingFor:nil];
    
	// Create an NSData object from the meeting array
	return [NSKeyedArchiver archivedDataWithRootObject:[self meeting]];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"About to read data of type %@", typeName);
	Meeting *archivedMeeting = nil;
	@try {
		archivedMeeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException *e) {
		NSLog(@"exception = %@", e);
		if (outError) {
			NSDictionary *d = [NSDictionary
							   dictionaryWithObject:@"The data is corrupted."
							   forKey:NSLocalizedFailureReasonErrorKey];
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain
											code:unimpErr
										userInfo:d];
		}
		return NO;
	}
	[self setMeeting:archivedMeeting];
    
    NSLog(@"%@", [[self meeting] description]);
   	return YES;
}

#pragma mark -
#pragma mark Update Gui method

- (void)updateGui:(NSTimer *)aTimer
{
    // Display the current time when the timer pops
    [[self dateFormatter] setDoesRelativeDateFormatting:NO];
    [[self lblTime] setStringValue:[[self dateFormatter] stringFromDate:[NSDate date]]];
    
    // If a meeting is in progress, update the elapsed time and billing values
    if (![[self meeting] meetingInProgress] == YES )
    {
        // Update the label values
        [[self numberFormatter] setNumberStyle:NSNumberFormatterCurrencyStyle];
        [[self lblElapsedTime] setStringValue:[[self meeting] elapsedTimeDisplayString]];
        [[self lblAccruedCost] setStringValue:[[self numberFormatter] stringForObjectValue:[[self meeting] accruedCost]]];
    }
    [[self numberFormatter] setNumberStyle:NSNumberFormatterCurrencyStyle];
    [[self lblTotalBillingRate_Polled] setStringValue:[[self numberFormatter] stringForObjectValue:[[self meeting] totalBillingRate]]];
}

-(void) windowWillClose:(NSNotification *) notification
{
    // Invalidate the timer
    [[self timer] invalidate];
}

- (void)dealloc
{
        
    // Release any retained objects
    [_meeting release];
    _meeting = nil;
    
    [_timer release];
    _timer = nil;
    
    [_dateFormatter release];
    _dateFormatter = nil;
    
    [_numberFormatter release];
    _numberFormatter = nil;
    
    [super dealloc];

}

#pragma mark -
#pragma mark Action methods

- (IBAction)logMeeting:(NSButton *)sender {
    
    Meeting *captains = [Meeting meetingWithCaptains];
    NSLog(@"%@", [captains description]);
}

- (IBAction)logParticipants:(NSButton *)sender {
    Meeting *captains = [Meeting meetingWithCaptains];
    for (Person *p in [captains personsPresent])
    {
        NSLog(@"%@", [p description]);
    }
}

- (IBAction)startMeeting:(id)sender {
    
    // Ensure we have an empty meeting
    NSLog(@"%@", [[self meeting] description]);
    
    // Set the start date for the meeting
    [[self meeting] setStartingTime:[NSDate date]];
    
    // Format the relative start time for the label
    [[self dateFormatter] setDoesRelativeDateFormatting:YES];
    [[self lblStartTime] setStringValue:[[self dateFormatter] stringFromDate:[[self meeting] startingTime]]];
    
    // Set the start/end buttons
    [[self btnStartMeeting] setEnabled:NO];
    [[self btnEndMeeting] setEnabled:YES];

}

- (IBAction)endMeeting:(id)sender {
    
    // Set the end date
    [[self meeting] setEndingTime:[NSDate date]];
    
    [[self dateFormatter] setDoesRelativeDateFormatting:YES];
    [[self lblEndTime] setStringValue:[[self dateFormatter] stringFromDate:[[self meeting] endingTime]]];
    
    // Set the start/end buttons
    [[self btnStartMeeting] setEnabled:YES];
    [[self btnEndMeeting] setEnabled:NO];

}

@end
