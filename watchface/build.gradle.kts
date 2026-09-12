plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "com.gaatsu.viperhud"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.gaatsu.viperhud"
        // Wear OS 4 is the first release with Watch Face Format.
        minSdk = 33
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
