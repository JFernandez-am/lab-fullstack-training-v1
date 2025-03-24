package labs.airmiles.models

import kotlinx.serialization.Serializable
import java.lang.management.ManagementFactory


object ServerStats {

    @Serializable
    data class ServerStats(
        val usedMemory: String,
        val totalMemory: String,
        val maxMemory: String,
        val processors: Int,
        val uptime: String
    )

    private var cachedStats: ServerStats? = null

    fun getStats(): ServerStats {
        if (cachedStats == null) {
            cachedStats = calculateServerStats()
        }
        return cachedStats!!
    }

    private fun calculateServerStats(): ServerStats {
        val runtime = Runtime.getRuntime()
        val mb = 1024 * 1024

        return ServerStats(
            usedMemory = "${(runtime.totalMemory() - runtime.freeMemory()) / mb} MB",
            totalMemory = "${runtime.totalMemory() / mb} MB",
            maxMemory = "${runtime.maxMemory() / mb} MB",
            processors = runtime.availableProcessors(),
            uptime = "${ManagementFactory.getRuntimeMXBean().uptime / 1000} seconds"
        )
    }
}

