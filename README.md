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

## Sample .gitlab-ci.yml

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
  - lint
  - build
  - test

lint:
  stage: lint
  script:
    - ./gradlew lint
  artifacts:
    expire_in: 6 mos
    paths:
    - app/build/reports

build:
  stage: build
  script:
    - ./gradlew assembleDebug
  artifacts:
    expire_in: 6 mos
    paths:
    - app/build/outputs

test:
  stage: test
  script:
    - ./gradlew test
  artifacts:
    expire_in: 6 mos
    when: on_failure
    paths:
    - app/build/reports
```
