curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
git clone --depth 1 --branch 2022-03-07 https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server
echo -e "# add path for rust binaries and the rust toolchain installer\nexport PATH=\"$HOME/.cargo/bin:$PATH\"\nexport PATH=\"$HOME/.rustup/:$PATH\""
