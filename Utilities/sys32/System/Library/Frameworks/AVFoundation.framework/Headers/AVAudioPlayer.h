/*
  AVAudioPlayer.h

  Copyright 2008 Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>  /* for NSTimeInterval */

@class NSData, NSURL, NSError;
@protocol AVAudioPlayerDelegate;

/* This class is available with iPhone 2.2 or later */
@interface AVAudioPlayer : NSObject {
@private
    __strong void *_impl;
}

/* For all of these init calls, if a return value of nil is given you can check outError to see what the problem was.
 If not nil, then the object is usable for playing
*/

/* all data must be in the form of an audio file understood by CoreAudio */
- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError;
- (id)initWithData:(NSData *)data error:(NSError **)outError;

/* transport control */
/* methods that return BOOL return YES on success and NO on failure. */
- (BOOL)prepareToPlay;	/* get ready to play the sound. happens automatically on play. */
- (BOOL)play;			/* sound is played asynchronously. */
- (void)pause;			/* pauses playback, but remains ready to play. */
- (void)stop;			/* stops playback. no longer ready to play. */

/* properties */

@property(readonly, getter=isPlaying) BOOL playing;

@property(readonly) NSUInteger numberOfChannels;
@property(readonly) NSTimeInterval duration; /* the duration of the sound. */

@property(assign) id<AVAudioPlayerDelegate> delegate; /* the delegate will be sent playerDidFinishPlaying */ 

/* one of these three properties will be non-nil based on the init... method used */
@property(readonly) NSURL *url; /* returns nil if object was not created with a URL */
@property(readonly) NSData *data; /* returns nil if object was not created with a data object */

@property float volume; /* The volume for the sound. The nominal range is from 0.0 to 1.0. */

/*  If the sound is playing, currentTime is the offset into the sound of the current playback position.  
If the sound is not playing, currentTime is the offset into the sound where playing would start. */
@property NSTimeInterval currentTime;

/* "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end. 
A value of zero means to play the sound just once.
A value of one will result in playing the sound twice, and so on..
Any negative number will loop indefinitely until stopped.
*/
@property NSInteger numberOfLoops;

/* metering */

@property(getter=isMeteringEnabled) BOOL meteringEnabled; /* turns level metering on or off. default is off. */

- (void)updateMeters; /* call to refresh meter values */

- (float)peakPowerForChannel:(NSUInteger)channelNumber; /* returns peak power in decibels for a given channel */
- (float)averagePowerForChannel:(NSUInteger)channelNumber; /* returns average power in decibels for a given channel */

@end

/* A protocol for delegates of AVAudioPlayer */
@protocol AVAudioPlayerDelegate <NSObject>
@optional 
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;

#if TARGET_OS_IPHONE
/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;

/* audioPlayerEndInterruption: is called when the audio session interruption has ended and this player had been interrupted while playing. 
The player can be restarted at this point. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
#endif
@end
