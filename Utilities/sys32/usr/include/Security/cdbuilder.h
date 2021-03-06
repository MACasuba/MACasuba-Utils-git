/*
 * Copyright (c) 2006 Apple Computer, Inc. All Rights Reserved.
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

//
// cdbuilder - constructor for CodeDirectories
//
#ifndef _H_CDBUILDER
#define _H_CDBUILDER

#include "codedirectory.h"


namespace Security {
namespace CodeSigning {


//
// Builder can construct CodeDirectories from pieces:
//	Builder builder;
//	builder.variousSetters(withSuitableData);
//  CodeDirectory *result = builder.build();
// Builder is not reusable.
//
class CodeDirectory::Builder {
public:
	Builder();
	
	void executable(string path, size_t pagesize, size_t offset, size_t length);
	void reopen(string path, size_t offset, size_t length);

	void special(size_t slot, CFDataRef data);
	void identifier(const std::string &code) { mIdentifier = code; }
	void flags(uint32_t f) { mFlags = f; }
	
	size_t size();								// calculate size
	CodeDirectory *build();						// build CodeDirectory and return it
	
private:
	Hash::SDigest mSpecial[cdSlotCount];		// special slot hashes
	UnixPlusPlus::AutoFileDesc mExec;			// main executable file
	size_t mExecOffset;							// starting offset in mExec
	size_t mExecLength;							// total bytes of file to sign
	size_t mPageSize;							// page size of executable (bytes)
	uint32_t mFlags;							// CodeDirectory flags
	std::string mIdentifier;					// canonical identifier
	
	size_t mSpecialSlots;						// highest special slot set
	size_t mCodeSlots;							// number of code pages (slots)
	
	CodeDirectory *mDir;						// what we're building
};


}	// CodeSigning
}	// Security


#endif //_H_CDBUILDER
