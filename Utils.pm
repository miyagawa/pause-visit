package Utils;

# Update: visit-pause /tmp/PAUSE-git -e 'use Utils; Utils::update_record(@_)'

use DBI;
use Try::Tiny;

my $dbh = DBI->connect("dbi:SQLite:PAUSE.sqlite3", "", "", { RaiseError => 1, PrintError => 0 });

my $insert_sth = $dbh->prepare("INSERT INTO dist_packages VALUES (?, ?, ?, ?)");
my $update_sth = $dbh->prepare("UPDATE dist_packages SET pathname = ? WHERE package = ? AND version = ?");

sub update_record {
    my($package, $version, $pathname) = @_;
    warn "UPDATE: $package $version -> $pathname\n";
    my $num = eval { version->new($version)->numify };
    try {
        $insert_sth->execute($package, $version, $num, $data->{pathname});
    } catch {
        $update_sth->execute($data->{pathname}, $package, $version);
    };
}
