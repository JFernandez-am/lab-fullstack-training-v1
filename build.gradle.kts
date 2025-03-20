val ktor_version: String by project
val kotlin_version: String by project

plugins {
    application
    kotlin("jvm") version "1.9.22"
    id("io.ktor.plugin") version "2.3.8"
    kotlin("plugin.serialization") version "1.9.22"
}

group = "labs.airmiles"
version = "0.0.1"

application {
    mainClass.set("labs.airmiles.ApplicationKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:ktor_version")
    implementation("io.ktor:ktor-server-netty-jvm:ktor_version")
    implementation("io.ktor:ktor-server-freemarker:ktor_version")
    implementation("io.ktor:ktor-server-content-negotiation:ktor_version")
    implementation("io.ktor:ktor-serialization-kotlinx-json:ktor_version")
    implementation("io.ktor:ktor-server-html-builder:ktor_version")
    implementation("ch.qos.logback:logback-classic:1.5.18")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")
    
    testImplementation("io.ktor:ktor-server-tests-jvm:ktor_version")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:1.9.22")
}
