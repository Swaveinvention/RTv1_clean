# Helper macro to generate PTX from the CUDA files in sutil.
macro(OPTIX_sutil_compile_to_optix_input generated_files)
  if( NOT CUDA_NVRTC_ENABLED )
    if( SAMPLES_INPUT_GENERATE_OPTIXIR )
      message("sutil OPTIXIR")
      CUDA_WRAP_SRCS( sutil OPTIXIR generated_files2 ${ARGN} )
      list(APPEND ${generated_files} ${generated_files2})
    endif()
    if( SAMPLES_INPUT_GENERATE_PTX )
      message("sutil PTX")
      CUDA_WRAP_SRCS( sutil PTX generated_files3 ${ARGN} )
      list(APPEND ${generated_files} ${generated_files3})
    endif()
  endif()
  message("${generated_files} = ${${generated_files}}")
endmacro()