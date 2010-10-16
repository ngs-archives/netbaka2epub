package NetBaka;
use strict;
use warnings;
use URI;
use Web::Scraper;
use Encode qw/ from_to /;
use utf8;

use constant FIRST_PAGE => URI->new('http://nin-r.com/netbaka/001.htm');

sub new {
    bless { url => $_[1] ? $_[1] : FIRST_PAGE }, $_[0]
}

sub url { shift->{url} }

sub content {
    my $self = shift;
    $self->scrape unless $self->{content};
    $self->{content};
}

sub title {
    my $self = shift;
    $self->scrape unless $self->{title};
    $self->{title};
}

sub chapter {
    my $self = shift;
    $self->scrape unless defined $self->{chapter};
    $self->{chapter};
}

sub content_xhtml {
    my $self = shift;
    my $content = $self->content;
    my $title   = $self->title;
    my $url     = $self->url->as_string;
<<EOM
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title>$title</title>
    <!-- Downloaded from $url -->
</head>
<body>
$content
</body>
</html>
EOM
}

sub scrape {
    my $self = shift;
    my $sc  = scraper {
        process q{td[width='465']}, body => 'HTML';
        process q{p[align='left'] a}, next_link => '@href';
        process q{p font[class='size5']}, title => 'TEXT';
        process q{font[color='#6666FF']}, chapter => 'TEXT';
    };
    my $res = $sc->scrape( URI->new($self->url) );
    $self->{next_link} = $res->{next_link}->as_string =~ /\d{3}\.htm$/ ? $res->{next_link} : 0;
    $self->{title}     = $res->{title};
    $self->{chapter}   = $res->{chapter};
    my $content = $res->{body};
    Encode::_utf8_off($content);
    $content = Encode::decode("utf8",$content);
    $content =~ s/<p align="left"><font class="size3" size="3"><b>.+|<\w+ [^>]+>[ 　]+<\/\w+>//ig;
    $self->{content} = $content;
}

sub next_link {
    my $self = shift;
    $self->scrape unless defined $self->{next_link};
    $self->{next_link};
}



1;



