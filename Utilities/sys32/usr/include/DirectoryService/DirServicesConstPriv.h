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

/*!
 * @header DirServicesConstPriv
 * @discussion This header contains well known record, attribute and
 * authentication type constants plus others.
 * The attribute and record constants are generally used with the
 * API calls dsDataNodeAllocateString() and dsBuildListFromStrings()
 * to create proper data type arguments for the search methods in the
 * Directory Services API.
 * The auth constants are used with dsDataNodeAllocateString().
 */

#ifndef __DirServicesConstPriv_h__
#define	__DirServicesConstPriv_h__	1

/*!
 * @functiongroup DirectoryService Private Constants
 */

/*!
 * @defined kDSStdAuthNewComputer
 * @discussion
 *     Create a new computer record
 *	   This authentication method is only implemented by the PasswordServer node.
 *     The buffer is packed as follows:
 *
 *     4 byte length of authenticator's Password Server ID,
 *     authenticator's Password Server ID,
 *     4 byte length of authenticator's password,
 *     authenticator's password,
 *     4 byte length of new computer's short-name,
 *     computer's short-name,
 *     4 byte length of new computer's password,
 *     computer's password,
 *     4 byte length of owner list,
 *     comma separated list of user slot IDs that can administer the computer account
 */
#define		kDSStdAuthNewComputer					"dsAuthMethodStandard:dsAuthNewComputer"

/*!
 * @defined kDSStdAuthSetComputerAcctPasswdAsRoot
 * @discussion Set password for a computer account using the
 *		current credentials.
 *     The buffer is packed as follows:
 *
 *     4 byte length of user name,
 *     user name in UTF8 encoding,
 *     4 byte length of new password,
 *     new password in UTF8 encoding
 *     4 byte length of service list,
 *     comma-delimited service list,
 *     4 byte length of hostname list,
 *	   comma-delimited hostname list,
 *     4 byte length of local KDC realm,
 *     local KDC realm
 */
#define		kDSStdAuthSetComputerAcctPasswdAsRoot	"dsAuthMethodStandard:dsAuthSetComputerAcctPasswdAsRoot"

/*!
 * @defined kDSStdAuthNodeNativeRetainCredential
 * @discussion The plug-in should determine which specific authentication method to use.
 *		This auth method is identical to kDSStdAuthNodeNativeClearTextOK, except that
 *		it retains the authentication for future calls to dsDoDirNodeAuth(). The behavior
 *		differs from setting authOnly=false in that the method does not try to get write
 *		access to the directory node and therefore doesn't redirect to the master LDAP server.
 *
 *     The buffer is packed as follows:
 *
 *     4 byte length of user name,
 *     user name in UTF8 encoding,
 *     4 byte length of password,
 *     password in UTF8 encoding
 *
 *     The plug-in may choose to use a cleartext authentication method if necessary.
 */
#define		kDSStdAuthNodeNativeRetainCredential			"dsAuthMethodStandard:dsAuthNodeNativeRetainCredential"

/*!
 * @defined kDSNAttrOriginalAuthenticationAuthority
 * @discussion Used by security agent to store copies of auth authority on the local node
 */
#define		kDSNAttrOriginalAuthenticationAuthority		"dsAttrTypeStandard:OriginalAuthenticationAuthority"

/*!
 * @defined kDSNAttrTrustInformation
 * @discussion Clients can use with dsGetDirNodeInfo calls to verify trust information with the directory.
 *             Values include FullTrust, PartialTrust, Authenticated, or Anonymous.
 *             Any combination of the values can be used to signify multiple states or maximum value.
 */
#define		kDSNAttrTrustInformation					"dsAttrTypeStandard:TrustInformation"

/*!
 * @defined kDSNotifyGlobalRecordUpdatePrefix
 * @discussion Can be used in conjunction with arbitrary types "users", "groups", etc.
 *             Example:  kDSNotifyGlobalRecordUpdatePrefix "users"
 */
#define		kDSNotifyGlobalRecordUpdatePrefix			"com.apple.system.DirectoryService.update."

/*!
 * @defined kDSNotifyLocalRecordUpdatePrefix
 * @discussion Can be used in conjunction with arbitrary types "users", "groups", etc.
 *             Example:  kDSNotifyLocalRecordUpdatePrefix "users"
 */
#define		kDSNotifyLocalRecordUpdatePrefix			"com.apple.system.DirectoryService.update.Local."

/*!
 * @defined kDSNotifyLocalRecordUpdateUsers
 * @discussion Notification sent when a local user(s) record is updated
 */
#define		kDSNotifyLocalRecordUpdateUsers				"com.apple.system.DirectoryService.update.Local.users"

/*!
 * @defined kDSNotifyLocalRecordUpdateGroups
 * @discussion Notification sent when a local group(s) record is updated
 */
#define		kDSNotifyLocalRecordUpdateGroups				"com.apple.system.DirectoryService.update.Local.groups"

/*!
 * @defined kDSStdAuthSetCertificateHashAsRoot
 * @discussion Set certificate using the authenticated user's credentials.
 *     The buffer is packed as follows:
 *
 *     4 byte length of user name,
 *     user name in UTF8 encoding,
 *     4 byte length of certificate hash (40),
 *     hashed certificate data (40 hex characters)
 */
#define		kDSStdAuthSetCertificateHashAsRoot				"dsAuthMethodStandard:dsAuthSetCertificateHashAsRoot"

/*!
 * @defined kDSValueAuthAuthorityKerberosv5Cert
 * @discussion Standard auth authority value for Kerberos v5 authentication.
 */
#define		kDSValueAuthAuthorityKerberosv5Cert				";Kerberosv5Cert;"

/*!
 * @defined kDSTagAuthAuthorityKerberosv5Cert
 * @discussion Standard center tag data of auth authority value for Kerberos v5 authentication.
 */
#define		kDSTagAuthAuthorityKerberosv5Cert				"Kerberosv5Cert"


#endif	// __DirServicesConstPriv_h__
