cmake_minimum_required(VERSION 2.8)
project( SobelParaleloCompartida )
find_package( OpenCV REQUIRED )
find_package( CUDA REQUIRED )
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3; -arch=compute_52)
cuda_add_executable( sobel sobel.cu )
target_link_libraries( sobel ${OpenCV_LIBS} )
