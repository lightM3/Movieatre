allprojects {
    repositories {
        google()
        mavenCentral()
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

subprojects {
    project.plugins.whenPluginAdded {
        if (this.javaClass.name.contains("LibraryPlugin") || this.javaClass.name.contains("AppPlugin")) {
            val androidExt = project.extensions.findByName("android")
            if (androidExt != null) {
                try {
                    androidExt.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                        .invoke(androidExt, 36)
                } catch (e: Exception) {}
            }
        }
    }
}

subprojects {
    project.plugins.withId("com.android.library") {
        if (project.name == "isar_flutter_libs") {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    android::class.java.getMethod("setNamespace", String::class.java)
                        .invoke(android, "dev.isar.isar_flutter_libs")
                } catch (e: Exception) {}
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                android.javaClass.getMethod("setCompileSdkVersion", Int::class.java).invoke(android, 36)
            } catch (e: Exception) {}
            try {
                android.javaClass.getMethod("setCompileSdk", Int::class.java).invoke(android, 36)
            } catch (e: Exception) {}
        }
    }
}