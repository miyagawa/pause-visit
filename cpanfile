requires 'Path::Tiny';
requires 'CPAN::DistnameInfo';
requires 'JSON';
requires 'File::pushd';
requires 'Try::Tiny';
requires 'CPAN::Meta::Requirements';

feature 'index_db' => sub {
    requires 'DBI';
    requires 'DBD::SQLite';
};
