class rtorrent::config(
  $ensure,
  $uid     = undef,
  $gid     = undef,
  $homedir = '/var/lib/rtorrent'
) {

  user {'rtorrent':
    ensure => $ensure,
    uid    => $uid,
    gid    => $gid,
    home   => $homedir,
  }

  file {'/etc/init.d/rtorrentd':
    ensure  => $ensure,
    mode    => '0755',
    content => template('rtorrent/rtorrentd-init.erb'),
  }

  $ensure_dir = $ensure ? {
    'present' => directory,
    default   => absent,
  }

  file {[$homedir, "${homedir}/downloads"]:
    ensure  => $ensure_dir,
    force   => true,
    owner   => 'rtorrent',
    mode    => '0700',
    require => User['rtorrent'],
  }

  file {"${homedir}/.rtorrent.rc":
    ensure  => $ensure,
    force   => true,
    owner   => 'rtorrent',
    content => "directory = ${homedir}/downloads
load_start_verbose = ${homedir}/*.torrent
schedule = 10minutes,00:00:00,00:10:00,load_start_verbose
",
    require => File[$homedir],
  }
}
