//
//  BDADocument.h
//  Meeting Tracker
//
//  Created by Brian Alonso on 10/8/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;
@interface BDADocument : NSDocument {
    NSDateFormatter *_dateFormatter;
    Meeting *_meeting;
    NSTimer *_timer;
}

// Properties
-(NSTimer *) timer;
-(void) setTimer:(NSTimer *)aTime;
-(NSDateFormatter *) dateFormatter;
- (void) setDateFormatter:(NSDateFormatter *)aDateFormatter;
-(Meeting *) meeting;
-(void) setMeeting:(Meeting *) aMeeting;


// outlets
@property (assign) IBOutlet NSTextField *lblTime;

// actions
- (IBAction)logMeeting:(NSButton *)sender;
- (IBAction)logParticipants:(NSButton *)sender;

-(void) updateGui:(NSTimer *) theTimer;
-(void) windowWillClose:(NSNotification *) notification;
@end
