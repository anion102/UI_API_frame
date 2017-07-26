module AppArgParser

  # parse the debug command line options
  # A way of getting the debug command options while leaving ARGV for Test::Unit
  # so you can enable debug with a filter AND give Test::Unit a
  # test name to run:
  #   mytest.rb -d -F filterStr -n aTest
  $_app_args_info = {
    :debug                    => false,
    :debug_filter             => '',
    :debug_trace_level        => 1,
    :dev_mode                 => false,
    :xml_dev_mode             => false,
    :log_to_file              => false,
    :log_to_file_only         => false,
    :repro                    => false,
    :env                      => nil,
    :http_soap_test           => nil,
    :dev_flag                 => false,
    :dev_flag_val             => '',
    :submit                   => false,
    :message                  => '',
    :no_setup                 => false,
    :slow_speed               => false,
    :save_to_csv              => false,
    :firebug_mode             => false,
    :firebug_javascript_mode  => false,
    :no_firefox_proxy_mode    => false,
    :pune_proxy_mode          => false,
    :error_screenshot         => false,
    :no_teardown              => false,
  }

  krw_args = []
  krw_args_help = {}
  # each arg do
  # ARGV is the array of command line args
  ARGV.each_with_index do |arg, i|
      #puts "arg #{arg}"

      # Enables firebug in the Firefox browser.
      option = '-es'
      if arg == option
        krw_args << option
        $_app_args_info[:error_screenshot] = true
      end
      krw_args_help[option] = [
               "Will generate a screenshot whenever there is a test error",
               "and deposit in the following directory: app_tests/test_output/screenshots",
      ]

      # Enables firebug in the Firefox browser.
      option = '-fb'
      if arg == option
        krw_args << option
        $_app_args_info[:firebug_mode] = true
      end
      krw_args_help[option] = [
               "This requires the following xpi file in this location: \"C:/firebug-1.9.2-fx.xpi\"",
               "As well as the directory \"C:/firebug_output\"",
      ]

      # Essentially the same as commenting out the standard_teardown method.
      option = '-nt'
      if arg == option
        krw_args << option
        $_app_args_info[:no_teardown] = true
      end
      krw_args_help[option] = [
               "When set to true, the standard_teardown will not log out or close the browser at the end of the test.",
      ]

      # Enables firebug in the Firefox browser with javascript debugging enabled.
      option = '-fbj'
      if arg == option
        krw_args << option
        $_app_args_info[:firebug_javascript_mode] = true
      end
      krw_args_help[option] = [
               "This requires the following xpi file in this location: \"C:/firebug-1.9.2-fx.xpi\"",
               "As well as the directory \"C:/firebug_output\"",
      ]

      # Sets the proxy settings in Firefox to "No proxy" in the
      # "Tools/Options/Network/Connection" settings in Firefox.
      option = '-np'
      if arg == option
        krw_args << option
        $_app_args_info[:no_firefox_proxy_mode] = true
      end
      krw_args_help[option] = [
               "Sets the proxy settings in Firefox to \"No proxy\" in the",
               "\"Tools/Options/Network/Connection\" settings in Firefox",
      ]

      # Sets the proxy settings in Firefox to a specific "pune proxy" in the
      # "Tools/Options/Network/Connection" settings in Firefox.
      option = '-pp'
      if arg == option
        krw_args << option
        $_app_args_info[:pune_proxy_mode] = true
      end
      krw_args_help[option] = [
               "Sets the proxy settings in Firefox to \"Pune proxy\" in the",
               "\"Tools/Options/Network/Connection\" settings in Firefox",
      ]

      # debug
      option = '-z' 
      if arg =~ /-z/
        krw_args << option
        $_app_args_info[:debug] = true
        if arg =~ /-z(\d)/
          $_app_args_info[:debug_trace_level] = $1.to_i
          krw_args << "#{option}#{$1}"
        end
      end

      krw_args_help[option] = [
               "debug - calls to krw_debug will be output"
      ]

      # debug filter
      option = '-F'
      if arg == option
        krw_args << option
        # error if no value
        # check for no next value (not ARGV[i+1]) or that the next value
        # is not the next switch, that is a '-' (ARGV[i+1][0]==45) 
        # BTW: 45 is the ascii code for '-'
        # Valid: 
        #   -F val -D
        #   -F val
        # Not valid:
        #   -F
        #   -F -D
        if not ARGV[i+1] or ARGV[i+1][0]==45
          puts 'ERROR: -F, (filter) requires an argument' 
        else
          krw_args << ARGV[i+1]
          $_app_args_info[:debug_filter] = ARGV[i+1]
        end
      end
      krw_args_help["#{option} FILTER_STR"] = [
               "debug filter - requires arg 'filter_string'",
               "- Use with -d debug option",
               "- Only debug messages that contain 'filter_string' are output",
               "Usage:",
               "  TC_test -d -F method_name (only output debug from method_name)",
               "  TC_test -d -F line_number (only output debug from line_number)",
               "  TC_test -d -F a_str (only output debug that includes a_str)",
      ]

      # set the environment for testing in the command line
      option = '-e'
      if arg == option
        krw_args << option
        # error if no value
        if not ARGV[i+1] or ARGV[i+1][0]==45
          raise 'ERROR: -e, (environment) requires an argument' 
        else
          krw_args << ARGV[i+1]
          $_app_args_info[:env] = ARGV[i+1]
        end
      end
      krw_args_help["#{option} ENV_NAME"] = [
               "Set the environment name instead of using the ruby_tests.yaml_config",
               "file",
               "Usage:",
               "  TC_test -e cqa1",
      ]

      # dev mode
      option = '-D'
      if arg =~ /#{option}(.*)/
        krw_args << option + $1
        $_app_args_info[:dev_mode] = true
        dev_flag_val = $1
        case dev_flag_val
          when 'f'
          # debug flag to use when developing tests
          # access with method dev_flag?
          $_app_args_info[:dev_flag] = true
        else
          $_app_args_info[:dev_flag_val] = dev_flag_val

        end
        
      end
      krw_args_help[option] = [
               "Dev mode",
               "Under dev mode the test will attach to an open instance of IE",
               "and will not log out when the test stops.",
      ]

      # Send API http requests to soap test page 
      option = '-hs'
      if arg == option
        krw_args << option
        $_app_args_info[:http_soap_test] = true
      end
      krw_args_help[option] = [
               "Change HTTP requests to SOAP test page requests",
               "Use this when developing tests so that the SOAP HTTP requests",
               "will use the SOAP test page.",
      ]

      # xml dev mode - this allows the option of copying the actual XML
      # to the expected in XML comparisons
      option = '-X'
      if arg == option
        krw_args << option
        # will prompt to copy actual XML to expected
        $_app_args_info[:xml_dev_mode] = :prompt
      end
      krw_args_help[option] = [
               "XML dev mode",
               "If there are failed XML diffs you will be prompted to copy the",
               "actual XML to the expected. Use with caution - ensure all the",
               "discrepencies are expected.",
      ]

      option = '-XX'
      if arg == option
        krw_args << option
        # will not prompt to copy actual XML to expected - use this for multiple
        # actual XML overwrites
        $_app_args_info[:xml_dev_mode] = :no_prompt
      end
      krw_args_help[option] = [
               "XML dev mode expert",
               "Same as -X XML dev mode, but you will not pe prompted. Use with",
               "extreme caution",
      ]

      # log to file
      option = '-lf'
      if arg == option
        $_app_args_info[:log_to_file] = true
        krw_args << option
      end
      krw_args_help[option] = [
               "Log to file",
               "All console logging is directed to timestamped log files in the",
               "krw_logs dir.",
      ]
      
      # log to file and not console
      option = '-lfo'
      if arg == option
        $_app_args_info[:log_to_file_only] = true
        $_app_args_info[:log_to_file] = true
        krw_args << option
      end
      krw_args_help[option] = [
               "Log to file only",
               "Similar to -lf Log to file, expect there will be no logging to",
               "the console",
      ]

      # Repro step mode - some tests will output repro steps upon a fail
      option = '-R'
      if arg == option
        krw_args << option
        $_app_args_info[:repro] = true
      end
      krw_args_help[option] = [
               "Repro step mode",
               "Some tests will give repro steps in the log output.",
      ]

      # output http submit debug - the xml request and response
      option = '-submit'
      if arg == option
        krw_args << option
        $_app_args_info[:submit] = true
        $_app_args_info[:debug] = true
        $_app_args_info[:debug_filter] = 'submit'
        
      end
      krw_args_help[option] = [
               "Output http submit debug",
               "The xml request and response.",
      ]

      # message
      option = '-m'
      if arg == option
        krw_args << option
        # error if no value
        if not ARGV[i+1] or ARGV[i+1][0]==45
          puts 'ERROR: -m, (message) requires an argument' 
        else
          krw_args << ARGV[i+1]
          $_app_args_info[:message] = ARGV[i+1]
        end
      end
      krw_args_help["#{option} MSG_STR"] = [
               "message - requires arg 'message'",
               "- Use to set a message for a test. Used with the -Df (dev_flag)",
               "    when saving actual as expected, adding a message to the ",
               "    version info: the build, '8.0MR2', for instance",
               "Usage:",
               "  TC_test -Df -m \"8.0 MR2\"",
      ]

      # nosetup - used in pricing tests to skip setup, just get the prices and compare
      # Handy when developing pricing tests so you don't have to load the page and fields each time
      option = /(-nos|-nosetup)/
      if arg =~ option
        krw_args << arg
        $_app_args_info[:no_setup] = true
        # must be dev mode to attach
        $_app_args_info[:dev_mode] = true
      end
      krw_args_help['-nosetup'] = [
               "nosetup - used in pricing tests to skip page setup, just get ",
               "the prices and compare",
      ]

      option = '-slow'
      if arg == option
        krw_args << arg
        $_app_args_info[:slow_speed] = true
      end
      krw_args_help[option] = [
               "slow_speed - set IE to run in slow speed for debugging"
      ]

      # save to csv - this allows the option of saving data to a csv
      # a report array
      option = '-CS'
      if arg == option
        krw_args << option
        $_app_args_info[:save_to_csv] = true
      end
      krw_args_help[option] = [
               "Save UI Report to CSV File",
      ]
      
      # LEAVE AT END
      option = '-h'
      if arg == option
        krw_args_help[option] = [
                 "Help",
                 "Display this help followed by  the Test::Unit help.",
        ]
        help_msg = "\nRuby Test Framework Command Line Options:"
        help_msg << "\n#{'-'*(help_msg.length-1)}\n"
        help_col = 14
        krw_args_help.sort.each do |option, help|
          help_msg << "  #{option}#{' '*(help_col-option.length)}#{help.shift}\n"
          help.each do |line|
            help_msg << "  #{' '*help_col}#{line}\n"
          end
          help_msg << "\n"
        end
        puts help_msg
      end
      

  end

  # remove our args from ARGV
  pp "krw_args: #{krw_args.join(', ')}" if $_app_args_info[:debug]
  krw_args.each {|a| ARGV.delete(a)}

  # some debugging
  if $_app_args_info[:debug]
    pp "$_app_args_info:"
    pp $_app_args_info
    pp "ARGV:"
    pp ARGV
  end

  # set log to file from a test rather than use the command line
  def set_log_to_file( bool_val=true )
    $_app_args_info[:log_to_file] = bool_val
  end

  def log_to_file?
    return $_app_args_info[:log_to_file]
  end

  def debug?
    return $_app_args_info[:debug]
  end

  def dev_mode?
    return $_app_args_info[:dev_mode]
  end
  
  def http_to_soap_test?
    return $_app_args_info[:http_soap_test]
  end

  def repro?
    return $_app_args_info[:repro]
  end

  def submit_debug?
    return $_app_args_info[:submit]
  end

  def dev_flag?
    return $_app_args_info[:dev_flag]
  end
  
  def get_dev_flag_val
    return $_app_args_info[:dev_flag_val]
  end

  def command_line_env?
    return $_app_args_info[:env]
  end

  def get_message
    return $_app_args_info[:message]
  end
  
  def get_debug_filter
    return $_app_args_info[:debug_filter]
  end

  def no_setup?
    $_app_args_info[:no_setup]
  end

  def slow_speed?
    $_app_args_info[:slow_speed]
  end
  
  def save_as_csv?
    $_app_args_info[:save_to_csv]
  end
end
