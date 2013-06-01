#!/bin/sh

set -e

# http://mywiki.wooledge.org/BashFAQ/035
# (POSIX shell syntax)

# Reset all variables that might be set
file=""
verbose=0

while :
do
    case $1 in
        -h | --help | -\?)
            #  Call your Help() or usage() function here.
            exit 0      # This is not an error, User asked help. Don't do "exit 1"
            ;;
        -f | --file)
            file=$2     # You might want to check if you really got FILE
            shift 2
            ;;
        --file=*)
            file=${1#*=}        # Delete everything up till "="
            shift
            ;;
        -ctv | --ini-parser-version=* | --config-tiny-version=*)
	    perl_config_tiny_version=${1#*=} # Delete everything up till "="
            shift
            ;;
        -v | --verbose)
            # Each instance of -v adds 1 to verbosity
            verbose=$((verbose+1))
            shift
            ;;
        --) # End of all options
            shift
            break
            ;;
        -*)
            echo "WARN: Unknown option (ignored): $1" >&2
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;
    esac
done

# Suppose some options are required. Check that we got them.

if test $verbose -gt 0
then
    set -o xtrace
fi

if [ ! "$perl_config_tiny_version" ]; then
    echo "ERROR: option '--ini-parser-version VERSION' not given. See --help" >&2
    exit 1
fi


preexisting_perl_config_tiny_version=$(grep -E 'preexisting_perl_config_tiny_version *=' VERSION.mk | cut -d= -f2 | tr -d '[[:space:]]')
if test $perl_config_tiny_version = $preexisting_perl_config_tiny_version
then
    exit 0
else
    perl -p -i -e "s{preexisting_perl_config_tiny_version\s*=\s*.*}{preexisting_perl_config_tiny_version=$perl_config_tiny_version}" VERSION.mk
fi



tiny_perl_version=2.0-580

7z l tinyperl-$tiny_perl_version-win32.zip >before_modification.list

wget --no-clobber --output-file wget_out.txt --no-verbose http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/Config-Tiny-$perl_config_tiny_version.tar.gz
tar xzf Config-Tiny-$perl_config_tiny_version.tar.gz
mkdir -p lib
cp -R Config-Tiny-$perl_config_tiny_version/lib/Config lib
7z a lib.zip lib >/dev/null

mkdir -p tinyperl-$tiny_perl_version-win32
cp lib.zip tinyperl-$tiny_perl_version-win32
7z u tinyperl-$tiny_perl_version-win32.zip tinyperl-$tiny_perl_version-win32 >/dev/null

7z l tinyperl-$tiny_perl_version-win32.zip >after_modification.list

set +errexit
diff -uw before_modification.list after_modification.list >diff_modification.list
set -errexit
