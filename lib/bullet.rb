require "parallel"

module Bullet
  class InvalidPlanError < Exception
  end
  class BulletClient
    attr_accessor :machines, :specs, :plan_list, :plan, :guns, :spec_path

    def initialize(options={})
      self.options = options
      @specs = []
    end

    def options=(options)
      options[:machines] ||= 2
      options[:gun] ||= 2
      @options = options
      @guns = options[:gun]
      @machines = @options[:machines]
    end

    def unload
      @specs = []
      self
    end

    def aim(plan)
      @plan = plan
      self
    end

    def use(path)
      @spec_path = path
      self
    end

    def prepare
      if @plan_list && @plan && @plan_list.has_key?(@plan)
        @specs = get_specs
        self
      else
        raise Bullet::InvalidPlanError
      end
    end

    def load(config)
      @plan_list = YAML.load(File.open(config))
      self
    end

    def fire
      unless ready?
        self.prepare
      end

      results = []
      Parallel.map(@specs, :in_threads => @guns) do |specs|
        results << self.execute(specs)
      end
      self.unload
      results
    end

    def ready?
      !@specs.empty?
    end

    private
    def get_specs
      # we assume that plan is only two level deep
      # first, get list of specs
      specs = []
      plan = @plan_list[@plan]
      plan.each_pair do |actor, spec_list|
        spec_list.each_pair do |name, value|
          value.times.each {specs << "#{actor}_#{name}"}
        end
      end

      # Then split specs to send to machines
      spec_machine_list = []
      if (specs.length / machines) < @machines && @machines < specs.length
        num_spec_per_machine = @machines
      elsif @machines > specs.length
        num_spec_per_machine = specs.length
      else
        num_spec_per_machine = specs.length / machines
      end
      while specs.length > 0
        spec_machine_list << specs.slice!(0, num_spec_per_machine)
      end

      spec_machine_list
    end

    def execute(specs)
      puts specs
    end
  end
end
