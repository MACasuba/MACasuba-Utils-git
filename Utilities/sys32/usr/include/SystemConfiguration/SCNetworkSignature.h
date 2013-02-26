/*
 * Copyright (c) 2006 Apple Computer, Inc. All rights reserved.
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

#ifndef _SCNETWORKSIGNATURE_H
#define _SCNETWORKSIGNATURE_H

#include <AvailabilityMacros.h>
#if MAC_OS_X_VERSION_MAX_ALLOWED >= 1050

#include <CoreFoundation/CFString.h>
#include <CoreFoundation/CFArray.h>
#include <netinet/in.h>

/*!
	@header SCNetworkSignature
	@discussion The SCNetworkSignature API provides access to the 
		network identification information.  Each routable network
		has an associated signature that is assigned a unique
		identifier.  The unique identifier allows an application
		to associate settings with a particular network
		or set of networks.
 */

/*!
	@const kSCNetworkSignatureActiveChangedNotifyName
	@discussion The name to use with the notify(3) API's to monitor
		when the list of active signatures changes.
 */
extern const char * kSCNetworkSignatureActiveChangedNotifyName;

/*!
	@function SCNetworkSignatureCopyActiveIdentifiers
	@discussion Find all currently active networks and return a list of
		(string) identifiers, one for each network.
	@param allocator The CFAllocator that should be used to allocate
		memory for the local dynamic store object.
		This parameter may be NULL in which case the current
		default CFAllocator is used. If this reference is not
		a valid CFAllocator, the behavior is undefined.
	@result A CFArrayRef containing a list of (string) identifiers,
		NULL if no networks are currently active.
 */
CFArrayRef /* of CFStringRef's */
SCNetworkSignatureCopyActiveIdentifiers(CFAllocatorRef alloc);

/*!
	@function SCNetworkSignatureCopyActiveIdentifierForAddress
	@discussion Find the one active network associated with the specified
		address and return the unique (string) identifier that
		represents it.
	@param allocator The CFAllocator that should be used to allocate
		memory for the local dynamic store object.
		This parameter may be NULL in which case the current
		default CFAllocator is used. If this reference is not
		a valid CFAllocator, the behavior is undefined.
	@param addr The address of interest.  Note: currently only AF_INET
		0.0.0.0 is supported, passing anything else always returns
		NULL.
	@result The unique (string) identifier associated with the address,
		NULL if no network is known.
 */
CFStringRef
SCNetworkSignatureCopyActiveIdentifierForAddress(CFAllocatorRef alloc,
						 const struct sockaddr * addr);

#endif	/* MAC_OS_X_VERSION_MAX_ALLOWED >= 1050 */

#endif	/* _SCNETWORKSIGNATURE_H */
