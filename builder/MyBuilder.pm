use Object::Pad ':experimental(:all)';

package builder::MyBuilder;
class builder::MyBuilder :isa(Module::Build::XSUtil);

use utf8;
use v5.40;

use base 'Module::Build::XSUtil';

use Const::Fast;
const our $DEBUG => 1;

method $on_new : common ($params) {
  my @ignore_warnings_options
      = map { "-Wno-$_" } qw(missing-field-initializers
                             register
                             misleading-indentdation);

  my $self = $class->new(
        %$params,
        generate_ppport_h    => 'include/ppport.h',
        needs_compiler_cpp   => 1,
        c_source => [qw/src/],
        xs_files => { 'src/Compiler-Lexer.xs' => 'lib/Compiler/Lexer.xs' },
        cc_warnings => 0, # TODO
        extra_compiler_flags => ['-Iinclude', @ignore_warnings_options, '-g3'],
        add_to_cleanup => [
            'lib/Compiler/Lexer/*.o', 'lib/Compiler/Lexer/*.c',
            'lib/Compiler/Lexer/*.xs'
        ]
  );

  $self->{config}->set('optimize' => '-O0') if $DEBUG;

  $self 
};


ADJUSTPARAMS ($params) {
  __CLASS__->$on_new($params)
};


