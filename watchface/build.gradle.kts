plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "com.gaatsu.viperhud"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.gaatsu.viperhud"
        // Wear OS 6: Watch Face Format v4 (see the header of watchface.xml).
        minSdk = 36
        targetSdk = 36
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
