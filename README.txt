The Incredibly Compily Build
============================
Kyle Machulis <kyle@nonpolynomial.com>
Version 1.0.0, August 30, 2009

== What You Probably Want To Do ==

Are you just building an NP Labs project that you got the archive for? Then you most likely want to just build and get it over with versus reading about how the underpinnings of the build system work. In the project root, just do a

mkdir build

Then 

cd build

Then 

cmake ..

And if you're missing anything, cmake will tell you.

However, if you're interested in how I do my personal development or want to use the build system to its full extend, read on.

== Description ==

Compily Buildd is a compilation of python scripts and cmake functions that I've put together over a few years of building cross platform software, mainly of the driver/hardware interaction variety. It relies on cmake for all of the project generation, and python to do things like git version fetching, cmake command line creation, and other utilties that would be annoying if not impossible to do in cmake. 

While the system is certainly helpful to anyone who needs to quickly build and cross-compile for multiple platforms out of the same source root, only the absolute minimal cmake portions are needed for building any Nonpolynomial Labs project. This build system also ships with every release of any NP Labs project.

The hope is that if someone really wants to use this system for their own build projects, they can, but otherwise it should stay small and lightweight enough to be shipped with NP Labs projects and stay out of the way otherwise.

==  Requirements ==

=== cmake ===

http://www.cmake.org

=== python (optional)  ===

Used for build target creation, git version updates, etc... Not required for building projects with the system, but nice to have.

http://www.python.org

== Compily Buildd Compartments ==

=== Cmake Scripts ===

The CMake portion of Compily Buildd consists of 3 main scripts:

- BuildSysCMakeLib.cmake - The file included by outside projects. Contains the INITIALIZE_PROJECT() macro and include all other cmake files.
- CMakeOptions.cmake - Options for cmake building that can be turned on and off using command line defines, ccmake, or cmake-gui. Mostly compiler options (-ffast-math, debug messages, etc...).
- CMakeFunctions.cmake - Functions for building libraries and executables. Mainly wrappers for oft-used library/executable target functions. The functions here are by no means an end-all solution for cmake target building, but they do everything I need pretty well.

=== Python Scripts ===



== Repository Layout using Compily Buildd ==

Here's how I usually set up my build directories for multi project development

|- build
|-- compily_buildd [the repo containing the Compily Buildd system code]
|-- library [This is where platform specific libraries go, same layout as a /usr directory]
|--- usr_windows_mingw4_x86
|---- include
|---- lib
|---- bin
|--- usr_darwin_10.5_x86
|---- ... [same layout as above]
|--- ... [one directory for all platforms I will need to compile with on this build directory]
|-- [project name - each project root goes here, i.e. ...]
|-- libnifalcon
|-- libtrancevibe
|-- ...


So, when I check out a system that uses Compily Buildd, it first checks to see if the compily_buildd directory is available in the directory below its root. If it's not there, then it checks to see if compily_buildd is included in the repo itself (every NP Labs repo has a git submodule that uses compily buildd, and every NP Labs software release comes with the version of Compily Buildd current to that release, so it should 'just work'). If it can't find compily_buildd, then cmake throws an error telling where to get it.

== Target Forming ==

Build directories in a Compily Build system take on the following format

build_[platform]_[build type]_[link type]_[other]

So, for instance, if you want to build a makefile based static release set of binaries and libraries on OS X 10.5 x86, you'd do a

make darwin_10.5_x86_release_static

and the build system would create the directory

[project root]/build_darwin_10.5_x86_release_static

and would then create the CMake initialization line to fill that directory with the needed files, which for examples sake would look like

cmake -G "Unix Makefiles" -DBUILDSYS_BUILD_VARS_REQUIRED=ON -DBUILDSYS_BUILD_PLATFORM=darwin_10.5_x86 -DBUILDSYS_BUILD_DIR=build_darwin_10.5_x86_release_static -DBUILD_SHARED=OFF -DBUILD_STATIC=ON -DCMAKE_BUILD_TYPE=Release ..

Here's what the various parts of that mean:

- BUILDSYS_BUILD_VARS_REQUIRED
-- This tells the build system to throw errors if any of our required build variables (BUILDSYS_*) are missing, and to run certain commands to make sure that we fill in search paths correctly if they are included
- BUILDSYS_BUILD_PLATFORM 
-- This variable is used to create the library directory name, i.e. usr_darwin_10.5_x86. We look for all of our libraries there first before searching the rest of the system
- BUILDSYS_BUILD_DIR
-- The directory cmake will generate everything in and that we'll use for intermediate build files and output
- BUILD_SHARED
-- Whether or not we should build shared objects
- BUILD_STATIC
-- Whether or not we should build static objects
- CMAKE_BUILD_TYPE
-- Type of build to create. Regardless of IDE or command line, each directory can only build one type at the moment.

== Generator Specifics ==


== Why is it called Compily Buildd? ==

Basically, I really hate naming things.

My old build system repo was called build_sys. It's usually managed outside of the directory I'm building in myself because all my projects use it. However, when distributing source, that becomes a subdirectory (to include all the needed build scripts with the distro), which means it's linked off the project repo's root, i.e. [project name]/build_sys

Unfortunately, my build scripts create platform and build specific directories that start with build_* too, i.e. build_darwin_10.5_x86_release_static_distcc (yes I'm that long winded, you try dealing with single source heavily cross platform cross compiled development with a single directory named 'build' and see how long it takes you to start doing it, too)

The easiest way to do a development clean on a project root is 'rm -rf build_*', which would also take out the build system itself if someone was building from an archive.

I was thinking about naming it compile_system, but that's kinda eh (and if there's anything a build system doesn't need more of, it's eh), and not something I could really tell people to search for when talking to them.

So, now, it's called "Compily Buildd" (or compily_buildd as the repo/dir name), named after the "Incredible Drivy Runn" level in the SkullMonkeys video game. The level video is available at:

http://www.youtube.com/watch?v=EzZiyAXbe3g

== Credits ==

Compily Buildd is maintained by Kyle Machulis
More information at Nonpolynomial Labs - http://www.nonpolynomial.com

Contributions by
Andrew Schultz

Development of Compily Buildd happens in tandem with the BuildSys system at 510 Systems. 
