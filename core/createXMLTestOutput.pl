use strict;
use Time::HiRes qw(gettimeofday tv_interval);
use File::Basename;
use Text::Diff;
use HTML::Entities;

my $unnamedTestNum = 0;

sub escape {
	my ($str) = (@_);
	return HTML::Entities::encode_entities($str);
}

sub comment {
	my ($comment) = (@_);
	print "<!-- " . escape($comment) . " -->\n";
}

# use XML::Writer;

my $numArgs = $#ARGV + 1;
if ($numArgs != 3) {
	die "Not enough command line arguments"
}

my $testSuite = $ARGV[0];

# file containing the tests
my $testFile = $ARGV[1];

# file with maude's output we're checking
my $maudeResults = $ARGV[2];

my $globalTests = "";
my $globalNumPassed = 0;
my $globalNumFailed = 0; # failures are tests that ran but failed
my $globalNumError = 0; # errors are tests that didn't finish running
my $globalTotalTime = 0;

my %testMapping = getTestMapping($testFile);
my %testResults = getTestResults($maudeResults);
foreach my $testKey (keys %testMapping) {
	my $found = 0;
	my $testName = $testMapping{$testKey}[0];
	foreach my $resultKey (keys %testResults) {
		# comment "$resultKey: $testResults{$resultKey}";
		if (index($resultKey, $testKey) != -1) { # if this is the right test
			$found = 1;
			my $testTime = $testResults{$resultKey}[0];
			my $testResult = $testResults{$resultKey}[1];
			
			my $testSupposed = $testMapping{$testKey}[1];
			if (index($testResult, $testSupposed) != -1) { # if the test passed
				# return reportSuccess($fullFilename, $timer, "Success");
				reportSuccess($testName, $testTime, "Success");
			} else {
				reportFailure($testName, $testTime, "Failure");
			}
			last;
		}
	}
	if (!$found) {
		reportFailure($testName, 0, "Couldn't find matching test for $testKey");
	}
}


sub getTestMapping {
	my ($testFile) = (@_);
	my %testMapping = ();
	open(IN, "$testFile") or reportError("unknown", 0, "Couldn't open file $testFile");
	while (my $line = <IN>) {
		chomp $line;
		my $reduce = "rew|rewrite|red|reduce|erew|erewrite";
		my $pattern = "^($reduce) (.*) \\. ---@ ([^ ]*) (.*)\$";
		my $simplePattern = "^($reduce) (.*) \\.[^.]*\$";
		if ($line =~ /$pattern/) {
			if (!exists $testMapping{$2}){
				$testMapping{$2} = [$3, $4];
			} else {
				reportError("unknown", 0, "You have two identical tests.");
			}
		} elsif ($line =~ /$simplePattern/) {
			if (!exists $testMapping{$2}){
				$testMapping{$2} = ["unnamedTest$unnamedTestNum", ""];
				$unnamedTestNum++;
			} else {
				reportError("unknown", 0, "You have two identical tests.");
			}
		}
	}
	close(IN);
	return %testMapping;
}

sub getTestResults {
	my ($resultFile) = (@_);
	my %resultMapping = ();
	open(IN, "$resultFile") or reportError("unknown", 0, "Couldn't open file $resultFile");
	while (my $line = <IN>) {
		chomp $line;
		my $time = 0;
		my $reduce = "rewrite|reduce|erewrite";
		my $pattern = "^($reduce) in .* : (.*) \.\$";
		if ($line =~ /$pattern/) {
			my $inputTerm = $2;
			# comment "found $inputTerm";
			$line = <IN>; # skip rewrites: line
			if ($line =~ /^rewrites: .* in .*ms cpu \((.*)ms real\)/) {
				my $time = $1;
			} else {
				reportError("unknown", 0, "Error parsing, couldn't find # rewrites for $inputTerm");
			}
			$line = <IN>;
			if ($line =~ /^result .*: (.*)$/) {
				my $outputTerm = $1;
				$resultMapping{$inputTerm} = [$time, $outputTerm];
			} else {
				reportError("unknown", 0, "Error parsing, couldn't find result for $inputTerm");
			}
		}
	}
	close(IN);
	return %resultMapping;
}

# my @files = <$directory/*>;
# foreach my $fullFilename (@files) {
	# my ($baseFilename, $dirname, $suffix) = fileparse($fullFilename,".c");
	# if ($suffix ne '.c') {next;}
	# my $filename = "$baseFilename$suffix";
	# performTest($dirname, $baseFilename);
# } 
# open(OUT, ">$outputFilename"); #open for write, overwrite
print "<?xml version='1.0' encoding='UTF-8' ?>\n";
print "<testsuite name='$testSuite' time='$globalTotalTime'>\n";
print "$globalTests";
print "</testsuite>\n";

