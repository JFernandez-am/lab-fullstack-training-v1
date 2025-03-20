#!/usr/bin/env pwsh
# setup.ps1 - Setup script for creating a full stack Kotlin Ktor application

$appName = "fullstack lab application"
$appPackage = "labs.airmiles"
$packagePath = $appPackage.Replace(".", "/")

# Create directory structure
$directories = @(
    "src/main/kotlin/$packagePath",
    "src/main/resources/static",
    "src/main/resources/templates",
    "src/test/kotlin/$packagePath",
    "gradle/wrapper"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Host "Created directory: $dir" -ForegroundColor Green
}

# Create .gitignore file
$gitignoreContent = @"
# Gradle
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar

# IntelliJ IDEA
.idea/
*.iws
*.iml
*.ipr
out/

# VS Code
.vscode/
.settings/
.classpath
.project

# Kotlin
*.class
*.log

# Package Files
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# OS-specific
.DS_Store
Thumbs.db
"@

Set-Content -Path ".gitignore" -Value $gitignoreContent
Write-Host "Created .gitignore file" -ForegroundColor Green

# Create README.md
$readmeContent = @"
# $appName

A full stack application built with Kotlin and Ktor framework.

## Features

- Web server running on port 8080
- Displays server statistics
- Shows random quotes

## Getting Started

### Prerequisites

- JDK 11 or higher
- Gradle (or use the included wrapper)

### Running the Application

```bash
# Using gradle wrapper
./gradlew run

# Or if you're on Windows
.\gradlew.bat run
```

The application will be available at http://localhost:8080

## Development

This project uses Gradle with Kotlin DSL for build configuration.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
"@

Set-Content -Path "README.md" -Value $readmeContent
Write-Host "Created README.md file" -ForegroundColor Green

# Create LICENSE file
$licenseContent = @"
MIT License

Copyright (c) $(Get-Date -Format "yyyy") $appPackage

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@

Set-Content -Path "LICENSE" -Value $licenseContent
Write-Host "Created LICENSE file" -ForegroundColor Green

# Create build.gradle.kts
$buildGradleContent = @"
val ktor_version: String by project
val kotlin_version: String by project
val logback_version: String by project

plugins {
    application
    kotlin("jvm") version "1.9.22"
    id("io.ktor.plugin") version "2.3.8"
    kotlin("plugin.serialization") version "1.9.22"
}

group = "$appPackage"
version = "0.0.1"

application {
    mainClass.set("$appPackage.ApplicationKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=\$isDevelopment")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:${'$'}ktor_version")
    implementation("io.ktor:ktor-server-netty-jvm:${'$'}ktor_version")
    implementation("io.ktor:ktor-server-freemarker:${'$'}ktor_version")
    implementation("io.ktor:ktor-server-content-negotiation:${'$'}ktor_version")
    implementation("io.ktor:ktor-serialization-kotlinx-json:${'$'}ktor_version")
    implementation("io.ktor:ktor-server-html-builder:${'$'}ktor_version")
    implementation("ch.qos.logback:logback-classic:${'$'}logback_version")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")
    
    testImplementation("io.ktor:ktor-server-tests-jvm:${'$'}ktor_version")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:${'$'}kotlin_version")
}
"@

Set-Content -Path "build.gradle.kts" -Value $buildGradleContent
Write-Host "Created build.gradle.kts file" -ForegroundColor Green

# Create gradle.properties
$gradlePropertiesContent = @"
ktor_version=2.3.8
kotlin_version=1.9.22
logback_version=1.4.11
kotlin.code.style=official
"@

Set-Content -Path "gradle.properties" -Value $gradlePropertiesContent
Write-Host "Created gradle.properties file" -ForegroundColor Green

# Create settings.gradle.kts
$settingsGradleContent = @"
rootProject.name = "fullstack-lab-application"
"@

Set-Content -Path "settings.gradle.kts" -Value $settingsGradleContent
Write-Host "Created settings.gradle.kts file" -ForegroundColor Green

# Create Application.kt
$applicationContent = @"
package $appPackage

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import $appPackage.plugins.*

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {
    configureRouting()
    configureTemplating()
    configureSerialization()
}
"@

Set-Content -Path "src/main/kotlin/$packagePath/Application.kt" -Value $applicationContent
Write-Host "Created Application.kt file" -ForegroundColor Green

