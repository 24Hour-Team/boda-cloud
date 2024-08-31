output "amazon_linux_id" {
    value = data.aws_ami.al2023.id
}

output "ubuntu_id" {
    value = data.aws_ami.ubuntu.id
}

output "windows_full_id" {
    value = data.aws_ami.windows_full.id
}

output "windows_core_id" {
    value = data.aws_ami.windows_core.id
}