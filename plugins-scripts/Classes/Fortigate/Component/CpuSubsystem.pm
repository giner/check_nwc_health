package Classes::Fortigate::Component::CpuSubsystem;
our @ISA = qw(Classes::Fortigate);
use strict;
use constant { OK => 0, WARNING => 1, CRITICAL => 2, UNKNOWN => 3 };

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  $self->init();
  return $self;
}

sub init {
  my $self = shift;
  my %params = @_;
  my $type = 0;
  $self->get_snmp_objects('FORTINET-FORTIGATE-MIB', (qw(
      fgSysCpuUsage)));
}

sub check {
  my $self = shift;
  my $errorfound = 0;
  $self->add_info('checking cpus');
  $self->blacklist('c', undef);
  my $info = sprintf 'cpu usage is %.2f%%', $self->{fgSysCpuUsage};
  $self->add_info($info);
  $self->set_thresholds(warning => 80, critical => 90);
  $self->add_message($self->check_thresholds($self->{fgSysCpuUsage}), $info);
  $self->add_perfdata(
      label => 'cpu_usage',
      value => $self->{fgSysCpuUsage},
      uom => '%',
      warning => $self->{warning},
      critical => $self->{critical},
  );
}

sub dump {
  my $self = shift;
  printf "[CPU]\n";
  foreach (qw(fgSysCpuUsage)) {
    printf "%s: %s\n", $_, $self->{$_};
  }
  printf "info: %s\n", $self->{info};
  printf "\n";
}
