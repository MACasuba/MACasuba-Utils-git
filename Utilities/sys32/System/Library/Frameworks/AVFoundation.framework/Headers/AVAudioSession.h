/*
  AVAudioSession.h

  Copyright 2009 Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>	/* for NSTimeInterval */

/* This protocol is available with iPhone 3.0 or later */
@protocol AVAudioSessionDelegate;
@class NSError, NSString;

/* values for the category property */
extern NSString *const AVAudioSessionCategoryAmbient;
extern NSString *const AVAudioSessionCategorySoloAmbient;
extern NSString *const AVAudioSessionCategoryPlayback;
extern NSString *const AVAudioSessionCategoryRecord;
extern NSString *const AVAudioSessionCategoryPlayAndRecord;
extern NSString *const AVAudioSessionCategoryAudioProcessing;


@interface AVAudioSession : NSObject {
@private
    __strong void *_impl;
}

 /* returns singleton instance */
+ (id)sharedInstance;

@property(assign) id<AVAudioSessionDelegate> delegate;

- (BOOL)setActive:(BOOL)beActive error:(NSError**)outError;

- (BOOL)setCategory:(NSString*)theCategory error:(NSError**)outError;
- (BOOL)setPreferredHardwareSampleRate:(double)sampleRate error:(NSError**)outError;
- (BOOL)setPreferredIOBufferDuration:(NSTimeInterval)duration error:(NSError**)outError;

@property(readonly) NSString* category;
@property(readonly) double preferredHardwareSampleRate;
@property(readonly) NSTimeInterval preferredIOBufferDuration;

@property(readonly) BOOL inputIsAvailable;
@property(readonly) double currentHardwareSampleRate;
@property(readonly) NSInteger currentHardwareInputNumberOfChannels;
@property(readonly) NSInteger currentHardwareOutputNumberOfChannels;

@end


/* A protocol for delegates of AVAudioSession */
@protocol AVAudioSessionDelegate <NSObject>
@optional 

- (void)beginInterruption;
- (void)endInterruption;

- (void)categoryChanged:(NSString*)category;

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable;

- (void)currentHardwareSampleRateChanged:(double)sampleRate;
- (void)currentHardwareInputNumberOfChannelsChanged:(NSInteger)numberOfChannels;
- (void)currentHardwareOutputNumberOfChannelsChanged:(NSInteger)numberOfChannels;

@end
