###############################
#         PATH config         #
###############################
# add path for brew binaries
export PATH="/opt/homebrew/bin"
# add path for maven
export PATH="/usr/local/apache-maven-3.8.1/bin/:$PATH"
# set java home directory
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_331.jdk/Contents/Home"
# for jupyter and other python bins
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
# add path for rust binaries and the rust toolchain installer
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/:$PATH"
# add path for flutter
export PATH="$HOME/Library/flutter/bin:$PATH"
# add path for android SDK
export PATH="$HOME/Library/Android/sdk/tools/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/tools:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
# configuring pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
