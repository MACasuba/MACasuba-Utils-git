/*
 * Copyright (c) 2002-2009 Apple Inc. All Rights Reserved.
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
	@header SecTrust
	The functions and data types in SecTrust implement trust computation
    and allow the user to apply trust decisions to the trust configuration.
*/

#ifndef _SECURITY_SECTRUST_H_
#define _SECURITY_SECTRUST_H_

#include <Security/SecBase.h>
#include <CoreFoundation/CFArray.h>
#include <CoreFoundation/CFDate.h>

#if defined(__cplusplus)
extern "C" {
#endif

/*!
	@typedef SecTrustResultType
	@abstract Specifies the trust result type.
	@constant kSecTrustResultInvalid Indicates an invalid setting or result.
	@constant kSecTrustResultProceed Indicates you may proceed.  This value
    may be returned by the SecTrustEvaluate function or stored as part of
    the user trust settings. 
	@constant kSecTrustResultConfirm Indicates confirmation with the user
    is required before proceeding.  This value may be returned by the
    SecTrustEvaluate function or stored as part of the user trust settings. 
	@constant kSecTrustResultDeny Indicates a user-configured deny; do not
    proceed. This value may be returned by the SecTrustEvaluate function
    or stored as part of the user trust settings. 
	@constant kSecTrustResultUnspecified Indicates user intent is unknown.
    This value may be returned by the SecTrustEvaluate function or stored
    as part of the user trust settings. 
	@constant kSecTrustResultRecoverableTrustFailure Indicates a trust
    framework failure; retry after fixing inputs. This value may be returned
    by the SecTrustEvaluate function but not stored as part of the user
    trust settings. 
	@constant kSecTrustResultFatalTrustFailure Indicates a trust framework
    failure; no "easy" fix. This value may be returned by the
    SecTrustEvaluate function but not stored as part of the user trust
    settings.
	@constant kSecTrustResultOtherError Indicates a failure other than that
    of trust evaluation. This value may be returned by the SecTrustEvaluate
    function but not stored as part of the user trust settings.
 */
typedef UInt32 SecTrustResultType;
enum {
    kSecTrustResultInvalid,
    kSecTrustResultProceed,
    kSecTrustResultConfirm,
    kSecTrustResultDeny,
    kSecTrustResultUnspecified,
    kSecTrustResultRecoverableTrustFailure,
    kSecTrustResultFatalTrustFailure,
    kSecTrustResultOtherError
};


/*!
	@typedef SecTrustRef
	@abstract CFType used for performing X.509 certificate trust evaluations.
*/
typedef struct __SecTrust *SecTrustRef;

/*!
	@function SecTrustGetTypeID
	@abstract Returns the type identifier of SecTrust instances.
	@result The CFTypeID of SecTrust instances.
*/
CFTypeID SecTrustGetTypeID(void)
    __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_2_0);

/*!
	@function SecTrustCreateWithCertificates
	@abstract Creates a trust object based on the given certificates and
    policies.
    @param certificates The group of certificates to verify.
    @param policies An array of one or more policies. You may pass a
    SecPolicyRef to represent a single policy.
	@param trustRef On return, a pointer to the trust management reference.
	@result A result code.  See "Security Error Codes" (SecBase.h).
    @discussion If multiple policies are passed in, all policies must verify
    for the chain to be considered valid.
*/
OSStatus SecTrustCreateWithCertificates(CFArrayRef certificates,
    CFTypeRef policies, SecTrustRef *trustRef)
    __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_2_0);

/*!
	@function SecTrustSetAnchorCertificates
	@abstract Sets the anchor certificates for a given trust.
	@param trust A reference to a trust object.
	@param anchorCertificates An array of anchor certificates.
	@result A result code.  See "Security Error Codes" (SecBase.h).
    @discussion Calling this function without also calling
    SecTrustSetAnchorCertificatesOnly() will disable trusting any
    anchors other than the ones in anchorCertificates.
*/
OSStatus SecTrustSetAnchorCertificates(SecTrustRef trust,
    CFArrayRef anchorCertificates)
    __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_2_0);

/*!
	@function SecTrustSetAnchorCertificatesOnly
	@abstract Reenables trusting anchor certificates in addition to those
    passed in via the SecTrustSetAnchorCertificates API.
	@param trust A reference to a trust object.
	@param anchorCertificatesOnly If true, disables trusting any anchors other
    than the ones passed in via SecTrustSetAnchorCertificates().  If false,
    the built in anchor certificates are also trusted.
	@result A result code.  See "Security Error Codes" (SecBase.h).
*/
OSStatus SecTrustSetAnchorCertificatesOnly(SecTrustRef trust,
    Boolean anchorCertificatesOnly)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_2_0);

/*!
	@function SecTrustSetVerifyDate
	@abstract Set the date on which the trust should be verified.
	@param trust A reference to a trust object.
	@param verifyDate The date on which to verify trust.
	@result A result code.  See "Security Error Codes" (SecBase.h).
    @discussion If this function is not called the time at which
    SecTrustEvaluate() is called is used implicitly as the verification time.
*/
OSStatus SecTrustSetVerifyDate(SecTrustRef trust, CFDateRef verifyDate)
    __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_2_0);

/*!
	@function SecTrustGetVerifyTime
	@abstract Returns the verify time.
	@param trust A reference to the trust object to verify.
	@result A CFAbsoluteTime value representing the time at which certificates
	should be checked for validity.
*/
CFAbsoluteTime SecTrustGetVerifyTime(SecTrustRef trust)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_2_0);

/*!
	@function SecTrustEvaluate
	@abstract Evaluates a trust.
	@param trust A reference to the trust object to evaluate.
	@param result A pointer to a result type.
	@result A result code.  See "Security Error Codes" (SecBase.h).	
*/
OSStatus SecTrustEvaluate(SecTrustRef trust, SecTrustResultType *result)
    __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_2_0);

/*!
	@function SecTrustCopyPublicKey
	@abstract Return the public key for a leaf certificate after it has 
	been evaluated.
	@param trust A reference to the trust object which has been evaluated.
	@result The certificate's public key, or NULL if it the public key could
	not be extracted (this can happen with DSA certificate chains if the
        parameters in the chain cannot be found).  The caller is responsible
        for calling CFRelease on the returned key when it is no longer needed.
*/
SecKeyRef SecTrustCopyPublicKey(SecTrustRef trust)
    __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_2_0);

/*!
	@function SecTrustGetCertificateCount
	@abstract Returns the number of certificates in an evaluated certificate
    chain.
	@param trust Reference to a trust object.
	@result The number of certificates in the trust chain.  This function will
    return 1 if the trust has not been evaluated, and the number of
    certificates in the chain including the anchor if it has.
*/
CFIndex SecTrustGetCertificateCount(SecTrustRef trust)
    __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_2_0);

/*!
	@function SecTrustGetCertificateAtIndex
	@abstract Returns a certificate from the trust chain.
	@param trust Reference to a trust object.
	@param ix The index of the requested certificate.  Indices run from 0
    (leaf) to the anchor (or last certificate found if no anchor was found).
    The leaf cert (index 0) is always present regardless of whether the trust
    reference has been evaluated or not.
	@result A SecCertificateRef for the requested certificate.
*/
SecCertificateRef SecTrustGetCertificateAtIndex(SecTrustRef trust, CFIndex ix)
    __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_2_0);

#if defined(__cplusplus)
}
#endif

#endif /* !_SECURITY_SECTRUST_H_ */
