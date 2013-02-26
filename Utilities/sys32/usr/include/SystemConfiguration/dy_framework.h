/*
 * Copyright (c) 2002-2006 Apple Computer, Inc. All rights reserved.
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


#ifndef _DY_FRAMEWORK_H
#define _DY_FRAMEWORK_H

#include <sys/cdefs.h>
#include <mach/mach.h>
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <Security/Security.h>

__BEGIN_DECLS

#pragma mark -
#pragma mark IOKit.framework APIs

CFMutableDictionaryRef
_IOBSDNameMatching			(
					mach_port_t		masterPort,
					unsigned int		options,
					const char		*bsdName
					);
#define IOBSDNameMatching _IOBSDNameMatching

io_object_t
_IOIteratorNext				(
					io_iterator_t		iterator
					);
#define IOIteratorNext _IOIteratorNext

kern_return_t
_IOMasterPort				(
					mach_port_t		bootstrapPort,
					mach_port_t		*masterPort
					);
#define IOMasterPort _IOMasterPort

boolean_t
_IOObjectConformsTo			(
					io_object_t		object,
					const io_name_t		className
					);
#define IOObjectConformsTo _IOObjectConformsTo

boolean_t
_IOObjectGetClass			(
					io_object_t		object,
					io_name_t		className
					);
#define IOObjectGetClass _IOObjectGetClass

kern_return_t
_IOObjectRelease			(
					io_object_t		object
					);
#define IOObjectRelease _IOObjectRelease

CFTypeRef
_IORegistryEntryCreateCFProperty	(
					io_registry_entry_t	entry,
					CFStringRef		key,
					CFAllocatorRef		allocator,
					IOOptionBits		options
					);
#define IORegistryEntryCreateCFProperty _IORegistryEntryCreateCFProperty

kern_return_t
_IORegistryEntryCreateCFProperties	(
					io_registry_entry_t	entry,
					CFMutableDictionaryRef	*properties,
					CFAllocatorRef		allocator,
					IOOptionBits		options
					);
#define IORegistryEntryCreateCFProperties _IORegistryEntryCreateCFProperties

kern_return_t
_IORegistryEntryCreateIterator		(
					io_registry_entry_t	entry,
					const io_name_t		plane,
					IOOptionBits		options,
					io_iterator_t		*iterator
					);
#define IORegistryEntryCreateIterator _IORegistryEntryCreateIterator

kern_return_t
_IORegistryEntryGetName			(
					io_registry_entry_t	entry,
					io_name_t               name
					);
#define	IORegistryEntryGetName _IORegistryEntryGetName

kern_return_t
_IORegistryEntryGetParentEntry		(
					io_registry_entry_t	entry,
					const io_name_t		plane,
					io_registry_entry_t	*parent
					);
#define IORegistryEntryGetParentEntry _IORegistryEntryGetParentEntry

kern_return_t
_IORegistryEntryGetPath			(
					io_registry_entry_t	entry,
					const io_name_t		plane,
					io_string_t		path
					);
#define IORegistryEntryGetPath _IORegistryEntryGetPath

CFTypeRef
_IORegistryEntrySearchCFProperty	(
					io_registry_entry_t     entry,
					const io_name_t         plane,
					CFStringRef             key,
					CFAllocatorRef          allocator,
					IOOptionBits            options
					);
#define IORegistryEntrySearchCFProperty _IORegistryEntrySearchCFProperty

kern_return_t
_IOServiceGetMatchingServices		(
					mach_port_t		masterPort,
					CFDictionaryRef		matching,
					io_iterator_t		*existing
					);
#define IOServiceGetMatchingServices _IOServiceGetMatchingServices

CFMutableDictionaryRef
_IOServiceMatching			(
					const char		*name
					);
#define IOServiceMatching _IOServiceMatching

#pragma mark -
#pragma mark Security.framework APIs

OSStatus
_AuthorizationMakeExternalForm		(
					AuthorizationRef		authorization,
					AuthorizationExternalForm	*extForm
					);
#define AuthorizationMakeExternalForm _AuthorizationMakeExternalForm

OSStatus
_SecAccessCopySelectedACLList		(
					SecAccessRef			accessRef,
					CSSM_ACL_AUTHORIZATION_TAG	action,
					CFArrayRef			*aclList
					);
#define SecAccessCopySelectedACLList _SecAccessCopySelectedACLList

OSStatus
_SecAccessCreate			(
					CFStringRef			descriptor,
					CFArrayRef			trustedlist,
					SecAccessRef			*accessRef
					);
#define SecAccessCreate _SecAccessCreate

OSStatus
_SecAccessCreateFromOwnerAndACL		(
					const CSSM_ACL_OWNER_PROTOTYPE	*owner,
					uint32				aclCount,
					const CSSM_ACL_ENTRY_INFO	*acls,
					SecAccessRef			*accessRef
					);
#define SecAccessCreateFromOwnerAndACL _SecAccessCreateFromOwnerAndACL

OSStatus
_SecKeychainCopyDomainDefault		(
					SecPreferencesDomain			domain,
					SecKeychainRef				*keychain
					);
#define SecKeychainCopyDomainDefault _SecKeychainCopyDomainDefault

OSStatus
_SecKeychainGetPreferenceDomain		(
					SecPreferencesDomain			*domain
					);
#define SecKeychainGetPreferenceDomain _SecKeychainGetPreferenceDomain

OSStatus
_SecKeychainOpen			(
					const char				*pathName,
					SecKeychainRef				*keychain
					);
#define SecKeychainOpen _SecKeychainOpen

OSStatus
_SecKeychainSetDomainDefault		(
					SecPreferencesDomain			domain,
					SecKeychainRef				keychain
					);
#define SecKeychainSetDomainDefault _SecKeychainSetDomainDefault

OSStatus
_SecKeychainSetPreferenceDomain		(
					SecPreferencesDomain			domain
					);
#define SecKeychainSetPreferenceDomain _SecKeychainSetPreferenceDomain

OSStatus
_SecKeychainItemCopyContent		(
					SecKeychainItemRef		itemRef,
					SecItemClass			*itemClass,
					SecKeychainAttributeList	*attrList,
					UInt32				*length,
					void				**outData
					);
#define SecKeychainItemCopyContent _SecKeychainItemCopyContent

OSStatus
_SecKeychainItemCreateFromContent	(
					SecItemClass			itemClass,
					SecKeychainAttributeList	*attrList,
					UInt32				length,
					const void			*data,
					SecKeychainRef			keychainRef,
					SecAccessRef			initialAccess,
					SecKeychainItemRef		*itemRef
					);
#define SecKeychainItemCreateFromContent _SecKeychainItemCreateFromContent

OSStatus
_SecKeychainItemDelete			(
					SecKeychainItemRef		itemRef
					);
#define SecKeychainItemDelete _SecKeychainItemDelete

OSStatus
_SecKeychainItemFreeContent		(
					SecKeychainAttributeList	*attrList,
					void				*data
					);
#define SecKeychainItemFreeContent _SecKeychainItemFreeContent

OSStatus
_SecKeychainItemModifyContent		(
					SecKeychainItemRef		itemRef,
					const SecKeychainAttributeList	*attrList,
					UInt32				length,
					const void			*data
					);
#define SecKeychainItemModifyContent _SecKeychainItemModifyContent

OSStatus
_SecKeychainSearchCopyNext		(
					SecKeychainSearchRef		searchRef,
					SecKeychainItemRef		*itemRef
					);
#define SecKeychainSearchCopyNext _SecKeychainSearchCopyNext

OSStatus
_SecKeychainSearchCreateFromAttributes	(
					CFTypeRef			keychainOrArray,
					SecItemClass			itemClass,
					const SecKeychainAttributeList	*attrList,
					SecKeychainSearchRef		*searchRef
					);
#define SecKeychainSearchCreateFromAttributes _SecKeychainSearchCreateFromAttributes

OSStatus
_SecTrustedApplicationCreateFromPath	(
					const char			*path,
					SecTrustedApplicationRef	*app
					);
#define SecTrustedApplicationCreateFromPath _SecTrustedApplicationCreateFromPath

__END_DECLS

#endif	/* _DY_FRAMEWORK_H */

