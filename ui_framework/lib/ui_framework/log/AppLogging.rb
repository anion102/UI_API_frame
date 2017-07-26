require_relative 'AppArgParser'
include AppArgParser

module AppLogging
  attr_reader :dev_mode
  @dev_mode = false

  # overrides the debug method in AlcLoggingDebug.rb that is conditionally required
  def app_debug( a, b=nil )
  end

  # conditionally require the debug logging functionality
  if $_app_args_info[:debug]
    require 'source/core/AppLoggingDebug.rb'
  end

  # set debug from a test rather than use the command line
  def set_debug( bool_val=true )
    $_app_args_info[:debug] = bool_val
  end

  # Print a formatted error message
  # Similar to the app_debug method but has no filtering
  # Use to give error messages to the console
  def app_error(str, calls=5)
    format_msg('APP_ERROR: ', str, calls, print_calls=true)
  end

  # Print a formatted warning message
  def app_warn(str, calls=1)
    format_msg('APP_WARNING: ', str, calls, print_calls=true)
  end

  # Print a formatted info message
  def app_info(str, calls=0)
    format_msg('APP_INFO: ', str, calls, print_calls=true )
  end
  
  # Pretty prints an object
  def app_pretty_print(obj)
    pp obj
  end
  
  # return a formatted message for printing in asserts or exception handlers
  def get_app_errorR(str)
    'APP_ERROR: ' + str
  end

  # return a formatted message for printing in asserts or exception handlers
  def get_app_warn(str)
    'APP_WARNING: ' + str
  end

  # return a formatted message for printing in asserts or exception handlers
  def get_app_info(str)
    'APP_INFO: ' + str
  end

  # use this for a simple puts - all logging actually goes through here
  def app_puts(str)
    puts str 
  end

  def app_repro(thing)
    if repro?
      if thing.class == String
          app_output thing
      else
          pp thing
      end
    end
  end

  # format an error, warning or info message - print call trace if desired
  def format_msg(msg_type, str, calls=1, print_calls=false)
    out_str = ""
    out_str += "#{caller[1, calls].join("\n")}"  if print_calls
    out_str += "\n#{msg_type}#{str}"
    app_output out_str
  end

  def app_output( str )
    # always log to console
    app_puts str unless $_app_args_info[:log_to_file_only]
    # log to file? 
    if $_app_args_info[:log_to_file]
      # set the log file if logging to file
      if not $app_log_file
        set_log_file 
      end
      $app_log_file.puts str
    end
  end

  def set_log_file
    log_file_name = Time.new.strftime('%m_%d_%H_%M_%S_app.log')
    log_file_dir = get_log_file_dir
    @log_file_name = log_file_dir + log_file_name
    
    $app_log_file = open_log_file( log_file_dir, @log_file_name )
    puts "View APP log output here: #{@log_file_name}"
  end
  
  def open_log_file( dir, file_name )
    begin
      file = File.open(file_name, 'w')
    rescue Errno::ENOENT
      Dir.mkdir(dir)
      retry
    end
    return file
    
  end
  
  def get_log_file_dir
    base = Utils::BASE_PATH
    if base =~ /\\/
      # windows
      log_file_dir = "#{base}\\\\test_output\\\\app_logs\\\\"
    else
  
   # linux
      log_file_dir = "#{base}/test_output/app_logs/"
    end
    return log_file_dir
  end




end

