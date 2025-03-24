package labs.airmiles.plugins

import io.ktor.server.application.*
import io.ktor.server.mustache.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import labs.airmiles.models.ServerStats


fun Application.configureTemplating() {
    routing {
        get("/ui") {
            call.respond(
                MustacheContent(
                    "ui.mustache",
                    mapOf("data" to ServerStats.getStats())
                )
            )
        }
    }
}