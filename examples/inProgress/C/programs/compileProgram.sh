#!/bin/bash
# CIL_FLAGS="--noWrap --decil --noPrintLn --warnall --strictcheck --nokeepunused --envmachine"
set -o errexit
PEDANTRY_OPTIONS="-Wall -Wextra -Werror -Wmissing-prototypes -pedantic -x c -std=c99"
GCC_OPTIONS="-std=c99 -nostdlib -nodefaultlibs -U __GNUC__"
myDirectory=`dirname "$0"`

function die {
	cleanup
	echo "Something went wrong in compileProgram.sh"
	echo "$1" >&2
	exit $2
}
function cleanup {
	rm -f $compilationLog
}

#echo "Checking readlink version..."
set +o errexit
READLINK=`which greadlink 2> /dev/null`
if [ "$?" -ne 0 ]; then
	#echo "You don't have greadlink.  I'll look for readlink."
	READLINK=`which readlink 2> /dev/null`
	if [ "$?" -ne 0 ]; then
		die "No readlink/greadlink program found.  Cannot continue." 9
	fi
fi
set -o errexit
#echo $READLINK
K_MAUDE_BASE=`$READLINK -f $myDirectory/../../../..`
#K_PROGRAM_COMPILE="$K_MAUDE_BASE/tools/kcompile-program.sh"
K_PROGRAM_COMPILE="perl $myDirectory/xmlToK.pl"

set -o nounset
#trap cleanup SIGHUP SIGINT SIGTERM
username=`id -un`
compilationLog=`mktemp -t $username-fsl-c-log.XXXXXXXXXXX`
dflag=
nowarn=0
usage="Usage: %s: [-d] inputFileName\n"

while getopts 'dw' OPTION
do
	case $OPTION in
	d)	dflag=1
		;;
	w)	nowarn=1
		;;
	?)	die "`printf \"$usage\" $(basename $0)`" 2
		;;
  esac
done
shift $(($OPTIND - 1))

if [ ! "$1" ]; then
	die "filename expected" 3
fi
filename=`basename "$1" .c`
escapedFilename=`echo -n $filename | tr "_" "-"`
directoryname=`dirname "$1"`/
if [ ! -e $directoryname$filename.c ]; then
	die "$filename.c not found" 4
fi

# this instead of above
cp $directoryname$filename.c $filename.prepre.gen

set +o errexit
gcc $PEDANTRY_OPTIONS $GCC_OPTIONS -E -iquote "." -iquote "$directoryname" -I "$myDirectory/includes" $filename.prepre.gen > $filename.pre.gen 2> $filename.warnings.log
if [ "$?" -ne 0 ]; then 
	die "Error running preprocessor: `cat $filename.warnings.log`" 6
fi
set -o errexit
if [ ! "$nowarn" ]; then
	cat $filename.warnings.log >&2
fi
#echo "done with gcc"
if [ ! "$dflag" ]; then
	rm -f $filename.prepre.gen
fi
set +o errexit
$myDirectory/cparser --xml $filename.pre.gen 2> $filename.warnings.log 1> $filename.gen.xml.tmp 
if [ "$?" -ne 0 ]; then 
	rm -f $filename.gen.xml.tmp
	msg="Error running C parser: `cat $filename.warnings.log`"
	rm -f $filename.warnings.log
	die "$msg" 7
fi
set -o errexit
if [ ! "$nowarn" ]; then
	cat $filename.warnings.log >&2
fi
if [ ! "$dflag" ]; then
	rm -f $filename.warnings.log
	rm -f $filename.pre.gen
fi
mv $filename.gen.xml.tmp $filename.gen.xml

# modelCheck=
# set +o errexit
# grep -q 'START MODEL-CHECKING' "$directoryname$filename.c"
# retval="$?"
# if [ "$retval" -eq 0 ]; then 
	# modelCheck=1
# fi
# set -o errexit

# echo "load $myDirectory/c-total" > program-$filename-gen.maude
# echo "mod C-PROGRAM is" >> program-$filename-gen.maude
# echo "including C-SYNTAX ." >> program-$filename-gen.maude
# echo "including MATCH-C-SYNTAX ." >> program-$filename-gen.maude
# echo "including COMMON-C-CONFIGURATION ." >> program-$filename-gen.maude
# cat $filename.gen.maude >> program-$filename-gen.maude
# if [ $modelCheck ]; then
	# startModel=`grep -n "START MODEL-CHECKING" $directoryname$filename.c | sed 's/^\([0-9]*\):.*$/\1/'`
	# #echo $startModel
	# startModel=$(($startModel + 1))
	# endModel=`grep -n "END MODEL-CHECKING" $directoryname$filename.c | sed 's/^\([0-9]*\):.*$/\1/'`
	# #echo $endModel
	# endModel=$(($endModel - 1))
	# #echo "start = $startModel"
	# #echo "end = $endModel"
	# modelModule=`sed -n $startModel,${endModel}p $directoryname$filename.c`
	# echo -e "$modelModule" >> program-$filename-gen.maude
# fi
# if [ ! "$dflag" ]; then
	# rm -f $filename.gen.maude
# fi
# echo -e "endm\n" >> program-$filename-gen.maude

set +o errexit
# $K_PROGRAM_COMPILE program-$filename-gen.maude C C-PROGRAM program-$escapedFilename > $compilationLog
cat $filename.gen.xml | $K_PROGRAM_COMPILE 2> $compilationLog 1> program-$filename-compiled.maude
PROGRAMRET=$?
set -o errexit
if [ "$PROGRAMRET" -ne 0 ]; then
	msg="Error compiling program: `cat $compilationLog`"
	rm -f $compilationLog
	die "$msg" 8
fi
# if [ "$escapedFilename" != "$filename" ]; then 
	# mv program-$escapedFilename-compiled.maude program-$filename-compiled.maude
# fi

sed -e '1 d' program-$filename-compiled.maude > program-$filename-compiled.maude.tmp
mv program-$filename-compiled.maude.tmp program-$filename-compiled.maude

rm -f program-$filename-compiled.maude.tmp
cleanup
