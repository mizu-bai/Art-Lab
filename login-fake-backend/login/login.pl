#!/usr/bin/env perl

use Mojolicious::Lite -signatures;
use Mojo::JSON qw(decode_json encode_json);

my $fake_user = {
  account => "abc",
  password => "dedb15266596f5f3183c09eace4b4acf" # 123
};

post "/login" => sub ($c) {
  my $hash = $c->req->json;
  my $account = $hash->{account};
  my $password = $hash->{password};
  my $login_result = {
      status => Mojo::JSON::false,
      identifier => undef,
      nickName => undef,
      iconBase64 => undef
  };
  if ($account eq $fake_user->{account} && $password eq $fake_user->{password}) {
    open FILE, "./icon.txt" or die $!;
    my @content = <FILE>;
    my $icon_base64 = join "", @content;
    $login_result->{status} = Mojo::JSON::true;
    $login_result->{identifier} = "0x114514";
    $login_result->{nickName} = "CV届传统艺能";
    $login_result->{iconBase64} = $icon_base64;
  }
  $c->render(json => $login_result);
};

app->start;
