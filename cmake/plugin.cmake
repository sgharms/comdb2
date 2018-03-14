macro(add_static_plugin LIBNAME SOURCES)
  set(PLUGIN_SYM "comdb2_plugin_${LIBNAME}")
  configure_file(plugin.h.in plugin.h @ONLY)
  add_library(${LIBNAME} STATIC ${SOURCES})
  set(PLUGIN_LIBRARIES "${PLUGIN_LIBRARIES};${LIBNAME}"
      CACHE STRING
      "List of static plugin library paths"
      FORCE)
endmacro()

macro(add_dynamic_plugin LIBNAME SOURCES)
  set(PLUGIN_SYM "comdb2_plugin")
  configure_file(plugin.h.in plugin.h @ONLY)
  add_library(${LIBNAME} SHARED ${SOURCES})
  install(TARGETS ${LIBNAME} LIBRARY DESTINATION lib/plugin)
endmacro()

macro(add_plugin LIBNAME TYPE SOURCES)
  string(TOLOWER ${TYPE} _TYPE)
  string(TOLOWER ${COMDB2_PLUGIN_TYPE} _COMDB2_PLUGIN_TYPE)

  if (${_COMDB2_PLUGIN_TYPE} STREQUAL "preferred")
    if(${_TYPE} STREQUAL "static")
      add_static_plugin(${LIBNAME} "${SOURCES}")
    elseif(${_TYPE} STREQUAL "dynamic")
      add_dynamic_plugin(${LIBNAME} "${SOURCES}")
    else()
      message(FATAL_ERROR "Unsupported plugin type: ${TYPE}")
    endif()
  elseif(${_COMDB2_PLUGIN_TYPE} STREQUAL "static")
    add_static_plugin(${LIBNAME} "${SOURCES}")
  elseif(${_COMDB2_PLUGIN_TYPE} STREQUAL "dynamic")
    add_dynamic_plugin(${LIBNAME} "${SOURCES}")
  else()
    message(FATAL_ERROR "Unsupported COMDB2_PLUGIN_TYPE : ${COMDB2_PLUGIN_TYPE}")
  endif()
endmacro()
