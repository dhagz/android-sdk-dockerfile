FROM ubuntu

MAINTAINER Dhagz <dhagz@walng.com>


# Environment Variables
ENV ANDROID_HOME="/android/sdk" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_COMPILE_SDK_VERSION="27" \
    ANDROID_BUILD_TOOLS_VERSION="27.0.3" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-4.1-all.zip" \
    GRADLE_HOME="/android/gradle-4.1" \
    USER_HOME="/android"
	
# Work directory
WORKDIR $USER_HOME

# Download and Install Dependencies
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y --no-install-recommends openjdk-8-jdk 
#libgd2-xpm ia32-libs ia32-libs-multiarch
RUN apt-get clean

#ENV JAVA_HOME /usr/lib/jvm/open-jdk

# Download and Install Android SDK
RUN wget --quiet --output-document=/tmp/sdk-tools-linux.zip $ANDROID_SDK_URL \
 && unzip /tmp/sdk-tools-linux.zip -d "$ANDROID_HOME" \
 && rm /tmp/sdk-tools-linux.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Update PATH to add Android tools and platform-tools
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Fix for Warning: File /home/xxxx/.android/repositories.cfg could not be loaded.
# Source: https://askubuntu.com/questions/885658/android-sdk-repositories-cfg-could-not-be-loaded
RUN touch ~/.android/repositories.cfg

# Download and Install Platform SDK
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK_VERSION"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "system-images;android-$ANDROID_COMPILE_SDK_VERSION;google_apis_playstore;x86"

# Create Android Virtual Device
RUN $ANDROID_HOME/tools/bin/avdmanager list target -c
RUN echo no | $ANDROID_HOME/tools/bin/avdmanager create avd --force --name android_emu --abi google_apis_playstore/x86 --package "system-images;android-$ANDROID_COMPILE_SDK_VERSION;google_apis_playstore;x86"

# Download and Install Gradle
RUN wget --quiet --output-document=/tmp/gradle.zip $GRADLE_URL \
 && unzip /tmp/gradle.zip -d "$USER_HOME" \
 && rm /tmp/gradle.zip

# Update PATH to add .gradle
ENV PATH=${PATH}:${GRADLE_HOME}/bin
