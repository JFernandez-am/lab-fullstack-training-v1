package labs.airmiles

import com.github.mustachejava.DefaultMustacheFactory
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.mustache.*
import io.ktor.server.netty.*
import labs.airmiles.plugins.configureRouting
import labs.airmiles.plugins.configureSerialization
import labs.airmiles.plugins.configureTemplating

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {
    install(Mustache) {
        mustacheFactory = DefaultMustacheFactory("templates")
    }

    configureRouting()
    configureTemplating()
    configureSerialization()
}
