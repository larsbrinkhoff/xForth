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
    ./configure --enable-msp430
    make
    sudo make install
}

(install_lbforth)

case $TARGET in
    avr) sudo apt-get install simulavr;;
    msp430) (install_naken_asm);;
esac

