# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /
COPY pubspec.* ./
RUN dart pub get

# Copy  source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get
RUN dart compile exe bin/main_development.dart -o bin/main_development

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /bin/main_development /bin/

# Start server.
EXPOSE 8080
CMD ["/bin/server"]