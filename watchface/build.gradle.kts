plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "com.gaatsu.viperhud"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.gaatsu.viperhud"
        // Wear OS 5: the weather data sources need Watch Face Format v2.
        minSdk = 34
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            // Keep resource shrinking off: the format XML references
            // drawables and fonts by name, so the shrinker cannot see
            // that they are used.
            isShrinkResources = false

            // TODO: point this at your own upload key before publishing.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
