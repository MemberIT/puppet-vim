class vim::pathogen (
  $user = undef,
  $home = undef,
) {

  #validate_string($user)

  #include wget

  if $home == undef {
    if $user == 'root' {
      $home_real = '/root'
    } else {
      $home_real = "/home/${user}"
    }
  } else {
    $home_real = $home
  }

  # Setup directories
  file { ["${home_real}/.vim", "${home_real}/.vim/autoload", "${home_real}/.vim/bundle"]:
    ensure => directory,
    owner  => $user,
  }

  ## Install pathogen.vim
  #wget::fetch { 'wget-pathogen':
  #  source      => 'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim',
  #  destination => "${home_real}/.vim/autoload/pathogen.vim",
  #  nocheckcertificate => true,
  #  require => File["${home_real}/.vim/autoload"],
  #}

  exec { 'curl-pathogen':
    creates => "${home_real}/.vim/autoload/pathogen.vim",
    command => "/bin/curl -LSso ${home_real}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim",
  }

  file { "${home_real}/.vim/autoload/pathogen.vim":
    owner => $user,
    require => Exec['curl-pathogen'],
  }

  file { "${home_real}/.vimrc":
    ensure => file,
    content => "execute pathogen#infect()\n",
    owner => $user,
  }

}
