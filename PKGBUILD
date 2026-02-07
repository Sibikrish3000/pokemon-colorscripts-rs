# Maintainer: Sibi Krishnamoorthy <your-email@example.com>
pkgname=pokemon-colorscripts-rs-git
_pkgname=pokemon-rs
pkgver=r1.a1b2c3d
pkgrel=1
pkgdesc="Ultra-fast Rust CLI utility that prints unicode sprites of pokemon (embedded assets)"
arch=('x86_64' 'aarch64')
url="https://github.com/Sibikrish3000/pokemon-colorscripts-rs.git"
license=('MIT')
depends=('gcc-libs')
makedepends=('git' 'cargo')
source=("$_pkgname::git+$url")
md5sums=('SKIP')

pkgver(){
    cd "$_pkgname"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "$_pkgname"
    # Enable LTO and optimizations for Absolute Mode speed
    export CARGO_PROFILE_RELEASE_LTO=true
    export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
    export CARGO_PROFILE_RELEASE_PANIC=abort
    cargo build --release --locked
}

package() {
    cd "$_pkgname"

    # 1. Install the binary
    install -Dm755 "target/release/pokemon-rs" "$pkgdir/usr/bin/pokemon-rs"

    # 2. Install documentation and license
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    [[ -f README.md ]] && install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"

    # Optional: Create a symlink for the old name if you want compatibility
    ln -sf "/usr/bin/pokemon-rs" "$pkgdir/usr/bin/pokemon-rs"
}
