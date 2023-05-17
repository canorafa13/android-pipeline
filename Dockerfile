FROM androidsdk/android-31:latest as build


RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install jq -y
RUN apt-get install gawk -y

#RUN apt install nodejs npm -y
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install nodejs -y


RUN node -v
RUN npm -v
RUN echo 'Installing App Center CLI tools'
RUN npm init -yes
RUN npm install -g appcenter-cli

#Copy project
WORKDIR /app
COPY . /app/



RUN yes | /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --licenses
RUN yes | /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager \
    "build-tools;33.0.0" \
    "sources;android-33"



# Gradle PPA => Mejorar la forma de establecer la versión del gradle
ENV GRADLE_VERSION=7.4
ENV PATH ${PATH}:/opt/gradle/gradle-7.4/bin/


RUN if [[! -d "/opt/gradle/gradle-7.4/bin/" ]]; \
    then \
        wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
            && unzip -d /opt/gradle /tmp/gradle-*.zip \
            && chmod +775 /opt/gradle \
            && gradle --version \
            && rm -rf /tmp/gradle* ; \
    fi




    #ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64


# Cleaning
#RUN apt-get clean


# Limpia el build
#RUN ./gradlew clean

# Construye una versión especifica
#RUN ./gradlew app:assembleQaDebug



# App Center
ENV APP_CENTER_OWNER_NAME="cano-martinez13-hotmail.com"
ENV APP_NAME="AndroidPipeline"
ENV APP_CENTER_API_TOKEN="b4ad27d4f8f142990a6ec7ff069661ec18f423bf"
ENV APP_CENTER_DISTRIBUTION_GROUP="Test"
ENV APP_BUILD_TYPE="debug"
ENV APK_NAME='/app/app/build/outputs/apk/$APP_BUILD_TYPE/app-$BUILD_TYPE.apk'

RUN echo "Publishing $APK_NAME to App Center"

#RUN appcenter distribute release \
#    --debug \
#    --group $APP_CENTER_DISTRIBUTION_GROUP \
#    --file $APK_NAME \
 #   --release-notes 'App Android Pipeline via Jenkins' \
  #  --app $APP_CENTER_OWNER_NAME'/'$APP_NAME \
   # --token $APP_CENTER_API_TOKEN \
    #--quiet
