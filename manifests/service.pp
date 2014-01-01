# To be improved: if ensure = absent, removal is working
# only if the service has already been stopped
#
class rtorrent::service($ensure = present) {

  if $ensure == present {
    service{'rtorrentd':
      ensure => running,
    }
  }

}
