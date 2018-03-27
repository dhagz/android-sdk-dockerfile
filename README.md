# Android SDK Dockerfile

Update the following part of code to download specific Android SDK and/or Gradle version.

Docker Hub Link: https://hub.docker.com/r/fdhagz/android-sdk/

## Environment Variables

```
ENV ANDROID_HOME="/android/sdk" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_COMPILE_SDK_VERSION="27" \
    ANDROID_BUILD_TOOLS_VERSION="27.0.3" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-4.4-all.zip" \
    GRADLE_HOME="/android/gradle-4.4" \
    USER_HOME="/android"
```

- `ANDROID_SDK_URL`
  - You can find this at the Linux platform here: https://developer.android.com/studio/index.html#command-tools
- `GRADLE_URL`
  - Open `gradle-wrapper.properties` in you project and look up to the value of `distributionUrl`.
- `GRADLE_HOME`
  - When you download the file from `GRADLE_URL`, inside is a folder and the folder name  is the ones that come after the `/android`.


## Sample GitLab CI .gitlab-ci.yml

```
image: fdhagz/android-sdk:v27.1.0

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
