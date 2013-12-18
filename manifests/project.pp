# == Define: django::project

define django::project (
  $package,
  $path,
  $domain,
  $port,
  $git_repo,
  $max_body_size='4MB'
) {

  vcsrepo { "${path}/${title}":
    ensure   => present,
    provider => git,
    source   => $git_repo,
    user     => 'web',
  }

  django::nginx { $title: }

  uwsgi::vassal { $title:
    chdir      => "${path}/${title}",
    virtualenv => "${path}/${title}/venv",
    wsgi_file  => "${path}/${title}/${package}/wsgi.py",
    port       => $port,
  }

  cron { "${title}-cleanup":
    ensure  => present,
    command => "${path}/${title}/venv/bin/python ${path}/${title}/manage.py cleanup",
    user    => 'web',
    weekday => 1,
    hour    => 3,
    minute  => 3
  }
}
