//
//  BDADocument.h
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

extern NSUndoManager *undoMgr;

@interface BDADocument : NSDocument {
    NSDateFormatter *_dateFormatter;
    NSNumberFormatter *_numberFormatter;
    Meeting *_meeting;
    NSTimer *_timer;
}

// Properties
- (NSDateFormatter *) dateFormatter;
- (void) setDateFormatter:(NSDateFormatter *)aDateFormatter;
- (NSNumberFormatter *) numberFormatter;
- (void) setNumberFormatter:(NSNumberFormatter *)aNumberFormatter;

// Outlets
@property (assign) IBOutlet NSTextField *lblTime;
@property (assign) IBOutlet NSTextField *lblStartTime;
@property (assign) IBOutlet NSTextField *lblEndTime;
@property (assign) IBOutlet NSTableView *personsTableView;
@property (assign) IBOutlet NSButton *btnAdd;
@property (assign) IBOutlet NSButton *btnRemove;
@property (assign) IBOutlet NSButton *btnStartMeeting;
@property (assign) IBOutlet NSButton *btnEndMeeting;
@property (assign) IBOutlet NSTextField *lblElapsedTime;
@property (assign) IBOutlet NSTextField *lblAccruedCost;
@property (assign) IBOutlet NSTextField *lblTotalBillingRate_Polled;

// Actions
- (IBAction)logMeeting:(NSButton *)sender;
- (IBAction)logParticipants:(NSButton *)sender;
- (IBAction)startMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;

- (IBAction)startMarxBrothers:(id)sender;
- (IBAction)startStooges:(id)sender;
- (IBAction)startStarTrek:(id)sender;

- (void) updateGui:(NSTimer *) theTimer;
- (void) windowWillClose:(NSNotification *) notification;

@end
