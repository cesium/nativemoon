cd android && ENVFILE=.env ./gradlew assembleRelease && cd ..
mv android/app/build/outputs/apk/release/app-release.apk seium.apk
