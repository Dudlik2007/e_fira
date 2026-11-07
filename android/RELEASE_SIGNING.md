# Android release signing

Release builds require a private upload keystore. Keep the keystore and
`key.properties` outside version control and back them up securely.

From the repository root, create a keystore locally. The command prompts for
passwords; choose and store them securely rather than putting them in shell
history:

```sh
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create `android/key.properties` on your machine with the values for that
keystore:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

Replace the example values locally. Do not commit or share this file or the
keystore. Both paths are ignored by Git. Gradle stops release builds when the
properties file is missing or required values are absent. Debug builds do not
need this signing setup.

For Google Play distribution, use the keystore and credentials associated with
the app's existing Play Console upload key. If that key is unavailable, follow
Google Play Console's upload-key reset process; do not replace the app's signing
identity or create a Firebase project migration.
