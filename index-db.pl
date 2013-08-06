#!/usr/bin/env perl
use strict;
use DBI;
use File::Find;
use Path::Tiny;
use Try::Tiny;
use JSON;

my $dbfile = path "PAUSE.sqlite3";
my $dbh = DBI->connect("dbi:SQLite:$dbfile", "", "", { RaiseError => 1, PrintError => 0 });

my $has_table = try { $dbh->do("SELECT 1 FROM dist_packages"); 1 };

unless ($has_table) {
    $dbh->do(<<SQL);
CREATE TABLE dist_packages (
  package varchar,
  version varchar,
  version_numified varchar,
  pathname varchar,
  PRIMARY KEY (package, version)
);
SQL
}

my $insert_sth = $dbh->prepare("INSERT INTO dist_packages VALUES (?, ?, ?, ?)");
my $update_sth = $dbh->prepare("UPDATE dist_packages SET pathname = ? WHERE package = ? AND version = ?");

$dbh->begin_work;

my $count = 0;

my $finder = sub {
    return unless /\.json$/;

    my $data = JSON::decode_json(path($_)->slurp);
    warn "Indexing $data->{pathname}\n";

    while (my($package, $version) = each %{$data->{packages}}) {
        my $num = version->new($version)->numify;
        try {
            $insert_sth->execute($package, $version, $num, $data->{pathname});
        } catch {
            $update_sth->execute($data->{pathname}, $package, $version);
        };
    }

    if ($count++ % 1000 == 0) {
        $dbh->commit;
        $dbh->begin_work;
    }
};

find({ wanted => $finder, no_chdir => 1 }, 'dists');

$dbh->commit;