# sub performTest {
	# my ($dirname, $baseFilename) = (@_);
	# my $fullFilename = "$dirname$baseFilename.c";
	# #print "dirname=$dirname\n";
	# #print "baseFilename=$baseFilename\n";
	# my $kccFilename = "${dirname}test-$baseFilename.kcc";
	# my $gccFilename = "${dirname}test-$baseFilename.gcc";
	
	# my $timer = [gettimeofday];
	
	# my $kccCompileOutput = `$kcc -o $kccFilename $fullFilename 2>&1`;
	# my $kccCompileRetval = $?;
	# if ($kccCompileRetval) {
		# if ($shouldFail) {
			# return reportSuccess($fullFilename, $timer, "Success---didn't compile with kcc");
		# } else {
			# return reportFailure($fullFilename, $timer, "Failure---kcc failed to compile $fullFilename.\n\n$kccCompileOutput");
		# }
	# }
	
	# my $gccCompileOutput = `$gcc -o $gccFilename $fullFilename 2>&1`;
	# my $gccCompileRetval = $?;
	# if ($gccCompileRetval) {
		# if (!$shouldFail) {
			# return reportError($fullFilename, $timer, "gcc failed to compile $fullFilename.\n\n$gccCompileOutput");
		# }
	# }
	
	# my $kccRunOutput = `$kccFilename 2>&1`;
	# $kccRunOutput =~ s/^VOLATILE.*//mg;
	# my $kccRunRetval = $?;
	# if ($shouldFail) {
		# if (index($kccRunOutput, "unfinishedComputation") == -1) {
			# my $encodedOut = HTML::Entities::encode_entities($kccRunOutput);
			# return reportFailure($fullFilename, $timer, "Failure---Program seemed to run to completion\n$encodedOut\n");
		# } else {
			# return reportSuccess($fullFilename, $timer, "Success---Core dumped");
		# }
	# }
		
	# my $gccRunOutput = `$gccFilename 2>&1`;
	# $gccRunOutput =~ s/^VOLATILE.*//mg;
	# # print $gccRunOutput;
	# my $gccRunRetval = $?;
	# if (($kccRunRetval != $gccRunRetval) || ($kccRunOutput ne $gccRunOutput)) {
		# my $msg = "Return values were not identical.\n";
		# $msg .= "kcc retval=$kccRunRetval\n";
		# $msg .= "gcc retval=$gccRunRetval\n";
		# if ($kccRunOutput ne $gccRunOutput) {
			# $msg .= "Outputs were not identical.\n";
			# my $diff = diff(\$gccRunOutput, \$kccRunOutput, { STYLE => "Unified" });
			# my $encodedDiff = HTML::Entities::encode_entities($diff);
			# # my $text = new XML::Code('=');
			# # $text->set_text($diff);
			# $msg .= "-----------------------------------------------\n";
			# $msg .= "$encodedDiff\n";
			# $msg .= "-----------------------------------------------\n";
			# #$msg .= "(actual output elided)\n";
		# }
		# return reportFailure($fullFilename, $timer, $msg);
	# }
	
	# return reportSuccess($fullFilename, $timer, "Success");
# }

sub reportFailure {
	my ($name, $timer, $message) = (@_);
	$globalNumFailed++;
	$message = escape($message);
	my $inner = "<failure>$message</failure>";
	#comment "$name failed";
	return reportAny($name, $timer, $inner);	
}
sub reportError {
	my ($name, $timer, $message) = (@_);
	$globalNumError++;
	$message = escape($message);
	my $inner = "<error>$message</error>";
	#comment "$name errored";
	return reportAny($name, $timer, $inner);	
}
sub reportSuccess {
	my ($name, $timer, $message) = (@_);
	$globalNumPassed++;
	$message = escape($message);
	my $inner = "$message";
	#comment "$name passed";
	return reportAny($name, $timer, $inner);	
}


sub reportAny {
	my ($name, $time, $inner) = (@_);
	#my $elapsed = tv_interval( $timer, [gettimeofday]);
	#$globalTotalTime += $elapsed;
	$globalTests .= "\t<testcase name='$name' time='$time'>\n";
	#$globalTests .= "\t\t<measurement><name>Time</name><value>$time</value></measurement>\n";
	$globalTests .= "\t\t$inner\n";
	$globalTests .= "\t</testcase>\n";
}
#@diff -y --suppress-common-lines -I '^VOLATILE' $+


# output-%: test-%
	# @echo "Running $< ..."
	# @trap "" SIGABRT; $(COMMAND_PREFIX) ./$< 2>&1 > $@.tmp; RETURN_VALUE=$$?; echo $$RETURN_VALUE >> $@.tmp
	# @mv $@.tmp $@
	
	
  # <testcase classname="net.cars.engine.PistonTest" name="moveUp" time="0.022">
    # <error message="test timed out after 1 milliseconds" type="java.lang.Exception">java.lang.Exception: test timed out after 1 milliseconds
# </error>
  # </testcase>
  # <testcase classname="net.cars.engine.PistonTest" name="moveDown" time="0.0010" />
  # <testcase classname="net.cars.engine.PistonTest" name="checkStatus" time="0.0030">
    # <failure message="Plunger status invalid to proceed driving." type="junit.framework.AssertionFailedError">junit.framework.AssertionFailedError: Plunger status invalid to proceed driving.
	# at net.cars.engine.PistonTest.checkStatus(PistonTest.java:42)
# </failure>
  # </testcase>
  # <testcase classname="net.cars.engine.PistonTest" name="checkSpeed" time="0.0080">
    # <failure message="Plunger upward speed below specifications." type="junit.framework.AssertionFailedError">junit.framework.AssertionFailedError: Plunger upward speed below specifications.
	# at net.cars.engine.PistonTest.checkSpeed(PistonTest.java:47)
# </failure>
  # </testcase>
  # <testcase classname="net.cars.engine.PistonTest" name="lubricate" time="0.0030">
    # <failure message="Failed to lubricate the plunger." type="junit.framework.AssertionFailedError">junit.framework.AssertionFailedError: Failed to lubricate the plunger.
	# at net.cars.engine.PistonTest.lubricate(PistonTest.java:52)
# </failure>
  # </testcase>
