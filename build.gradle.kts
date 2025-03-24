val ktorVersion: String by project
val kotlinVersion: String by project
val logbackVersion: String by project
val kotlinxSerializationVersion: String by project

plugins {
    application
    kotlin("jvm") version "2.1.20"
    id("io.ktor.plugin") version "3.1.1"
    kotlin("plugin.serialization") version "2.1.20"
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
    implementation("io.ktor:ktor-server-core-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-netty-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-mustache:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
    implementation("io.ktor:ktor-server-html-builder:$ktorVersion")
    implementation("ch.qos.logback:logback-classic:$logbackVersion")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:$kotlinxSerializationVersion")
    implementation("io.ktor:ktor-server-cors:3.1.1")
    implementation("io.ktor:ktor-server-core:3.1.1")
    implementation("io.ktor:ktor-server-core:3.1.1")

    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlinVersion")
    testImplementation("io.ktor:ktor-client-mock:$ktorVersion")

}
