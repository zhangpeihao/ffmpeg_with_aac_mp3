#! /bin/sh

#=============================================================
# Log functions
export LOG_FILE=$(pwd)/build.log
function if_error
{
    if [ $1 -ne 0 ]
    then
        echo -e "\033[31mfailed!error code:$1\033[0m"
        echo "failed!error code:$1
" >> $LOG_FILE
        exit $1
    else
        echo -e "\033[32msuccess!\033[0m"
    fi
}
function dump
{
    echo -e "\033[44m$1\033[0m"
    echo -n "$1
" >> $LOG_FILE
}
doSed()
{
        if [ "x$(uname)" == "xDarwin" ]
        then
                sed -i "" $@
        else
                sed -i $@
        fi
}

#==============================================================

LIBAACPLUS_URL="http://ffmpeg.gusari.org/uploads/libaacplus-2.0.2.tar.gz"
YASM_URL="http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz"
LAME_URL="http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"
FFMPEG_URL="http://ffmpeg.org/releases/ffmpeg-2.0.1.tar.gz"

dump "Install build tools"
yum -y install autoconf automake libtool
if_error $?

dump "Download yasm source code"
wget ${YASM_URL}
if_error $?

tar zxvf ./yasm-1.2.0.tar.gz
if_error $?

cd yasm-1.2.0
if_error $?

dump "Build yasm"
./configure --prefix=/usr --enable-shared --enable-static
if_error $?
make -j 4
if_error $?
make install
if_error $?
cd ..

dump "Download libaacplus source code"
wget --output-document=libaacplus.tar.gz ${LIBAACPLUS_URL} 
if_error $?

dump "Decomression libaacplus source code package"
tar zxvf ./libaacplus.tar.gz
if_error $?
cd ./libaacplus-2.0.2
if_error $?

dump "Build libaacplus"
./autogen.sh --prefix=/usr --enable-shared --enable-static
./autogen.sh --prefix=/usr --enable-shared --enable-static
if_error $?
dump "Begin make"
make
if_error $?
make install
if_error $?
cd ..

dump "Download lame source code"
wget ${LAME_URL}
if_error $?
tar zxvf ./lame-3.99.5.tar.gz
if_error $?
cd lame-3.99.5
if_error $?
dump "Build lame"
./configure --prefix=/usr --enable-shared --enable-static
if_error $?
make -j 4
if_error $?
make install
if_error $?

dump "ldconfig"
ldconfig
if_error $?

dump "Download ffmpeg source code"
wget ${FFMPEG_URL}
if_error $?
tar zxvf ./ffmpeg-2.0.1.tar.gz
if_error $?
cd ffmpeg-2.0.1
if_error $?
./configure --enable-static --disable-shared --enable-gpl  --enable-libmp3lame --enable-nonfree --enable-libaacplus
if_error $?
make -j 4
if_error $?
make install
if_error $?

ldconfig
if_error $?

ffmpeg -h
if_error $?
dump "Install ffmpeg success"


