FROM openjdk:8-jdk

MAINTAINER Dhagz <dhagz@walng.com>

# Environment Variables
ENV ANDROID_HOME="/android/sdk" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_COMPILE_SDK_VERSION="27" \
    ANDROID_BUILD_TOOLS_VERSION="27.0.3" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-4.4-all.zip" \
    GRADLE_HOME="/android/gradle-4.4" \
    USER_HOME="/android"
	
# Work directory
WORKDIR $USER_HOME

# Download and Install Android SDK
RUN wget --quiet --output-document=/tmp/sdk-tools-linux.zip $ANDROID_SDK_URL \
 && unzip /tmp/sdk-tools-linux.zip -d "$ANDROID_HOME" \
 && rm /tmp/sdk-tools-linux.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Download and Install Platform SDK
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK_VERSION"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools"

# Download and Install Gradle
RUN wget --quiet --output-document=/tmp/gradle.zip $GRADLE_URL \
 && unzip /tmp/gradle.zip -d "$USER_HOME" \
 && rm /tmp/gradle.zip

# Update PATH
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin
