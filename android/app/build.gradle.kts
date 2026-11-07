import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingPropertiesFile = rootProject.file("key.properties")
val signingProperties = Properties()
if (signingPropertiesFile.exists()) {
    signingPropertiesFile.inputStream().use(signingProperties::load)
} else if (gradle.startParameter.taskNames.any { it.contains("Release", ignoreCase = true) }) {
    throw GradleException(
        "Release signing is not configured. Create android/key.properties and provide a private upload keystore."
    )
}

android {
    namespace = "cz.minibrzda.efira"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "cz.minibrzda.efira"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://flutter.dev/to/review-gradle-config).
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (signingPropertiesFile.exists()) {
            create("release") {
                val storePath = signingProperties.getProperty("storeFile")
                    ?: throw GradleException("Missing storeFile in android/key.properties")
                storeFile = rootProject.file(storePath)
                storePassword = signingProperties.getProperty("storePassword")
                    ?: throw GradleException("Missing storePassword in android/key.properties")
                keyAlias = signingProperties.getProperty("keyAlias")
                    ?: throw GradleException("Missing keyAlias in android/key.properties")
                keyPassword = signingProperties.getProperty("keyPassword")
                    ?: throw GradleException("Missing keyPassword in android/key.properties")
            }
        }
    }

    buildTypes {
        release {
            if (signingPropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
