install_lbforth() {
    cd lbForth
    export M32=-m32
    sh -e test/install-deps.sh install_${TRAVIS_OS_NAME:-linux}
    make all TARGET=x86 OS=linux
    sudo make install TARGET=x86 OS=linux
}

install_naken_asm() {
    git clone https://github.com/mikeakohn/naken_asm
    cd naken_asm
    ./configure
    make
    sudo make install
}

install_ucsim() {
    sudo apt-get install subversion
    svn checkout svn://svn.code.sf.net/p/sdcc/code/trunk/sdcc sdcc
    cd sdcc/sim/ucsim
    ./configure
    make
    sudo make install
}

(install_lbforth)

case $TARGET in
    6502) (install_naken_asm);;
    8051) (install_ucsim);;
    avr) sudo apt-get install simulavr;;
    msp430) (install_naken_asm);;
    pdp8) sudo apt-get install simh;;
    pic) sudo apt-get install gpsim;;
    stm8) (install_ucsim);;
esac

