# == Define: django::project

define django::project (
  $project,
  $package,
  $path,
  $domain,
  $port,
  $git_repo
) {
  git::repo { $project:
    path   => "${path}/${project}",
    source => $git_repo,
  }

  uwsgi::vassal { $project:
    project    => $project,
    chdir      => "${path}/${project}",
    virtualenv => "${path}/${project}/venv",
    wsgi_file  => "${path}/${project}/${package}/wsgi.py",
    port       => $port,
    require    => Class['django']
  }

  cron { 'cleanup':
    ensure  => present,
    command => "${path}/${project}/venv/bin/python manage.py cleanup",
    user    => 'web',
    weekday => 1,
    require => Class['django']
  }
}
