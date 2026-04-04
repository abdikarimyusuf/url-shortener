resource "ws_codestarconnections_connection" "codestar" {
    name = var.name
    provider_type = "GitHub"
}