allprojects {
    repositories {
        google()
        mavenCentral()
        // Mapbox serves its SDK from its own authenticated Maven repo. The
        // password is the secret DOWNLOADS:READ token (sk.*), read from
        // ~/.gradle/gradle.properties so it stays out of this repo. Build-time
        // only — it is never bundled into the shipped app.
        maven {
            url = uri("https://api.mapbox.com/downloads/v2/releases/maven")
            authentication {
                create<BasicAuthentication>("basic")
            }
            credentials {
                username = "mapbox"
                password = providers.gradleProperty("MAPBOX_DOWNLOADS_TOKEN").getOrElse("")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// mapbox_maps_flutter 2.27.0 assumes AGP 9's built-in Kotlin is active, so it
// skips applying the standalone Kotlin plugin. But this Flutter template sets
// `android.builtInKotlin=false` (gradle.properties), so nothing would provide
// the top-level `kotlin { }` DSL that the plugin's own build.gradle still uses.
// Re-apply the standalone Kotlin plugin for just that subproject to fill the gap.
subprojects {
    if (name == "mapbox_maps_flutter") {
        apply(plugin = "org.jetbrains.kotlin.android")
    }
}


tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
