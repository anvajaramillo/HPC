# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/hera_hpccourse/Angie/MostrarImagen

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/hera_hpccourse/Angie/MostrarImagen/build

# Include any dependencies generated for this target.
include CMakeFiles/cargarImagen.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/cargarImagen.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/cargarImagen.dir/flags.make

CMakeFiles/cargarImagen.dir/cargarImagen.c.o: CMakeFiles/cargarImagen.dir/flags.make
CMakeFiles/cargarImagen.dir/cargarImagen.c.o: ../cargarImagen.c
	$(CMAKE_COMMAND) -E cmake_progress_report /home/hera_hpccourse/Angie/MostrarImagen/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/cargarImagen.dir/cargarImagen.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/cargarImagen.dir/cargarImagen.c.o   -c /home/hera_hpccourse/Angie/MostrarImagen/cargarImagen.c

CMakeFiles/cargarImagen.dir/cargarImagen.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/cargarImagen.dir/cargarImagen.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -E /home/hera_hpccourse/Angie/MostrarImagen/cargarImagen.c > CMakeFiles/cargarImagen.dir/cargarImagen.c.i

CMakeFiles/cargarImagen.dir/cargarImagen.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/cargarImagen.dir/cargarImagen.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_FLAGS) -S /home/hera_hpccourse/Angie/MostrarImagen/cargarImagen.c -o CMakeFiles/cargarImagen.dir/cargarImagen.c.s

CMakeFiles/cargarImagen.dir/cargarImagen.c.o.requires:
.PHONY : CMakeFiles/cargarImagen.dir/cargarImagen.c.o.requires

CMakeFiles/cargarImagen.dir/cargarImagen.c.o.provides: CMakeFiles/cargarImagen.dir/cargarImagen.c.o.requires
	$(MAKE) -f CMakeFiles/cargarImagen.dir/build.make CMakeFiles/cargarImagen.dir/cargarImagen.c.o.provides.build
.PHONY : CMakeFiles/cargarImagen.dir/cargarImagen.c.o.provides

CMakeFiles/cargarImagen.dir/cargarImagen.c.o.provides.build: CMakeFiles/cargarImagen.dir/cargarImagen.c.o

# Object files for target cargarImagen
cargarImagen_OBJECTS = \
"CMakeFiles/cargarImagen.dir/cargarImagen.c.o"

# External object files for target cargarImagen
cargarImagen_EXTERNAL_OBJECTS =

cargarImagen: CMakeFiles/cargarImagen.dir/cargarImagen.c.o
cargarImagen: CMakeFiles/cargarImagen.dir/build.make
cargarImagen: /usr/local/lib/libopencv_videostab.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_video.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_ts.a
cargarImagen: /usr/local/lib/libopencv_superres.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_stitching.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_photo.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_ocl.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_objdetect.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_nonfree.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_ml.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_legacy.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_imgproc.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_highgui.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_gpu.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_flann.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_features2d.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_core.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_contrib.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_calib3d.so.2.4.12
cargarImagen: /usr/lib/x86_64-linux-gnu/libGLU.so
cargarImagen: /usr/lib/x86_64-linux-gnu/libGL.so
cargarImagen: /usr/lib/x86_64-linux-gnu/libSM.so
cargarImagen: /usr/lib/x86_64-linux-gnu/libICE.so
cargarImagen: /usr/lib/x86_64-linux-gnu/libX11.so
cargarImagen: /usr/lib/x86_64-linux-gnu/libXext.so
cargarImagen: /usr/local/lib/libopencv_nonfree.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_ocl.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_gpu.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_photo.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_objdetect.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_legacy.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_video.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_ml.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_calib3d.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_features2d.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_highgui.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_imgproc.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_flann.so.2.4.12
cargarImagen: /usr/local/lib/libopencv_core.so.2.4.12
cargarImagen: /usr/local/cuda-7.5/lib64/libcudart.so
cargarImagen: /usr/local/cuda-7.5/lib64/libnppc.so
cargarImagen: /usr/local/cuda-7.5/lib64/libnppi.so
cargarImagen: /usr/local/cuda-7.5/lib64/libnpps.so
cargarImagen: /usr/local/cuda-7.5/lib64/libcufft.so
cargarImagen: CMakeFiles/cargarImagen.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable cargarImagen"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/cargarImagen.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/cargarImagen.dir/build: cargarImagen
.PHONY : CMakeFiles/cargarImagen.dir/build

CMakeFiles/cargarImagen.dir/requires: CMakeFiles/cargarImagen.dir/cargarImagen.c.o.requires
.PHONY : CMakeFiles/cargarImagen.dir/requires

CMakeFiles/cargarImagen.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/cargarImagen.dir/cmake_clean.cmake
.PHONY : CMakeFiles/cargarImagen.dir/clean

CMakeFiles/cargarImagen.dir/depend:
	cd /home/hera_hpccourse/Angie/MostrarImagen/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hera_hpccourse/Angie/MostrarImagen /home/hera_hpccourse/Angie/MostrarImagen /home/hera_hpccourse/Angie/MostrarImagen/build /home/hera_hpccourse/Angie/MostrarImagen/build /home/hera_hpccourse/Angie/MostrarImagen/build/CMakeFiles/cargarImagen.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/cargarImagen.dir/depend

