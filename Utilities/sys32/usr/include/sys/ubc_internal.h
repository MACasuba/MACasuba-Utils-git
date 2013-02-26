/*
 * Copyright (c) 1999-2007 Apple Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 * 
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */
/* 
 *	File:	ubc.h
 *	Author:	Umesh Vaishampayan [umeshv@apple.com]
 *		05-Aug-1999	umeshv	Created.
 *
 *	Header file for Unified Buffer Cache.
 *
 */ 

#ifndef	_SYS_UBC_INTERNAL_H_
#define	_SYS_UBC_INTERNAL_H_

#include <sys/appleapiopts.h>
#include <sys/types.h>
#include <sys/kernel_types.h>
#include <sys/ucred.h>
#include <sys/vnode.h>
#include <sys/ubc.h>
#include <sys/mman.h>

#include <sys/cdefs.h>

#include <kern/locks.h>
#include <mach/memory_object_types.h>

#include <libkern/crypto/sha1.h>


#define UBC_INFO_NULL	((struct ubc_info *) 0)


extern struct zone	*ubc_info_zone;


#define MAX_CLUSTERS 4	/* maximum number of vfs clusters per vnode */

struct cl_extent {
	daddr64_t	b_addr;
	daddr64_t	e_addr;
};

struct cl_wextent {
	daddr64_t	b_addr;
	daddr64_t	e_addr;
        int		io_flags;
};

struct cl_readahead {
	lck_mtx_t	cl_lockr;
	daddr64_t	cl_lastr;			/* last block read by client */
	daddr64_t	cl_maxra;			/* last block prefetched by the read ahead */
	int		cl_ralen;			/* length of last prefetch */
};

struct cl_writebehind {
	lck_mtx_t	cl_lockw;
        void	*	cl_scmap;			/* pointer to sparse cluster map */
        int		cl_scdirty;			/* number of dirty pages in the sparse cluster map */
	int		cl_number;			/* number of packed write behind clusters currently valid */
	struct cl_wextent cl_clusters[MAX_CLUSTERS];	/* packed write behind clusters */
};


struct cs_blob {
	struct cs_blob	*csb_next;
	cpu_type_t	csb_cpu_type;
	unsigned int	csb_flags;
	off_t		csb_base_offset;
	off_t		csb_start_offset;
	off_t		csb_end_offset;
	ipc_port_t	csb_mem_handle;
	vm_size_t	csb_mem_size;
	vm_offset_t	csb_mem_offset;
	vm_address_t	csb_mem_kaddr;
	unsigned char	csb_sha1[SHA1_RESULTLEN];
};

/*
 *	The following data structure keeps the information to associate
 *	a vnode to the correspondig VM objects.
 */
struct ubc_info {
	memory_object_t		ui_pager;	/* pager */
	memory_object_control_t	ui_control;	/* VM control for the pager */
	long			ui_flags;	/* flags */
	vnode_t 		ui_vnode;	/* vnode for this ubc_info */
	kauth_cred_t	 	ui_ucred;	/* holds credentials for NFS paging */
	off_t			ui_size;	/* file size for the vnode */

        struct	cl_readahead   *cl_rahead;	/* cluster read ahead context */
        struct	cl_writebehind *cl_wbehind;	/* cluster write behind context */

	struct	cs_blob		*cs_blobs; 	/* for CODE SIGNING */
};

/* Defines for ui_flags */
#define	UI_NONE		0x00000000	/* none */
#define	UI_HASPAGER	0x00000001	/* has a pager associated */
#define	UI_INITED	0x00000002	/* newly initialized vnode */
#define UI_HASOBJREF	0x00000004	/* hold a reference on object */
#define UI_WASMAPPED	0x00000008	/* vnode was mapped */
#define	UI_ISMAPPED	0x00000010	/* vnode is currently mapped */
#define UI_MAPBUSY	0x00000020	/* vnode is being mapped or unmapped */
#define UI_MAPWAITING	0x00000040	/* someone waiting for UI_MAPBUSY */

/*
 * exported primitives for loadable file systems.
 */

__BEGIN_DECLS
__private_extern__ void ubc_init(void);
__private_extern__ int	ubc_umount(mount_t mp);
__private_extern__ void	ubc_unmountall(void);
__private_extern__ memory_object_t ubc_getpager(vnode_t);
__private_extern__ int  ubc_map(vnode_t, int);
__private_extern__ void	ubc_destroy_named(vnode_t);

/* internal only */
__private_extern__ void	cluster_release(struct ubc_info *);
__private_extern__ uint32_t cluster_max_io_size(mount_t, int);
 
 

/* Flags for ubc_getobject() */
#define UBC_FLAGS_NONE		0x0000
#define UBC_HOLDOBJECT		0x0001
#define UBC_FOR_PAGEOUT         0x0002

memory_object_control_t ubc_getobject(vnode_t, int);

int	ubc_info_init(vnode_t);
int	ubc_info_init_withsize(vnode_t, off_t);
void	ubc_info_deallocate(struct ubc_info *);

int	ubc_isinuse(vnode_t, int);
int	ubc_isinuse_locked(vnode_t, int, int);

int	ubc_page_op(vnode_t, off_t, int, ppnum_t *, int *);
int	ubc_range_op(vnode_t, off_t, off_t, int, int *);

int	ubc_getcdhash(vnode_t, off_t, unsigned char *);

int UBCINFOEXISTS(vnode_t);

__END_DECLS


#endif	/* _SYS_UBC_INTERNAL_H_ */
