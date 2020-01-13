user { 'linus':
  ensure   => 'present',
  password =>  '$1$9MCsbH8/$1sUqPu61bCSpaWIkAJIr51',
  home     => '/srv/linus',
}
user { 'analista':
  ensure   => 'present',
  password =>  '$1$9MCsbH8/$1sUqPu61bCSpaWIkAJIr51',
  home     => '/srv/analista',
}
