# Android SDK Dockerfile

Update the following part of code to download specific Android SDK and/or Gradle version.

```
# Environment Variables
ENV ANDROID_HOME="/android/sdk" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
	ANDROID_COMPILE_SDK_VERSION="26" \
	GRADLE_URL="https://services.gradle.org/distributions/gradle-4.1-all.zip" \
	GRADLE_HOME="/android/gradle"
```
