use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use Test::More;
use Carp;
use URI;
use utf8;

BEGIN { use_ok 'NetBaka' }

{
    my   $nb = NetBaka->new;
    is   $nb->url, 'http://nin-r.com/netbaka/001.htm', 'page format';
    is   $nb->next_link->as_string, 'http://nin-r.com/netbaka/002.htm', 'Has next';
    is   $nb->title, 'プロローグ', 'Check title';

    like $nb->content, qr'「ＩＴ革命とは何か」という議論がある。', 'check content';
    like $nb->content, qr'彼らこそネットベンチャーと呼ぶに相応しい者たちであろう。', 'check content';
}
{
    my   $nb = NetBaka->new(URI->new('http://nin-r.com/netbaka/101.htm'));
    is   $nb->title, '第3のメディアをつくる', 'Check title';
    is   $nb->chapter, '第１章　ダイヤルＱ２から生まれた ネットベンチャー';
    like $nb->content, qr'第１章　ダイヤルＱ２から生まれた', 'check content';
    like $nb->content, qr'ではなぜ彼はこんなアイデアをひねり出すことができたのか。', 'check content';
}
{
    my   $nb = NetBaka->new(URI->new('http://nin-r.com/netbaka/002.htm'));
    is   $nb->next_link->as_string, 'http://nin-r.com/netbaka/101.htm', 'Has next';
}

{
    my $nb = NetBaka->new( URI->new('http://nin-r.com/netbaka/708.htm') );
    ok !$nb->next_link, 'No next';
}

done_testing
