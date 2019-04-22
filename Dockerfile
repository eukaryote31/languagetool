FROM maven:3.5.3-jdk-8-slim

RUN mkdir /languagetool
WORKDIR /languagetool
COPY . /languagetool

RUN mvn clean

RUN ./build.sh languagetool-standalone package -DskipTests


FROM openjdk:8-jre
EXPOSE 8081

RUN mkdir /app
WORKDIR /app

COPY --from=0 /languagetool/languagetool-standalone/target/LanguageTool-4.6-SNAPSHOT/LanguageTool-4.6-SNAPSHOT/ /app

CMD java -cp languagetool-server.jar org.languagetool.server.HTTPServer --port 8081 --public
