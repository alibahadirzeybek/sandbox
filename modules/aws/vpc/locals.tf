locals {
    local_ip = "${chomp(data.http.local_ip.response_body)}"
}