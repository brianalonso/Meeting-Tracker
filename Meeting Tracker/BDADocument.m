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
    }
    _meeting = [aMeeting retain];
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
    }
    _timer = [aTime retain];
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self) {
        // Clear the dateformatter object
        _dateFormatter = nil;
        
        // Create an autoreleased Meeting instance
        _meeting = [[[Meeting alloc] init] autorelease];
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
    }
    _dateFormatter = [aDateFormatter retain];
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
    [[self lblTime] setStringValue:[[self dateFormatter] stringFromDate:[NSDate date]]];

    // Create a timer
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(updateGui:)
                                                  userInfo:nil
                                                   repeats:YES]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    // FIXME: placeholder
    return [NSData data];
    
    /*
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
     */
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (void)updateGui:(NSTimer *)aTimer
{
    // Display the current time when the timer pops
    [[self lblTime] setStringValue:[[self dateFormatter] stringFromDate:[NSDate date]]];
}

-(void) windowWillClose:(NSNotification *) notification
{
    // Invalidate the timer
    [[self timer] invalidate];
}

- (void)dealloc
{
    [super dealloc];
    
    // Release any retained objects
    [_timer release];
    [_dateFormatter release];
}

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
@end
