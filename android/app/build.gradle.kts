plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
    namespace = "com.example.task_management"

=======
    namespace = "com.example.taskmanagement"
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
<<<<<<< HEAD
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }


    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.task_management"

=======
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.taskmanagement"
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

<<<<<<< HEAD
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
=======
    signingConfigs {
        create("release") {
            storeFile = file("release-key.jks")
            storePassword = "taskmanagement123"
            keyAlias = "release"
            keyPassword = "taskmanagement123"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
}

flutter {
    source = "../.."
}
<<<<<<< HEAD
=======

// Fix for Isar library resource verification issues in release builds
// This disables the problematic verifyReleaseResources task for isar_flutter_libs
gradle.projectsEvaluated {
    rootProject.allprojects.forEach { project ->
        if (project.name == "isar_flutter_libs") {
            project.tasks.withType<com.android.build.gradle.tasks.VerifyLibraryResourcesTask>().configureEach {
                enabled = false
            }
        }
    }
}

// Fix for Kotlin daemon issues with incremental compilation
tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    kotlinOptions {
        jvmTarget = "11"
        // Disable incremental compilation to avoid path issues
        incremental = false
    }
}
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
