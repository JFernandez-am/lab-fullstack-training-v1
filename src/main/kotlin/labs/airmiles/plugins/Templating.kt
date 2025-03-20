package labs.airmiles.plugins

import io.ktor.server.application.*
import io.ktor.server.html.*
import io.ktor.server.routing.*
import kotlinx.html.*

fun Application.configureTemplating() {
    routing {
        get("/ui") {
            call.respondHtml {
                head {
                    title("fullstack lab application")
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
                        h1 { +"fullstack lab application" }

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
                                statsContainer.innerHTML = 
                                    <p><strong>Used Memory:</strong> '}</p>
                                    <p><strong>Total Memory:</strong> '}</p>
                                    <p><strong>Max Memory:</strong> '}</p>
                                    <p><strong>Processors:</strong> '}</p>
                                    <p><strong>Uptime:</strong> '}</p>
                                ;
                                
                                // Populate quote
                                const quote = data.quote;
                                document.getElementById('quote-text').innerText = "'";
                                document.getElementById('quote-author').innerText = — '};
                            })
                            .catch(error => console.error('Error fetching data:', error));
                        """
                    }
                }
            }
        }
    }
}
