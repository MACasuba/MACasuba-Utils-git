/*
	File:		AUPlugIn.h

	Contains:	AudioUnit Interfaces

	Copyright:	© 2009 by Apple Inc., all rights reserved.

	Bugs?:		For bug reports, consult the following page on
				the World Wide Web:

					http://developer.apple.com/bugreporter/
*/

#ifndef __AUPLUGIN__
#define __AUPLUGIN__


#include <AudioUnit/AUComponent.h>
#include <CoreFoundation/CFPlugIn.h>
#if COREFOUNDATION_CFPLUGINCOM_SEPARATE
#include <CoreFoundation/CFPlugInCOM.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*!
	@function		AudioComponentRegister
	@abstract		Dynamically registers an AudioComponent within a process
	@discussion
		This function allows you to package audio signal processing functionality as an AudioUnit,
		(a form of AudioComponent), register the AudioComponent, and then use it with AUGraph.
	
	@param			inDesc
						the AudioComponentDescription
	@param			inName
						the AudioComponent's name
	@param			inVersion
						the AudioComponent's version
	@param			inFactory
						a CFPlugInFactoryFunction which will create instances of your AudioComponent
	@result			an AudioComponent object
*/
extern AudioComponent
AudioComponentRegister(     const AudioComponentDescription *   inDesc,
                            CFStringRef                         inName,
                            UInt32                              inVersion,
                            CFPlugInFactoryFunction             inFactory)
                                                                            __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

#ifdef __cplusplus
}
#endif

typedef struct AudioComponentPlugInInterface {
    IUNKNOWN_C_GUTS;
    
    OSStatus    (*Open)(void *self, AudioUnit comp);
    OSStatus    (*Close)(void *self);
	Boolean		(*CanDo)(void *self, SInt16 selector);
} AudioComponentPlugInInterface;

#define kAudioUnitPlugInInterfaceUUID \
    CFUUIDGetConstantUUIDWithBytes(NULL, 0x8E, 0xA5, 0xA9, 0xE4, 0xC5, 0x8E, 0x11, 0xDD, 0xA7, 0xE1, 0x00, 0x14, 0x51, 0x68, 0xC4, 0x14)
    // 8EA5A9E4-C58E-11DD-A7E1-00145168C414

typedef struct AudioUnitPlugInInterface {
    IUNKNOWN_C_GUTS;
    
    OSStatus    (*Open)(void *self, AudioUnit comp);
    OSStatus    (*Close)(void *self);
	Boolean		(*CanDo)(void *self, SInt16 selector);
    
    OSStatus    (*Initialize)(void *self);
    OSStatus    (*Uninitialize)(void *self);
    OSStatus    (*GetPropertyInfo)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, UInt32 *size, Boolean *writable);
    OSStatus    (*GetProperty)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, void *data, UInt32 *size);
    OSStatus    (*SetProperty)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, const void *data, UInt32 size);
    OSStatus    (*AddPropertyListener)(void *self, AudioUnitPropertyID prop, AudioUnitPropertyListenerProc proc, void *userData);
    OSStatus    (*RemovePropertyListener)(void *self, AudioUnitPropertyID prop, AudioUnitPropertyListenerProc proc, void *userData);
    OSStatus    (*AddRenderNotify)(void *self, AURenderCallback proc, void *userData);
    OSStatus    (*RemoveRenderNotify)(void *self, AURenderCallback proc, void *userData);
    OSStatus    (*GetParameter)(void *self, AudioUnitParameterID param, AudioUnitScope scope, AudioUnitElement elem, AudioUnitParameterValue *value);
    OSStatus    (*SetParameter)(void *self, AudioUnitParameterID param, AudioUnitScope scope, AudioUnitElement elem, AudioUnitParameterValue value, UInt32 bufferOffset);
    OSStatus    (*ScheduleParameters)(void *self, const AudioUnitParameterEvent *events, UInt32 numEvents);
    OSStatus    (*Render)(void *self, AudioUnitRenderActionFlags *flags, const AudioTimeStamp *ts, UInt32 bus, UInt32 numFrames, AudioBufferList *data);
    OSStatus    (*Reset)(void *self, AudioUnitScope scope, AudioUnitElement elem);
	void *		reserved[8];
} AudioUnitPlugInInterface;

#define kAudioOutputUnitPlugInInterfaceUUID \
    CFUUIDGetConstantUUIDWithBytes(NULL, 0x5C, 0x6F, 0xB7, 0xD4, 0xC6, 0x93, 0x11, 0xDD, 0xA5, 0x3E, 0x00, 0x17, 0xF2, 0x00, 0xBB, 0xC6)
    // 5C6FB7D4-C693-11DD-A53E-0017F200BBC6

typedef struct AudioOutputUnitPlugInInterface {
    IUNKNOWN_C_GUTS;
    
    OSStatus    (*Open)(void *self, AudioUnit comp);
    OSStatus    (*Close)(void *self);
	Boolean		(*CanDo)(void *self, SInt16 selector);
    
    OSStatus    (*Initialize)(void *self);
    OSStatus    (*Uninitialize)(void *self);
    OSStatus    (*GetPropertyInfo)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, UInt32 *size, Boolean *writable);
    OSStatus    (*GetProperty)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, void *data, UInt32 *size);
    OSStatus    (*SetProperty)(void *self, AudioUnitPropertyID prop, AudioUnitScope scope, AudioUnitElement elem, const void *data, UInt32 size);
    OSStatus    (*AddPropertyListener)(void *self, AudioUnitPropertyID prop, AudioUnitPropertyListenerProc proc, void *userData);
    OSStatus    (*RemovePropertyListener)(void *self, AudioUnitPropertyID prop, AudioUnitPropertyListenerProc proc, void *userData);
    OSStatus    (*AddRenderNotify)(void *self, AURenderCallback proc, void *userData);
    OSStatus    (*RemoveRenderNotify)(void *self, AURenderCallback proc, void *userData);
    OSStatus    (*GetParameter)(void *self, AudioUnitParameterID param, AudioUnitScope scope, AudioUnitElement elem, AudioUnitParameterValue *value);
    OSStatus    (*SetParameter)(void *self, AudioUnitParameterID param, AudioUnitScope scope, AudioUnitElement elem, AudioUnitParameterValue value, UInt32 bufferOffset);
    OSStatus    (*ScheduleParameters)(void *self, const AudioUnitParameterEvent *events, UInt32 numEvents);
    OSStatus    (*Render)(void *self, AudioUnitRenderActionFlags *flags, const AudioTimeStamp *ts, UInt32 bus, UInt32 numFrames, AudioBufferList *data);
    OSStatus    (*Reset)(void *self, AudioUnitScope scope, AudioUnitElement elem);
	void *		reserved[8];
    OSStatus    (*Start)(void *self);
    OSStatus    (*Stop)(void *self);
} AudioOutputUnitPlugInInterface;


#endif /* __AUPLUGIN__ */

