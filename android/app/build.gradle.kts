import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.bloconarua.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "br.com.bloconarua.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystoreProps = Properties()
            val keyPropsFile = rootProject.file("key.properties")
            if (keyPropsFile.exists()) {
                keystoreProps.load(keyPropsFile.inputStream())
            }
            storeFile = file(System.getenv("KEYSTORE_FILE") ?: keystoreProps["storeFile"] ?: "app/bloco-na-rua.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: keystoreProps["storePassword"]?.toString() ?: ""
            keyAlias = System.getenv("KEY_ALIAS") ?: keystoreProps["keyAlias"]?.toString() ?: ""
            keyPassword = System.getenv("KEY_PASSWORD") ?: keystoreProps["keyPassword"]?.toString() ?: ""
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}
