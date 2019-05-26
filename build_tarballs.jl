# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "nasmBuilder"
version = v"2.14.02"

# Collection of sources required to build x264Builder
sources = [
    "http://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.xz" =>
    "e24ade3e928f7253aa8c14aa44726d1edf3f98643f87c9d72ec1df44b26be8f5",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/nasm-2.14.02/
./configure --prefix=$prefix --host=$target
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "nasm", :nasm)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

