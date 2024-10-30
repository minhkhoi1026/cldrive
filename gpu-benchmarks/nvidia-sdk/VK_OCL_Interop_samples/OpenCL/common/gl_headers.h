// This is a platform specific header file where we include the GL headers.
#ifndef _gl_headers_h
#define _gl_headers_h

#if defined( __APPLE__ )
    #include <OpenGL/OpenGL.h>
#if defined(CGL_VERSION_1_3)     
    #include <OpenGL/gl3.h>
    #include <OpenGL/gl3ext.h>
#else
    #include <OpenGL/gl.h>
    #include <OpenGL/glext.h>
#endif    
    #include <GLUT/glut.h>
#else
#ifdef _WIN32
    #include <windows.h>
#endif    
 	#include <GL/glew.h>
    #include <GL/gl.h> 
 	#include <GL/glext.h>
#ifdef _WIN32
    #include <GL/glut.h> 
#else
    #include <GL/freeglut.h> 
#endif

#endif

#ifdef _WIN32
    // No glutGetProcAddress in the standard glut v3.7.
    #define glutGetProcAddress(procName) wglGetProcAddress(procName)
#endif


#endif	// __gl_headers_h

