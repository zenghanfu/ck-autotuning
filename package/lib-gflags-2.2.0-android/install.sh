#! /bin/bash

#
# Installation script for clBLAS.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}

############################################################
echo ""
echo "Cloning package from '${PACKAGE_URL}' ..."

rm -rf src

git clone ${PACKAGE_URL} src

if [ "${?}" != "0" ] ; then
  echo "Error: cloning package failed!"
  exit 1
fi

############################################################
echo ""
echo "Checking out v2.2.0 ..."
cd src
git checkout v2.2.0

if [ "${?}" != "0" ] ; then
  echo "Error: cloning package failed!"
  exit 1
fi

############################################################
echo ""
echo "Cleaning ..."

cd ${INSTALL_DIR}

rm -f ${PACKAGE_FILE1}

rm -rf install

rm -rf obj
mkdir obj
cd obj

############################################################
echo ""
echo "Executing cmake ..."

cmake -DCMAKE_BUILD_TYPE=${CK_ENV_CMAKE_BUILD_TYPE:-Release} \
      -DCMAKE_C_COMPILER="${CK_CC_PATH_FOR_CMAKE}" \
      -DCMAKE_C_FLAGS="${CK_CC_FLAGS_FOR_CMAKE} ${CK_CC_FLAGS_ANDROID_TYPICAL}" \
      -DCMAKE_CXX_COMPILER="${CK_CXX_PATH_FOR_CMAKE}" \
      -DCMAKE_CXX_FLAGS="${CK_CXX_FLAGS_FOR_CMAKE} ${CK_CXX_FLAGS_ANDROID_TYPICAL}" \
      -DCMAKE_AR="${CK_AR_PATH_FOR_CMAKE}" \
      -DCMAKE_LINKER="${CK_LD_PATH_FOR_CMAKE}" \
      -DCMAKE_EXE_LINKER_FLAGS="${CK_LINKER_FLAGS_ANDROID_TYPICAL}" \
      -DCMAKE_EXE_LINKER_LIBS="${CK_LINKER_LIBS_ANDROID_TYPICAL}" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/install" \
      ../src

if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

############################################################
echo ""
echo "Building package ..."

#make VERBOSE=1 -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS}
make -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS}
if [ "${?}" != "0" ] ; then
  echo "Error: build failed!"
  exit 1
fi

############################################################
echo ""
echo "Installing package ..."

make install
if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

exit 0