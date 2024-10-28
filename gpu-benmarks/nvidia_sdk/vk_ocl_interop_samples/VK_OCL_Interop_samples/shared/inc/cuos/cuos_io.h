
#ifndef _CUOS_IO_H_
#define _CUOS_IO_H_

#include <stdio.h>
#include <stdarg.h>

#if !defined(_WIN32)

#undef __cdecl
#define __cdecl

#endif //!_WIN32

#if defined(CUOS_NAMESPACE)
namespace CUOS_NAMESPACE {
#elif defined(__cplusplus)
extern "C" {
#endif

/* other ones: currently being used in driver code:
   fread fwrite
   fopen fclose
   fseek ftell

   other ones: currently not being used in driver code:
   vprintf vfprintf
   putc putchar puts fputc fputs

   when adding others, also update cuos_mods.h
*/

typedef FILE *(__cdecl *cuosGetOutputFileFn)(void);
extern cuosGetOutputFileFn cuosGetStdout;
extern cuosGetOutputFileFn cuosGetStderr;

typedef int (__cdecl *cuosPrintfFn)(const char *format, ...);
extern cuosPrintfFn cuosPrintf;

typedef int (__cdecl *cuosFflushFn)(FILE *stream);
extern cuosFflushFn cuosFflush;

typedef int (__cdecl *cuosFprintfFn)(FILE *stream, const char *format, ...);
extern cuosFprintfFn cuosFprintf;

#if defined(__cplusplus)
} // namespace or extern "C"
#endif

#endif //_CUOS_IO_H_
