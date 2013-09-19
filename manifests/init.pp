# == Class: django::project

class django::project(
  $project,
  $slug,
  $path,
  $domain,
  $port,
  $git_repo
) {
  git::repo { $project:
    path   => "${path}/${project}",
    source => $git_repo,
  }

  nginx::resource::vhost { $project:
    ensure   => present,
    www_root => "${path}/${project}"
  }

  uwsgi::vassal { $project:
    project    => $project,
    chdir      => "${path}/${project}",
    virtualenv => "${path}/${project}/venv",
    wsgi_file  => "${path}/${project}/${slug}/wsgi.py",
    port       => $port
  }

  cron { 'cleanup':
    ensure  => present,
    command => "${path}/${project}/venv/bin/python manage.py cleanup",
    user    => 'web',
    weekday => 1,
  }
}
