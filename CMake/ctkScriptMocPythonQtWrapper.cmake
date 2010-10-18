###########################################################################
#
#  Library:   CTK
# 
#  Copyright (c) Kitware Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.commontk.org/LICENSE
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# 
###########################################################################

#
# ctkScriptMocPythonQtWrapper
#

#
# This script should be invoked either as a CUSTOM_COMMAND 
# or from the command line using the following syntax:
#
#    cmake -DWRAPPING_NAMESPACE:STRING=org.commontk -DTARGET:STRING=MyLib
#          -DOUTPUT_DIR:PATH=/path -DINCLUDE_DIRS:STRING=/path1:/path2
#          -DWRAPPER_MASTER_MOC_FILE:FILEPATH=/path/to/file
#          -DQT_QMAKE_EXECUTABLE:PATH=/path/to/qt/qmake
#           -P ctkScriptWrapPythonQt.cmake
#
#

# Check for non-defined var
FOREACH(var WRAPPING_NAMESPACE TARGET MOC_FLAGS WRAPPER_MASTER_MOC_FILE WRAP_INT_DIR)
  IF(NOT DEFINED ${var})
    MESSAGE(SEND_ERROR "${var} not specified when calling ctkScriptMocPythonQtWrapper")
  ENDIF()
ENDFOREACH()

# Check for non-existing ${var}
FOREACH(var OUTPUT_DIR QT_MOC_EXECUTABLE)
  IF(NOT EXISTS ${${var}})
    MESSAGE(SEND_ERROR "Failed to find ${var} when calling ctkScriptWrapPythonQt")
  ENDIF()
ENDFOREACH()

# Convert wrapping namespace to subdir
STRING(REPLACE "." "_" WRAPPING_NAMESPACE_UNDERSCORE ${WRAPPING_NAMESPACE})

# Convert ^^ separated string to list
STRING(REPLACE "^^" ";" MOC_FLAGS "${MOC_FLAGS}")

# Clear file where all moc'ified will be appended
FILE(WRITE ${WRAPPER_MASTER_MOC_FILE} "// 
// File auto-generated by cmake macro ctkScriptMocPythonQtWrapper\n//\n")

# Collect wrapper headers
set(glob_expression ${OUTPUT_DIR}/${WRAP_INT_DIR}${WRAPPING_NAMESPACE_UNDERSCORE}_${TARGET}*.h)
FILE(GLOB wrapper_headers RELATIVE ${OUTPUT_DIR}/${WRAP_INT_DIR} ${glob_expression})

IF(NOT wrapper_headers)
  MESSAGE(SEND_ERROR "ctkScriptMocPythonQtWrapper - Failed to glob wrapper headers using expression:[${glob_expression}]")
ENDIF()

# Moc'ified each one of them
FOREACH(header ${wrapper_headers})

  # what is the filename without the extension
  GET_FILENAME_COMPONENT(TMP_FILENAME ${header} NAME_WE)
  
  set(moc_options)
  set(wrapper_h_file ${OUTPUT_DIR}/${WRAP_INT_DIR}/${header})
  set(wrapper_moc_file ${OUTPUT_DIR}/${WRAP_INT_DIR}/moc_${header}.cpp)
  #message("wrapper_h_file: ${wrapper_h_file}")
  #message("wrapper_moc_file: ${wrapper_moc_file}")
  EXECUTE_PROCESS(
    COMMAND ${QT_MOC_EXECUTABLE} ${MOC_FLAGS} ${moc_options} -o ${wrapper_moc_file} ${wrapper_h_file}
    WORKING_DIRECTORY ${OUTPUT_DIR}
    RESULT_VARIABLE RESULT_VAR
    ERROR_VARIABLE error
    )
  IF(RESULT_VAR)
    MESSAGE(FATAL_ERROR "Failed to moc'ified .\n${RESULT_VAR}\n${error}")
  ENDIF()
  
  # Append generated moc file to the master file
  FILE(READ ${wrapper_moc_file} file_content)
  FILE(APPEND ${WRAPPER_MASTER_MOC_FILE} "${file_content}")

ENDFOREACH()

