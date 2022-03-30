requires "Dancer2"                                           => "0.400000";
requires "Dancer2::Plugin::DBIC"                             => "0";
requires "Dancer2::Plugin::Auth::Extensible::Provider::DBIC" => "0";
requires "Dancer2::Session::Redis"                           => "0";
requires "Dancer2::Session::Redis::Serialization::Sereal"    => "0";
requires "Dancer2::Template::Xslate"                         => "0";
requires "Dancer2::Plugin::Deferred"                         => "0";
requires "Dancer2::Plugin::FormValidator"                    => "0";

# Basic.

requires "Moo"             => "0";
requires "DBD::mysql"      => "0";
requires "Sereal::Decoder" => "0";
requires "Sereal::Encoder" => "0";

# Plack.

requires "Plack::Middleware::AccessLog::Timed" => "0";
requires "Log::Dispatch"                       => "0";

# Support.

requires "DBIx::Class::Migration"           => "0";

recommends "YAML"                    => "0";
recommends "URL::Encode::XS"         => "0";
recommends "CGI::Deurl::XS"          => "0";
recommends "CBOR::XS"                => "0";
recommends "YAML::XS"                => "0";
recommends "Class::XSAccessor"       => "0";
recommends "Crypt::URandom"          => "0";
recommends "HTTP::XSCookies"         => "0";
recommends "HTTP::XSHeaders"         => "0";
recommends "Math::Random::ISAAC::XS" => "0";
recommends "MooX::TypeTiny"          => "0";
recommends "Type::Tiny::XS"          => "0";

# Accelerate.

feature 'accelerate', 'Accelerate Dancer2 app performance with XS modules' => sub {
    requires "URL::Encode::XS"         => "0";
    requires "CGI::Deurl::XS"          => "0";
    requires "YAML::XS"                => "0";
    requires "Class::XSAccessor"       => "0";
    requires "Cpanel::JSON::XS"        => "0";
    requires "Crypt::URandom"          => "0";
    requires "HTTP::XSCookies"         => "0";
    requires "HTTP::XSHeaders"         => "0";
    requires "Math::Random::ISAAC::XS" => "0";
    requires "MooX::TypeTiny"          => "0";
    requires "Type::Tiny::XS"          => "0";
};

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};

