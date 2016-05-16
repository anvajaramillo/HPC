cmake_minimum_required(VERSION 2.8)
project( MostrarImagenGrises )
find_package( OpenCV REQUIRED )
add_executable( grises grises.cpp )
target_link_libraries( grises ${OpenCV_LIBS} )

