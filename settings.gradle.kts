pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("flutter_module/build/host/outputs/repo")
        }
        maven {
            val storageUrl = System.getenv("FLUTTER_STORAGE_BASE_URL") ?: "https://storage.googleapis.com"
            url = uri("$storageUrl/download.flutter.io")
        }
    }
}

rootProject.name = "TestFlutter"
include(":app")
