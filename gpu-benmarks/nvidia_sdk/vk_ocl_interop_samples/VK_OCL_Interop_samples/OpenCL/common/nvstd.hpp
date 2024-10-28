#ifndef __NVSTD_HPP__
#define __NVSTD_HPP__

// For GCC_DIAG_PRAGMA
#include <cuos.h>
GCC_DIAG_PRAGMA(push)
GCC_DIAG_PRAGMA(ignored "-Wcast-align")
// Earlier versions may complain placement-new is unrecognized
#if __GNUC__ * 100 >= 600
GCC_DIAG_PRAGMA(ignored "-Wplacement-new")
#endif

// WAR - toolkit on ARMv7 uses 4.5 which is too old for push/po
// we just disable globally (see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=47347)
#if ((__GNUC__ * 100) + __GNUC_MINOR__) == 405
#pragma GCC diagnostic ignored "-Wcast-align"
#endif

#if __cplusplus >= 201100 || defined(_WIN32)
  #include <memory>
  namespace nvstd {
    using ::std::shared_ptr;
  }
#else
  #include <boost/tr1/memory.hpp>
  namespace nvstd {
    using ::std::tr1::shared_ptr;
  }
#endif


// gcc 4.1 and MSVC 2010 has broken bind which does not support nesting
#if __cplusplus >= 201100
  #include <functional>
  namespace nvstd {
    using ::std::function;
    using ::std::bind;
    using ::std::ref;
    using ::std::cref;
    namespace placeholders {
      using namespace ::std::placeholders;
    }
  }
#else
  #include <boost/bind/bind.hpp>
  #include <boost/function.hpp>
  namespace nvstd {
    using ::boost::function;
    using ::boost::bind;
    using ::boost::ref;
    using ::boost::cref;
    namespace placeholders {
      // Boost 1.5x have placeholders in anonymous namespace
      static boost::arg<1> _1;
      static boost::arg<2> _2;
      static boost::arg<3> _3;
      static boost::arg<4> _4;
      static boost::arg<5> _5;
      static boost::arg<6> _6;
      static boost::arg<7> _7;
      static boost::arg<8> _8;
      static boost::arg<9> _9;
    }
  }
#endif
GCC_DIAG_PRAGMA(pop)

#endif // __NVSTD_HPP__
