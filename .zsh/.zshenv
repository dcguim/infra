############################################
#      Utility env vars & PATH config      #
############################################
export PATH="$HOME/.local/bin:$PATH"
# set java home directory
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_331.jdk/Contents/Home"
export LANGCHAIN_TRACING_V2=true
# native compilation support for emacs (libgccjit needs linker paths)
export LIBRARY_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib:/opt/homebrew/lib/gcc/current"
# add path for brew binaries
export PATH="/opt/homebrew/bin/:$PATH"
# add path for maven
export PATH="/usr/local/apache-maven-3.8.1/bin/:$PATH"

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
#for jupyter and other python bins
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
# add path for rust binaries and the rust toolchain installer
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/:$PATH"
# gitlab creentials
# add path for flutter
export PATH="$HOME/Library/flutter/bin:$PATH"
# add path for android SDK
export PATH="$HOME/Library/Android/sdk/tools/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/tools:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
# Claude Code: auto-connect to Monet (Emacs IDE bridge) when running
export ENABLE_IDE_INTEGRATION=t

# configuring pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
