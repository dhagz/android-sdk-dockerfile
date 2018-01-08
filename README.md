# Android SDK Dockerfile

Update the following part of code to download specific Android SDK and/or Gradle version.

Docker Hub Link: https://hub.docker.com/r/fdhagz/android-sdk/

```
# Environment Variables
ENV ANDROID_HOME="/android/sdk" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
	ANDROID_COMPILE_SDK_VERSION="26" \
	ANDROID_BUILD_TOOLS_VERSION="26.0.2" \
	GRADLE_URL="https://services.gradle.org/distributions/gradle-4.1-all.zip" \
	GRADLE_HOME="/android/gradle-4.1" \
	USER_HOME="/android"
```

# .gitlab-ci.yml

```
image: fdhagz/android-sdk:v26

variables:
  GIT_SSL_NO_VERIFY: "true"

before_script:
  - export GRADLE_USER_HOME=`pwd`/.gradle
  - mkdir -p $GRADLE_USER_HOME
  - chmod +x ./gradlew

cache:
  paths:
    - .gradle/wrapper
    - .gradle/caches

stages:
  - build
  - test

build:
  stage: build
  script:
    - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs
    - app/build/reports

test:
  stage: test
  script:
    - ./gradlew test
```
