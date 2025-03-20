package labs.airmiles.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import labs.airmiles.models.ServerStats
import java.lang.management.ManagementFactory

fun Application.configureRouting() {
    routing {
        get("/") {
            val runtime = Runtime.getRuntime()
            val mb = 1024 * 1024
            val usedMemory = (runtime.totalMemory() - runtime.freeMemory()) / mb
            val totalMemory = runtime.totalMemory() / mb
            val maxMemory = runtime.maxMemory() / mb
            val processors = runtime.availableProcessors()
            val uptime = ManagementFactory.getRuntimeMXBean().uptime / 1000

            val serverStats = ServerStats(
                usedMemory = "$usedMemory MB",
                totalMemory = "$totalMemory MB",
                maxMemory = "$maxMemory MB",
                processors = processors,
                uptime = "$uptime seconds"
            )

            call.respond(
                serverStats
            )
        }

        get("/health") {
            call.respondText("OK", ContentType.Text.Plain)
        }
    }
}
