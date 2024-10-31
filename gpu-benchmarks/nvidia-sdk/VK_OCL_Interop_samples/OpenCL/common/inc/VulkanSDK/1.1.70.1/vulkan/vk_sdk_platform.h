




#ifndef VK_SDK_PLATFORM_H
#define VK_SDK_PLATFORM_H

#if defined(_WIN32)
#define NOMINMAX
#ifndef __cplusplus
#undef inline
#define inline __inline
#endif 

#if (defined(_MSC_VER) && _MSC_VER < 1900 )






#define snprintf _snprintf
#endif

#define strdup _strdup

#endif 


#ifndef NOEXCEPT
#if defined(__clang__)
#if __has_feature(cxx_noexcept)
#define HAS_NOEXCEPT
#endif
#else
#if defined(__GXX_EXPERIMENTAL_CXX0X__) && __GNUC__ * 10 + __GNUC_MINOR__ >= 46
#define HAS_NOEXCEPT
#else
#if defined(_MSC_FULL_VER) && _MSC_FULL_VER >= 190023026 && defined(_HAS_EXCEPTIONS) && _HAS_EXCEPTIONS
#define HAS_NOEXCEPT
#endif
#endif
#endif

#ifdef HAS_NOEXCEPT
#define NOEXCEPT noexcept
#else
#define NOEXCEPT
#endif
#endif

#endif  
