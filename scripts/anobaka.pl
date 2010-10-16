#!/usr/bin/perl 
use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/../lib";

use NetBaka;
use EBook::EPUB;
use Data::UUID;
use utf8;

my $epub = EBook::EPUB->new;
$epub->add_title('『ネット起業！ あのバカにやらせてみよう』');
$epub->add_author('岡本呻也');
$epub->add_language('ja');

my $ug = new Data::UUID;
my $uuid = $ug->create_from_name_str(NameSpace_URL, "nin-r.com/netbaka/");
$epub->add_identifier("urn:uuid:$uuid");

my $p = 1; my $cnum = 0;
my $nb;
while( 1 ) {
    $nb = NetBaka->new( $nb ? $nb->next_link : undef  );
    print "getting page $p " . $nb->url . "\n";
    my $fname = 'netbaka'.( $p++ ).".xhtml";
    $epub->add_xhtml($fname, $nb->content_xhtml, linear => 'yes' );
    $epub->add_navpoint(
        label      => $nb->title,
        play_order => $p,
        id         => "p$p",
        content    => $fname
    ) if $nb->title;
    print "done\n";
    sleep 1;
    last unless $nb->next_link;
    #last if $p >= 10;
}

$epub->pack_zip('baka.epub');