# Create Plugins.kt files
$routingContent = @"
package $appPackage.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import $appPackage.models.Quote
import $appPackage.models.ServerStats
import java.lang.management.ManagementFactory
import kotlin.random.Random

fun Application.configureRouting() {
    routing {
        get("/") {
            val quotes = listOf(
                Quote("The only way to do great work is to love what you do.", "Steve Jobs"),
                Quote("Life is what happens when you're busy making other plans.", "John Lennon"),
                Quote("Simplicity is the ultimate sophistication.", "Leonardo da Vinci"),
                Quote("The future belongs to those who believe in the beauty of their dreams.", "Eleanor Roosevelt"),
                Quote("Code is like humor. When you have to explain it, it's bad.", "Cory House")
            )
            
            val randomQuote = quotes[Random.nextInt(quotes.size)]
            
            val runtime = Runtime.getRuntime()
            val mb = 1024 * 1024
            val usedMemory = (runtime.totalMemory() - runtime.freeMemory()) / mb
            val totalMemory = runtime.totalMemory() / mb
            val maxMemory = runtime.maxMemory() / mb
            val processors = runtime.availableProcessors()
            val uptime = ManagementFactory.getRuntimeMXBean().uptime / 1000
            
            val serverStats = ServerStats(
                usedMemory = "${'$'}usedMemory MB",
                totalMemory = "${'$'}totalMemory MB",
                maxMemory = "${'$'}maxMemory MB",
                processors = processors,
                uptime = "${'$'}uptime seconds"
            )
            
            call.respond(
                mapOf(
                    "stats" to serverStats,
                    "quote" to randomQuote
                )
            )
        }
        
        get("/health") {
            call.respondText("OK", ContentType.Text.Plain)
        }
    }
}
"@

New-Item -ItemType Directory -Path "src/main/kotlin/$packagePath/plugins" -Force | Out-Null
Set-Content -Path "src/main/kotlin/$packagePath/plugins/Routing.kt" -Value $routingContent
Write-Host "Created Routing.kt file" -ForegroundColor Green

$templatingContent = @"
package $appPackage.plugins

import io.ktor.server.application.*
import io.ktor.server.html.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.html.*

fun Application.configureTemplating() {
    routing {
        get("/ui") {
            call.respondHtml {
                head {
                    title("$appName")
                    style {
                        +"""
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            margin: 0;
                            padding: 20px;
                            background-color: #f5f5f5;
                            color: #333;
                        }
                        .container {
                            max-width: 800px;
                            margin: 0 auto;
                            background-color: white;
                            padding: 30px;
                            border-radius: 8px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        h1 {
                            color: #2c3e50;
                            border-bottom: 2px solid #eee;
                            padding-bottom: 10px;
                        }
                        .stats-container {
                            margin-top: 20px;
                            background-color: #f8f9fa;
                            padding: 15px;
                            border-radius: 6px;
                        }
                        .stats-title {
                            font-weight: bold;
                            margin-bottom: 10px;
                        }
                        .quote-container {
                            margin-top: 30px;
                            background-color: #e8f4fc;
                            padding: 20px;
                            border-radius: 6px;
                            border-left: 4px solid #3498db;
                        }
                        .quote-text {
                            font-style: italic;
                            font-size: 1.1em;
                        }
                        .quote-author {
                            text-align: right;
                            margin-top: 10px;
                            font-weight: bold;
                        }
                        """
                    }
                }
                body {
                    div(classes = "container") {
                        h1 { +"$appName" }
                        
                        div(classes = "stats-container") {
                            div(classes = "stats-title") { +"Server Statistics" }
                            div { id = "stats-data" }
                        }
                        
                        div(classes = "quote-container") {
                            div(classes = "quote-text") { id = "quote-text" }
                            div(classes = "quote-author") { id = "quote-author" }
                        }
                    }
                    
                    script {
                        +"""
                        fetch('/')
                            .then(response => response.json())
                            .then(data => {
                                // Populate server stats
                                const statsContainer = document.getElementById('stats-data');
                                const stats = data.stats;
                                statsContainer.innerHTML = `
                                    <p><strong>Used Memory:</strong> ${'$`{stats.usedMemory}'}</p>
                                    <p><strong>Total Memory:</strong> ${'$`{stats.totalMemory}'}</p>
                                    <p><strong>Max Memory:</strong> ${'$`{stats.maxMemory}'}</p>
                                    <p><strong>Processors:</strong> ${'$`{stats.processors}'}</p>
                                    <p><strong>Uptime:</strong> ${'$`{stats.uptime}'}</p>
                                `;
                                
                                // Populate quote
                                const quote = data.quote;
                                document.getElementById('quote-text').innerText = `"${'$`{quote.text}'"`;
                                document.getElementById('quote-author').innerText = `— ${'$`{quote.author}'}`;
                            })
                            .catch(error => console.error('Error fetching data:', error));
                        """
                    }
                }
            }
        }
    }
}
"@

