#ifndef __gl_es20ext_h_
#define __gl_es20ext_h_

#ifdef __cplusplus
extern "C" {
#endif

/*
** License Applicability. Except to the extent portions of this file are
** made subject to an alternative license as permitted in the SGI Free
** Software License B, Version 1.0 (the "License"), the contents of this
** file are subject only to the provisions of the License. You may not use
** this file except in compliance with the License. You may obtain a copy
** of the License at Silicon Graphics, Inc., attn: Legal Services, 1600
** Amphitheatre Parkway, Mountain View, CA 94043-1351, or at:
**
** http://oss.sgi.com/projects/FreeB
**
** Note that, as provided in the License, the Software is distributed on an
** "AS IS" basis, with ALL EXPRESS AND IMPLIED WARRANTIES AND CONDITIONS
** DISCLAIMED, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES AND
** CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A
** PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
**
** Original Code. The Original Code is: OpenGL Sample Implementation,
** Version 1.2.1, released January 26, 2000, developed by Silicon Graphics,
** Inc. The Original Code is Copyright (c) 1991-2000 Silicon Graphics, Inc.
** Copyright in any portions created by third parties is as indicated
** elsewhere herein. All Rights Reserved.
**
** Additional Notice Provisions: The application programming interfaces
** established by SGI in conjunction with the Original Code are The
** OpenGL(R) Graphics System: A Specification (Version 1.2.1), released
** April 1, 1999; The OpenGL(R) Graphics System Utility Library (Version
** 1.3), released November 4, 1998; and OpenGL(R) Graphics with the X
** Window System(R) (Version 1.3), released October 19, 1998. This software
** was created using the OpenGL(R) version 1.2.1 Sample Implementation
** published by SGI, but has not been independently verified as being
** compliant with the OpenGL(R) version 1.2.1 Specification.
*/

#ifndef GL_APIENTRYP
#   define GL_APIENTRYP GL_APIENTRY*
#endif

#define GL_OES_depth24                                          1
#define GL_OES_mapbuffer                                        1
#define GL_OES_packed_depth_stencil                             1
#define GL_OES_fbo_render_mipmap                                1
#define GL_OES_rgb8_rgba8                                       1
#define GL_OES_standard_derivatives                             1
#define GL_IMG_read_format                                      1
#define GL_IMG_texture_compression_pvrtc                        1
#define GL_IMG_texture_format_BGRA8888                          1
#define GL_EXT_blend_minmax                                     1
#define GL_EXT_texture_filter_anisotropic                       1

/*------------------------------------------------------------------------*
 * OES extension tokens
 *------------------------------------------------------------------------*/

#if GL_OES_depth24
#define GL_DEPTH_COMPONENT24_OES                                0x81A6
#endif

#if GL_OES_mapbuffer
#define GL_WRITE_ONLY_OES                                       0x88B9
#define GL_BUFFER_ACCESS_OES                                    0x88BB
#define GL_BUFFER_MAPPED_OES                                    0x88BC
#define GL_BUFFER_MAP_POINTER_OES                               0x88BD
#endif

#if GL_OES_packed_depth_stencil
#define GL_DEPTH_STENCIL_OES                                    0x84F9
#define GL_UNSIGNED_INT_24_8_OES                                0x84FA
#define GL_DEPTH24_STENCIL8_OES                                 0x88F0
#endif

#if GL_OES_rgb8_rgba8
#define GL_RGB8_OES                                             0x8051
#define GL_RGBA8_OES                                            0x8058
#endif

#if GL_OES_standard_derivatives
#define GL_FRAGMENT_SHADER_DERIVATIVE_HINT_OES                  0x8B8B
#endif


/*------------------------------------------------------------------------*
 * IMG extension tokens
 *------------------------------------------------------------------------*/

#if GL_IMG_texture_compression_pvrtc
#define GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG                      0x8C00
#define GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG                      0x8C01
#define GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG                     0x8C02
#define GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG                     0x8C03
#endif

#if GL_IMG_read_format
#define GL_UNSIGNED_SHORT_4_4_4_4_REV                           0x8365
#endif

#if GL_IMG_read_format || GL_IMG_texture_format_BGRA8888
#define GL_BGRA                                                 0x80E1
#endif

/*------------------------------------------------------------------------*
 * EXT extension tokens
 *------------------------------------------------------------------------*/

#if GL_EXT_blend_minmax
#define GL_MIN_EXT                                              0x8007
#define GL_MAX_EXT                                              0x8008
#endif

#if GL_EXT_texture_filter_anisotropic
#define GL_TEXTURE_MAX_ANISOTROPY_EXT                           0x84FE
#define GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT                       0x84FF
#endif

/*------------------------------------------------------------------------*
 * OES extension functions
 *------------------------------------------------------------------------*/

#if GL_OES_mapbuffer
GL_API void GL_APIENTRY glGetBufferPointervOES (GLenum target, GLenum pname, GLvoid **params);
GL_API GLvoid * GL_APIENTRY glMapBufferOES (GLenum target, GLenum access);
GL_API GLboolean GL_APIENTRY glUnmapBufferOES (GLenum target);
#endif

#ifdef __cplusplus
}
#endif

#endif /* __gl_es20ext_h_ */

