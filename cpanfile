requires 'Text::Diff::Parser';
requires 'Path::Tiny';
requires 'CPAN::DistnameInfo';
requires 'JSON';
requires 'File::pushd';
requires 'Try::Tiny';

feature 'index_db' => sub {
    requires 'DBI';
    requires 'DBD::SQLite';
};
