package builder::MyBuilder;

use utf8;
use 5.010001;
use parent 'Module::Build::XSUtil';
use warnings FATAL => 'all';
use feature 'signatures';

use constant DEBUG => $ENV{DEBUG} // undef;

sub new ( $class, %args ) {
    my @ignore_warnings_options =
      map { "-Wno-$_" } qw(missing-field-initializers register);

    my $self = $class->SUPER::new(
        %args,
        generate_ppport_h  => 'include/ppport.h',
        needs_compiler_cpp => 1,
        c_source           => [qw/src/],
        xs_files => { 'src/Compiler-Lexer.xs' => 'lib/Compiler/Lexer.xs' },
        cc_warnings          => 0,    # TODO
        extra_compiler_flags =>
          [ '-Iinclude', @ignore_warnings_options, '-g3' ],
        add_to_cleanup => [
            'lib/Compiler/Lexer/*.o', 'lib/Compiler/Lexer/*.c',
            'lib/Compiler/Lexer/*.xs'
        ]
    );

    $self->{config}->set( 'optimize' => '-O0' ) if DEBUG;
    $self;
}

1
