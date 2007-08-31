# Optimize.cmake

# http://gcc.gnu.org/onlinedocs/gcc/i386-and-x86_002d64-Options.html
set ( CPU pentium2 )

if ( GENERIC )
	set ( CPU pentium2 ) # our target audience likely don't have older
endif ( GENERIC )

###   DO NOT TOUCH THE FOLLOWING   ###

set ( ARCH "-march=${CPU}" )

if ( GENERIC )
	set ( MTUNE "-mtune=generic") # GCC >=4.x
else ( GENERIC )
	set ( MTUNE "-mtune=native" ) # GCC >=4.x
endif ( GENERIC )

set ( FASTMATH "-ffast-math" )

set ( DEBUG_FLAGS "-g -Wall" )
set ( OPT "-O2" )

set ( WARNALL "-Wall" )

set ( NORTTI "-fno-rtti" )

# a bit questionable optimizations
set ( UNSAFE_MATH_OPT "-funsafe-math-optimizations" )

# only speeds up compilation
set ( PIPE "-pipe" )

###   Architecture   ###
include ( config/Macros.cmake )

TestCompilerFlag ( ARCH ARCHAC )
TestCompilerFlag ( MTUNE MTUNEAC )
TestCompilerFlag ( PIPE PIPEAC )
TestCompilerFlag ( FASTMATH FASTMATHAC )
TestCompilerFlag ( NORTTI NORTTIAC )
TestCompilerFlag ( WARNALL WARNALLAC )
TestCompilerFlag ( OPT OPTAC )

### Test profiling arcs if enabled ###
set ( PROFILING_FLAGS "-pg -fvpt -fprofile-arcs -finstrument-functions" )
if ( PROFILE )
	TestCompilerFlag ( PROFILING_FLAGS )
else ( PROFILE )
	set ( PROFILING_FLAGS "" )
endif ( PROFILE )

###   TEST unsafe math optimizations   ###
if ( UNSAFEOPT )
	TestCompilerFlag ( UNSAFE_MATH_OPT )
else ( UNSAFEOPT )
	set ( UNSAFE_MATH_OPT "" )
endif ( UNSAFEOPT )

###   Set flags   ###

set ( CMAKE_CXX_FLAGS "${OPT} ${WARNALL} ${PIPE} ${ARCH} ${MTUNE} ${FASTMATH} ${PROFILING_FLAGS} ${UNSAFE_MATH_OPT} ${NORTTI}" )
if ( USEENV )
	set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} $ENV{CXXFLAGS}" )
endif ( USEENV )
set ( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} ${DEBUG_FLAGS}" )
set ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} -DNDEBUG" )
