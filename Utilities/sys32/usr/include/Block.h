/*
 *  Block.h
 *
 *  Copyright 2008 Apple. All rights reserved.
 *
 */

#ifndef _Block_H_
#define _Block_H_

#if !defined(BLOCK_EXPORT)
#   if defined(__cplusplus)
#       define BLOCK_EXPORT extern "C" 
#   else
#       define BLOCK_EXPORT extern
#   endif
#endif

#include <Availability.h>
#include <TargetConditionals.h>

#if __cplusplus
extern "C" {
#endif

// Create a heap based copy of a Block or simply add a reference to an existing one.
// This must be paired with Block_release to recover memory, even when running
// under Objective-C Garbage Collection.
BLOCK_EXPORT void *_Block_copy(const void *aBlock)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

// Lose the reference, and if heap based and last reference, recover the memory
BLOCK_EXPORT void _Block_release(const void *aBlock)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

#if __cplusplus
}
#endif

// Type correct macros

#define Block_copy(...) ((__typeof(__VA_ARGS__))_Block_copy((const void *)(__VA_ARGS__)))
#define Block_release(...) _Block_release((const void *)(__VA_ARGS__))


#endif
