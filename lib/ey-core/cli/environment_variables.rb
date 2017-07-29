require 'ey-core/cli/subcommand'
require 'ey-core/cli/helpers/stream_printer'

module Ey
  module Core
    module Cli
      class EnvironmentVariables < Subcommand
        include Ey::Core::Cli::Helpers::StreamPrinter
        title "environment_variables"
        summary "Retrieve a list of Engine Yard environment variables for environments that you have access to."

        option :environment,
          short: 'e',
          long: 'environment',
          description: 'Filter by environmeent name or id',
          argument: 'Environment'

        option :application,
          short: 'a',
          long: 'application',
          description: 'Filter by application name or id',
          argument: 'Application'

        def handle
          environment_variables = if option(:application)
                                    core_applications(option(:application)).flat_map(&:environment_variables)
                                  elsif option(:environment)
                                    core_environments(option(:environment)).flat_map(&:environment_variables)
                                  else
                                    core_environment_variables
                                  end

          stream_print("ID" => 10, "Name" => 30, "Value" => 50, "Environment" => 30, "Application" => 30) do |printer|
            environment_variables.each_entry do |ev|
              printer.print(ev.id, ev.name, ev.value, ev.environment_name, ev.application_name)
            end
          end
        end

      end
    end
  end
end
