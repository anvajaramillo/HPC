cmake_minimum_required(VERSION 2.8)
project( testOpenCV )
find_package( OpenCV REQUIRED )
add_executable( cargarImagen cargarImagen.c )
target_link_libraries( cargarImagen ${OpenCV_LIBS} )

