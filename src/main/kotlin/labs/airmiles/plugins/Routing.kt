package labs.airmiles.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import labs.airmiles.models.ServerStats

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respond(
                ServerStats.getStats()
            )
        }

        get("/health") {
            call.respondText("OK", ContentType.Text.Plain)
        }
    }
}
