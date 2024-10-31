#ifndef  __FREEGLUT_EXT_H__
#define  __FREEGLUT_EXT_H__



#ifdef __cplusplus
    extern "C" {
#endif


#define GLUT_ACTION_EXIT                         0
#define GLUT_ACTION_GLUTMAINLOOP_RETURNS         1
#define GLUT_ACTION_CONTINUE_EXECUTION           2


#define GLUT_CREATE_NEW_CONTEXT                  0
#define GLUT_USE_CURRENT_CONTEXT                 1


#define  GLUT_ACTION_ON_WINDOW_CLOSE        0x01F9

#define  GLUT_WINDOW_BORDER_WIDTH           0x01FA
#define  GLUT_WINDOW_HEADER_HEIGHT          0x01FB

#define  GLUT_VERSION                       0x01FC

#define  GLUT_RENDERING_CONTEXT             0x01FD


FGAPI void    FGAPIENTRY glutMainLoopEvent( void );
FGAPI void    FGAPIENTRY glutLeaveMainLoop( void );


FGAPI void    FGAPIENTRY glutMouseWheelFunc( void (* callback)( int, int, int, int ) );
FGAPI void    FGAPIENTRY glutCloseFunc( void (* callback)( void ) );
FGAPI void    FGAPIENTRY glutWMCloseFunc( void (* callback)( void ) );

FGAPI void    FGAPIENTRY glutMenuDestroyFunc( void (* callback)( void ) );


FGAPI void    FGAPIENTRY glutSetOption ( GLenum option_flag, int value ) ;

FGAPI void*   FGAPIENTRY glutGetWindowData( void );
FGAPI void    FGAPIENTRY glutSetWindowData(void* data);
FGAPI void*   FGAPIENTRY glutGetMenuData( void );
FGAPI void    FGAPIENTRY glutSetMenuData(void* data);


FGAPI int     FGAPIENTRY glutBitmapHeight( void* font );
FGAPI GLfloat FGAPIENTRY glutStrokeHeight( void* font );
FGAPI void    FGAPIENTRY glutBitmapString( void* font, const unsigned char *string );
FGAPI void    FGAPIENTRY glutStrokeString( void* font, const unsigned char *string );


FGAPI void    FGAPIENTRY glutWireRhombicDodecahedron( void );
FGAPI void    FGAPIENTRY glutSolidRhombicDodecahedron( void );
FGAPI void    FGAPIENTRY glutWireSierpinskiSponge ( int num_levels, GLdouble offset[3], GLdouble scale ) ;
FGAPI void    FGAPIENTRY glutSolidSierpinskiSponge ( int num_levels, GLdouble offset[3], GLdouble scale ) ;
FGAPI void    FGAPIENTRY glutWireCylinder( GLdouble radius, GLdouble height, GLint slices, GLint stacks);
FGAPI void    FGAPIENTRY glutSolidCylinder( GLdouble radius, GLdouble height, GLint slices, GLint stacks);


FGAPI void * FGAPIENTRY glutGetProcAddress( const char *procName );


#ifdef __cplusplus
    }
#endif



#endif 
