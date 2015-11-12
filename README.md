NAMICExternalProjects
=====================
A superbuild infrastructure to build all superbuild structures

    Ash nazg durbatulûk, 
    ash nazg gimbatul,
    Ash nazg thrakatulûk 
    agh burzum-ishi krimpatul.
                    - Sauron, the Abhorred

This project acts as a template to model building all other SuperBuild projects around.
* * *
### Directory layout
__NAMICExternalProjects/__

* __CMakeLists.txt__

    A file that acts as a top level switch, it runs the building of pre-requisite ExternalProjects defined in SuperBuild.cmake (where ${MyProject} is last ExternalProject to be built).  **_This file is processed by CMake 2 times_**: the first time processes SuperBuild.cmake and the second time processes ${MyProject}.cmake

* __Common.cmake__

    Included in SuperBuild.cmake and ${MYProject}.cmake for common conditional compilation options to be set.  These options must be passed to all ExternalProjects (including ${MYProject})

* __SuperBuild.cmake__

    Infrastructure to build all the pre-requisite packages where ${MYProject} is the last one listed

* __${MYProject}.cmake__

    Standard cmake build instructions for ${MYProject}

* __SuperBuild/__

    A directory full of External_${extProjName}.cmake files defining how to build external dependencies.

* __CMake/__

    A directory of support files.
    
### Build Instruction
1. Install Anaconda Python Environment: https://www.continuum.io/downloads
   ```bash
   $ ${conda_dir}/conda create --name namicAnacondaEnv python
   ```
2. Install SimpleITK Against above Anaconda Python Environment: http://www.itk.org/Wiki/SimpleITK/GettingStarted
   ```bash
   $ ${conda_dir}/conda install -c https://conda.binstar.org/simpleitk SimpleITK
   ```
3. Install NiPype against above Anaconda Python Environment: http://nipy.org/nipype/users/install.html
   ```bash
   $ ${conda_dir}/conda install pip
   $ ${conda_dir}/pip install nipype
   ```
4. Build Namic against all above:
  ```bash
  $ git clone https://github.com/BRAINSia/NAMICExternalProjects.git
  $ mkdir ${build_dir_name}
  $ cd ${build_dir_name}
  $ ccmake ../NAMICExternalProjects
  $ make
  ```
