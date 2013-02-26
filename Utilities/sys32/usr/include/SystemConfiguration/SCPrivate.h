/*
 * Copyright (c) 2000-2007 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _SCPRIVATE_H
#define _SCPRIVATE_H

#include <sys/cdefs.h>
#include <sys/socket.h>
#include <sys/syslog.h>
#include <mach/message.h>

#include <CoreFoundation/CoreFoundation.h>

/* SCDynamicStore SPIs */
#include <SystemConfiguration/SCDynamicStorePrivate.h>
#include <SystemConfiguration/SCDynamicStoreCopySpecificPrivate.h>
#include <SystemConfiguration/SCDynamicStoreSetSpecificPrivate.h>

/* SCPreferences SPIs */
#include <SystemConfiguration/SCPreferencesPrivate.h>
#include <SystemConfiguration/SCPreferencesGetSpecificPrivate.h>
#include <SystemConfiguration/SCPreferencesSetSpecificPrivate.h>

/* [private] Schema Definitions (for SCDynamicStore and SCPreferences) */
#include <SystemConfiguration/SCSchemaDefinitionsPrivate.h>

/* SCNetworkConfiguration SPIs */
#include <SystemConfiguration/SCNetworkConfigurationPrivate.h>

/* SCNetworkConnection SPIs */
#include <SystemConfiguration/SCNetworkConnectionPrivate.h>

/* Keychain SPIs */
#include <SystemConfiguration/SCPreferencesKeychainPrivate.h>

/*!
	@header SCPrivate
 */

/* framework variables */
extern Boolean	_sc_debug;	/* TRUE if debugging enabled */
extern Boolean	_sc_verbose;	/* TRUE if verbose logging enabled */
extern Boolean	_sc_log;	/* TRUE if SCLog() output goes to syslog */

__BEGIN_DECLS

/*!
	@function _SCErrorSet
	@discussion Sets the last SystemConfiguration.framework API error code.
	@param error The error encountered.
 */
void		_SCErrorSet			(int			error);

/*!
	@function _SCSerialize
	@discussion Serialize a CFPropertyList object for passing
		to/from configd.
	@param obj CFPropertyList object to serialize
	@param xml A pointer to a CFDataRef, NULL if data should be
		vm_allocated.
	@param dataRef A pointer to the newly allocated/serialized data
	@param dataLen A pointer to the length in bytes of the newly
		allocated/serialized data
 */
Boolean		_SCSerialize			(CFPropertyListRef	obj,
						 CFDataRef		*xml,
						 void			**dataRef,
						 CFIndex		*dataLen);

/*!
	@function _SCUnserialize
	@discussion Unserialize a stream of bytes passed from/to configd
		into a CFPropertyList object.
	@param obj A pointer to memory that will be filled with the CFPropertyList
		associated with the stream of bytes.
	@param xml CFDataRef with the serialized data
	@param dataRef A pointer to the serialized data
	@param dataLen A pointer to the length of the serialized data

	Specify either "xml" or "data/dataLen".
 */
Boolean		_SCUnserialize			(CFPropertyListRef	*obj,
						 CFDataRef		xml,
						 void			*dataRef,
						 CFIndex		dataLen);

/*!
	@function _SCSerializeString
	@discussion Serialize a CFString object for passing
		to/from configd.
	@param str CFString key to serialize
	@param data A pointer to a CFDataRef, NULL if storage should be
		vm_allocated.
	@param dataRef A pointer to the newly allocated/serialized data
	@param dataLen A pointer to the length in bytes of the newly
		allocated/serialized data
 */
Boolean		_SCSerializeString		(CFStringRef		str,
						 CFDataRef		*data,
						 void			**dataRef,
						 CFIndex		*dataLen);

/*!
	@function _SCUnserializeString
	@discussion Unserialize a stream of bytes passed from/to configd
		into a CFString object.
	@param str A pointer to memory that will be filled with the CFString
		associated with the stream of bytes.
	@param utf8 CFDataRef with the serialized data
	@param dataRef A pointer to the serialized data
	@param dataLen A pointer to the length of the serialized data

	Specify either "utf8" or "data/dataLen".
 */
Boolean		_SCUnserializeString		(CFStringRef		*str,
						 CFDataRef		utf8,
						 void			*dataRef,
						 CFIndex		dataLen);

/*!
	@function _SCSerializeData
	@discussion Serialize a CFData object for passing
		to/from configd.
	@param data CFData key to serialize
	@param dataRef A pointer to the newly allocated/serialized data
	@param dataLen A pointer to the length in bytes of the newly
		allocated/serialized data
 */
Boolean		_SCSerializeData		(CFDataRef		data,
						 void			**dataRef,
						 CFIndex		*dataLen);

/*!
	@function _SCUnserializeData
	@discussion Unserialize a stream of bytes passed from/to configd
		into a CFData object.
	@param data A pointer to memory that will be filled with the CFData
		associated with the stream of bytes.
	@param dataRef A pointer to the serialized data
	@param dataLen A pointer to the length of the serialized data
 */
Boolean		_SCUnserializeData		(CFDataRef		*data,
						 void			*dataRef,
						 CFIndex		dataLen);

