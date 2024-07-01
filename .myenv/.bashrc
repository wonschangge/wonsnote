################### my alias
alias ll="ls -al"

################### my PATH
export PATH="/usr/sbin:${PATH}"
# cross compile
export PATH="/opt/aarch64-linux-musl-cross/bin:${PATH}"
# crosstool-ng
export PATH="${HOME}/WORK/crosstool-ng/crosstool-ng-1.26.0/bin:${PATH}"
# flutter
export PATH="${HOME}/Software/flutter_linux_3.22.2-stable/flutter/bin:${PATH}"

################### rust
. "$HOME/.cargo/env"


################### android studio
# android sdk
export PATH="${HOME}/Android/Sdk/tools/bin":$PATH
export ANDROID_HOME=${HOME}/Android/Sdk
# capacitor
export CAPACITOR_ANDROID_STUDIO_PATH=${HOME}/Software/android-studio-2023.3.1.18-linux/android-studio/bin/studio.sh
