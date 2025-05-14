pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        requireNotNull(properties.getProperty("flutter.sdk")) { "flutter.sdk not set in local.properties" }
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // AGP ponecháme na 8.2.1
    id("com.android.application") version "8.2.1" apply false
    // Povýšený Kotlin Gradle plugin, ktorý podporuje metadata 2.1.0
    id("org.jetbrains.kotlin.android") version "2.1.21" apply false
}

include(":app")
