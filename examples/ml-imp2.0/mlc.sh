#!/bin/bash

K_ROOT_DIR=~/k-framework
ML_ROOT_DIR=${K_ROOT_DIR}/examples/ml-imp2.0
LANG_NAME=imp
LANG_SUFFIX=.c
LANG_MODULE=`echo ${LANG_NAME} | tr [:lower:] [:upper:]`

K_TOOLS_DIR=${K_ROOT_DIR}/tools
ANTLR_ROOT_DIR=${K_TOOLS_DIR}/antlr
LANG_PARSER_DIR=${ML_ROOT_DIR}/parser

KC=${K_TOOLS_DIR}/kcompile-program.sh
KFLAGS=

JVM=java
CLASSPATH=${ANTLR_ROOT_DIR}/antlrworks-1.4.jar:${ANTLR_ROOT_DIR}:${LANG_PARSER_DIR}
JFLAGS="-classpath ${CLASSPATH}"
UNWRAP_MAIN=unwrapBuiltinsMain
PARSER_MAIN=kernelCPreK

MAUDE=maude
MFLAGS=-no-banner

if [ ! "$1" ]; then
  echo "mlc: no input file"
  exit 1
fi
if [ ! -e $1 ]; then
  echo "$1: No such file or directory"
  exit 1
fi

PROG=`basename $1 ${LANG_SUFFIX} | tr [:upper:] [:lower:]`
PROG_DIR=`dirname $1`
PROG_MODULE=PROG
PROG_MACRO=prog
MAUDE_PROG=${PROG}.maude
COMPILED_PROG=prog-compiled.maude
ML_PROG=${PROG}-ml.maude

grep -v '^#include' $1 | ${JVM} ${JFLAGS} ${PARSER_MAIN} >${MAUDE_PROG}
if [ "$?" -ne 0 ]; then exit $?; fi

sed -i -e "1i load ${ML_ROOT_DIR}/${LANG_NAME}-syntax.maude" ${MAUDE_PROG}
sed -i -e "2i load ${ML_ROOT_DIR}/${LANG_NAME}-compiled.maude" ${MAUDE_PROG}

${KC} ${KFLAGS} ${MAUDE_PROG} ${LANG_MODULE} ${PROG_MODULE} ${PROG_MACRO} >/dev/null
if [ "$?" -ne 0 ]; then exit $?; fi

${JVM} ${JFLAGS} ${UNWRAP_MAIN} <${COMPILED_PROG} >${ML_PROG}
if [ "$?" -ne 0 ]; then exit $?; fi

sed -i -e "1i load ${K_ROOT_DIR}/k-prelude.maude" ${ML_PROG}
sed -i -e "2c load ${ML_ROOT_DIR}/ml-${LANG_NAME}.maude" ${ML_PROG}
sed -i -e "3i load ${ML_ROOT_DIR}/fol.maude" ${ML_PROG}
echo -e "mod TEST is inc ${LANG_MODULE}-${PROG_MACRO} + FOL= . endm" >>${ML_PROG}
echo -e "rew check('prog) ." >>${ML_PROG}
echo -e "q" >>${ML_PROG}

${MAUDE} ${MFLAGS} ${ML_PROG} 2>/dev/null | sed '1,2d' | sed '$d' 
if [ "$?" -ne 0 ]; then exit $?; fi

rm ${MAUDE_PROG} ${COMPILED_PROG} ${ML_PROG}
