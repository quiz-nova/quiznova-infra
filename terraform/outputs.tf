output "repository_urls" {
  description = "HTML URLs of the managed repositories"
  value = {
    web   = github_repository.quiznova_web.html_url
    api   = github_repository.quiznova_api.html_url
    infra = github_repository.quiznova_infra.html_url
  }
}

output "repository_ssh_clone_urls" {
  description = "SSH clone URLs of the managed repositories"
  value = {
    web   = github_repository.quiznova_web.ssh_clone_url
    api   = github_repository.quiznova_api.ssh_clone_url
    infra = github_repository.quiznova_infra.ssh_clone_url
  }
}
