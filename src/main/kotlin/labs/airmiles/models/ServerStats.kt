package labs.airmiles.models

import kotlinx.serialization.Serializable

@Serializable
data class ServerStats(
    val usedMemory: String,
    val totalMemory: String,
    val maxMemory: String,
    val processors: Int,
    val uptime: String
)