Set-Content -Path "src/main/kotlin/$packagePath/plugins/Templating.kt" -Value $templatingContent
Write-Host "Created Templating.kt file" -ForegroundColor Green

$serializationContent = @"
package $appPackage.plugins

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import kotlinx.serialization.json.Json

fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json(Json {
            prettyPrint = true
            isLenient = true
        })
    }
}
"@

Set-Content -Path "src/main/kotlin/$packagePath/plugins/Serialization.kt" -Value $serializationContent
Write-Host "Created Serialization.kt file" -ForegroundColor Green

# Create model classes
New-Item -ItemType Directory -Path "src/main/kotlin/$packagePath/models" -Force | Out-Null

$quoteModelContent = @"
package $appPackage.models

import kotlinx.serialization.Serializable

@Serializable
data class Quote(
    val text: String,
    val author: String
)
"@

Set-Content -Path "src/main/kotlin/$packagePath/models/Quote.kt" -Value $quoteModelContent
Write-Host "Created Quote.kt model" -ForegroundColor Green

$serverStatsModelContent = @"
package $appPackage.models

import kotlinx.serialization.Serializable

@Serializable
data class ServerStats(
    val usedMemory: String,
    val totalMemory: String,
    val maxMemory: String,
    val processors: Int,
    val uptime: String
)
"@

Set-Content -Path "src/main/kotlin/$packagePath/models/ServerStats.kt" -Value $serverStatsModelContent
Write-Host "Created ServerStats.kt model" -ForegroundColor Green

# Create logback.xml
$logbackContent = @"
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{YYYY-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="STDOUT"/>
    </root>
    <logger name="org.eclipse.jetty" level="INFO"/>
    <logger name="io.netty" level="INFO"/>
</configuration>
"@

New-Item -ItemType Directory -Path "src/main/resources" -Force | Out-Null
Set-Content -Path "src/main/resources/logback.xml" -Value $logbackContent
Write-Host "Created logback.xml file" -ForegroundColor Green

# Create gradlew files (dummy placeholders - would normally be downloaded by Gradle wrapper task)
$gradlewContent = @"
#!/bin/sh
# This is a placeholder for the Gradle wrapper script
# In a real environment, you would generate this with 'gradle wrapper'

echo "This is a placeholder Gradle wrapper. Please run 'gradle wrapper' to generate the real wrapper."
"@

Set-Content -Path "gradlew" -Value $gradlewContent
Write-Host "Created gradlew placeholder (you'll need to run 'gradle wrapper' to generate the real one)" -ForegroundColor Yellow

$gradlewBatContent = @"
@echo off
REM This is a placeholder for the Gradle wrapper batch script
REM In a real environment, you would generate this with 'gradle wrapper'

echo This is a placeholder Gradle wrapper. Please run 'gradle wrapper' to generate the real wrapper.
"@

Set-Content -Path "gradlew.bat" -Value $gradlewBatContent
Write-Host "Created gradlew.bat placeholder (you'll need to run 'gradle wrapper' to generate the real one)" -ForegroundColor Yellow

Write-Host "`nSetup complete! Your Kotlin Ktor application has been created." -ForegroundColor Cyan
Write-Host "`nTo generate proper Gradle wrapper files, run:" -ForegroundColor Yellow
Write-Host "gradle wrapper" -ForegroundColor White

Write-Host "`nTo commit to git, run the following commands:" -ForegroundColor Yellow
Write-Host "git add ." -ForegroundColor White
Write-Host "git commit -m 'Initial commit: Full stack Kotlin Ktor application setup'" -ForegroundColor White
Write-Host "git push origin main" -ForegroundColor White

Write-Host "`nTo run the application, use:" -ForegroundColor Yellow
Write-Host ".\gradlew run" -ForegroundColor White
Write-Host "Then open your browser to http://localhost:8080/ui" -ForegroundColor White
