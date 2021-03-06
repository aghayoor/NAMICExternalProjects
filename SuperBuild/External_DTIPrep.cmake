
set(proj DTIPrep) #The find_package known name


# Set dependency list
set(${proj}_DEPENDENCIES DCMTK ITKv4 SlicerExecutionModel VTK BRAINSTools ANTs)

ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

# Set CMake OSX variable to pass down the external project
set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if(APPLE)
  list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
    -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET})
endif()

set(BRAINSCommonLibWithANTs_OPTIONS
  -DUSE_ANTS:BOOL=${USE_ANTs}
  -DUSE_ANTs:BOOL=${USE_ANTs}
  )

if(USE_ANTs)
  list(APPEND BRAINSCommonLibWithANTs_OPTIONS
    -DUSE_SYSTEM_ANTs:BOOL=ON
    -DANTs_SOURCE_DIR:PATH=${ANTs_SOURCE_DIR}
    -DANTs_LIBRARY_DIR:PATH=${ANTs_LIBRARY_DIR}
    -DUSE_SYSTEM_Boost:BOOL=ON
    -DBoost_NO_BOOST_CMAKE:BOOL=ON #Set Boost_NO_BOOST_CMAKE to ON to disable the search for boost-cmake
    -DBoost_DIR:PATH=${BOOST_ROOT}
    -DBOOST_ROOT:PATH=${BOOST_ROOT}
    -DBOOST_INCLUDE_DIR:PATH=${BOOST_INCLUDE_DIR}
    -DDTIPrepTools_SUPERBUILD:STRING=OFF
    )
endif()

### --- Project specific additions here
set(${proj}_CMAKE_OPTIONS
  -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/${proj}-install
  -DKWSYS_USE_MD5:BOOL=ON # Required by SlicerExecutionModel
  -DUSE_SYSTEM_ITK:BOOL=ON
  -DUSE_SYSTEM_VTK:BOOL=ON
  -DUSE_SYSTEM_DCMTK:BOOL=ON
  -DUSE_SYSTEM_SlicerExecutionModel:BOOL=ON
  -DITK_DIR:PATH=${ITK_DIR}
  -DVTK_DIR:PATH=${VTK_DIR}
  -DDCMTK_DIR:PATH=${DCMTK_DIR}
  -DGenerateCLP_DIR:PATH=${GenerateCLP_DIR}
  -DSlicerExecutionModel_DIR:PATH=${SlicerExecutionModel_DIR}
  -DBRAINSCommonLib_DIR:PATH=${BRAINSCommonLib_DIR}
  -D${proj}_USE_QT:BOOL=${LOCAL_PROJECT_NAME}_USE_QT
  -DDTIPrepTools_SUPERBUILD:STRING=OFF
  -DBRAINSTools_SOURCE_DIR:PATH=${BRAINSTools_SOURCE_DIR}
  ${BRAINSCommonLibWithANTs_OPTIONS}
  )

### --- End Project specific additions
set(${proj}_REPOSITORY https://www.nitrc.org/svn/dtiprep/trunk)
ExternalProject_Add(${proj}
  SVN_REPOSITORY ${${proj}_REPOSITORY}
  SVN_REVISION -r "293"
  SVN_USERNAME slicerbot
  SVN_PASSWORD slicer
  SOURCE_DIR ${SOURCE_DOWNLOAD_CACHE}/${proj}
  BINARY_DIR ${proj}-build
  INSTALL_COMMAND ""
  LOG_CONFIGURE 0  # Wrap configure in script to ignore log output from dashboards
  LOG_BUILD     0  # Wrap build in script to to ignore log output from dashboards
  LOG_TEST      0  # Wrap test in script to to ignore log output from dashboards
  LOG_INSTALL   0  # Wrap install in script to to ignore log output from dashboards
  ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS -Wno-dev --no-warn-unused-cli
  CMAKE_CACHE_ARGS
  ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
  ${COMMON_EXTERNAL_PROJECT_ARGS}
  ${${proj}_CMAKE_OPTIONS}
  ## We really do want to install in order to limit # of include paths INSTALL_COMMAND ""
  DEPENDS
  ${${proj}_DEPENDENCIES}
  )
set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

mark_as_superbuild(
  VARS ${proj}_DIR:PATH
  LABELS "FIND_PACKAGE"
)