/*!
	@function _SCSerializeMultiple
	@discussion Convert a CFDictionary containing a set of CFPropertlyList
		values into a CFDictionary containing a set of serialized CFData
		values.
	@param dict The CFDictionary with CFPropertyList values.
	@result The serialized CFDictionary with CFData values
 */
CFDictionaryRef	_SCSerializeMultiple		(CFDictionaryRef	dict);

/*!
	@function _SCUnserializeMultiple
	@discussion Convert a CFDictionary containing a set of CFData
		values into a CFDictionary containing a set of serialized
		CFPropertlyList values.
	@param dict The CFDictionary with CFData values.
	@result The serialized CFDictionary with CFPropertyList values
 */
CFDictionaryRef	_SCUnserializeMultiple		(CFDictionaryRef	dict);

/*!
	@function _SC_cfstring_to_cstring
	@discussion Extracts a C-string from a CFString.
	@param cfstr The CFString to extract the data from.
	@param buf A user provided buffer of the specified length.  If NULL,
		a new buffer will be allocated to contain the C-string.  It
		is the responsiblity of the caller to free an allocated
		buffer.
	@param bufLen The size of the user provided buffer.
	@param encoding The string encoding
	@result If the extraction (conversion) is successful then a pointer
		to the user provided (or allocated) buffer is returned, NULL
		if the string could not be extracted.
 */
char *		_SC_cfstring_to_cstring		(CFStringRef		cfstr,
						 char			*buf,
						 CFIndex		bufLen,
						 CFStringEncoding	encoding);

/*!
 *      @function _SC_sockaddr_to_string
 *      @discussion Formats a "struct sockaddr" for reporting
 *      @param address The address to format
 *	@param buf A user provided buffer of the specified length.
 *	@param bufLen The size of the user provided buffer.
 */
void		_SC_sockaddr_to_string		(const struct sockaddr  *address,
						 char			*buf,
						 size_t			bufLen);

/*!
	@function _SC_sendMachMessage
	@discussion Sends a trivial mach message (one with just a
		message ID) to the specified port.
	@param port The mach port.
	@param msg_id The message id.
 */
void		_SC_sendMachMessage		(mach_port_t		port,
						 mach_msg_id_t		msg_id);


/*!
	@function SCLog
	@discussion Conditionally issue a log message.
	@param condition A boolean value indicating if the message should be logged
	@param level A syslog(3) logging priority.
	@param formatString The format string
	@result The specified message will be written to the system message
		logger (See syslogd(8)).
 */
void		SCLog				(Boolean		condition,
						 int			level,
						 CFStringRef		formatString,
						 ...);

/*!
	@function SCPrint
	@discussion Conditionally issue a debug message.
	@param condition A boolean value indicating if the message should be written
	@param stream The output stream for the log message.
	@param formatString The format string
	@result The message will be written to the specified stream
		stream.
 */
void		SCPrint				(Boolean		condition,
						 FILE			*stream,
						 CFStringRef		formatString,
						 ...);

/*!
	@function SCTrace
	@discussion Conditionally issue a debug message with a time stamp.
	@param condition A boolean value indicating if the message should be written
	@param stream The output stream for the log message.
	@param formatString The format string
	@result The message will be written to the specified stream
		stream.
 */
void		SCTrace				(Boolean		condition,
						 FILE			*stream,
						 CFStringRef		formatString,
						 ...);

/*
 * DOS encoding/codepage
 */
void
_SC_dos_encoding_and_codepage			(CFStringEncoding	macEncoding,
						 UInt32			macRegion,
						 CFStringEncoding	*dosEncoding,
						 UInt32			*dosCodepage);

CFDataRef
_SC_dos_copy_string				(CFStringRef		str,
						 CFStringEncoding	dosEncoding,
						 UInt32			dosCodepage);

/*
 * object / CFRunLoop  management
 */
void
_SC_signalRunLoop				(CFTypeRef		obj,
						 CFRunLoopSourceRef     rls,
						 CFArrayRef		rlList);

Boolean
_SC_isScheduled					(CFTypeRef		obj,
						 CFRunLoopRef		runLoop,
						 CFStringRef		runLoopMode,
						 CFMutableArrayRef      rlList);

void
_SC_schedule					(CFTypeRef		obj,
						 CFRunLoopRef		runLoop,
						 CFStringRef		runLoopMode,
						 CFMutableArrayRef      rlList);

Boolean
_SC_unschedule					(CFTypeRef		obj,
						 CFRunLoopRef		runLoop,
						 CFStringRef		runLoopMode,
						 CFMutableArrayRef      rlList,
						 Boolean		all);

/*
 * bundle access
 */
CFBundleRef
_SC_CFBundleGet					(void);

CFStringRef
_SC_CFBundleCopyNonLocalizedString		(CFBundleRef		bundle,
						 CFStringRef		key,
						 CFStringRef		value,
						 CFStringRef		tableName);

/*
 * misc
 */
static __inline__ Boolean
_SC_CFEqual(CFTypeRef val1, CFTypeRef val2)
{
	if (val1 == val2) {
	    return TRUE;
	}
	if (val1 != NULL && val2 != NULL) {
		return CFEqual(val1, val2);
	}
	return FALSE;
}

__END_DECLS

#endif	/* _SCPRIVATE_H */
