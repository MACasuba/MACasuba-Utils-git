/*
 * Copyright (c) 2002 Apple Computer, Inc. All rights reserved.
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
 * @header CClientEndPoint
 * Mach endpoint for DirectoryService Framework.
 */

#ifndef __CClientEndPoint_h__
#define __CClientEndPoint_h__	1

#include <mach/message.h>

#include <DirectoryServiceCore/PrivateTypes.h>
#include <DirectoryServiceCore/SharedConsts.h>
#include <DirectoryService/DirServicesTypesPriv.h>


//------------------------------------------------------------------------------
//	* CClientEndPoint
//------------------------------------------------------------------------------

class CClientEndPoint
{
public:
					CClientEndPoint			( const char *inSrvrName );
	virtual		   ~CClientEndPoint			( void );

	static	UInt32	fMessageID;
	static	UInt32	GetMessageID		( void );

	SInt32			Initialize			( void );
	SInt32			SendServerMessage	( sComData *inMsg );
	SInt32			GetServerReply		( sComData **outMsg );

private:
	char		   *fSrvrName;

	mach_port_t		fServerPort;
	mach_port_t		fSessionPort;
	sComData	   *fReplyMsg;

	bool IsLongRequest( sComData *inMsg );
};

#endif
