#!/usr/bin/perl
use strict;
use warnings;

# 文字列操作関数
sub replace_strings {
    my ($text, $pattern, $replacement) = @_;
    $text =~ s/$pattern/$replacement/g for (1..100000);
    return $text;
}

# 大量の文字列を生成し操作
my $text = "A" x 1000000; # 100万文字の"A"
my $result = replace_strings($text, "A", "B");
