require "parallel"

class Bullet
  attr_accessor :use, :with, :magazine, :before_all_hooks, :after_all_hooks

  def initialize(options={})
    self.options = options
    @magazine = []
    @before_all_hooks = []
    @after_all_hooks = []
  end

  def options=(options)
    options[:use] ||= 2
    options[:with] ||= :thread
    @options = options
    @use = @options[:use]
    @with = @options[:with]
  end

  def unload
    @magazine = []
  end

  def load(patterns)
    @magazine += Dir.glob(patterns).uniq  
    self
  end

  def fire
    type = "in_#{@with}".to_sym

    @before_all_hooks.each do |hook|
      hook(@magazine)
    end unless @before_all_hooks.empty?

    Parallel.map(@magazine, type => @use) do |bullet|
      puts "hello"
    end

    @after_all_hooks.each do |hook|
      hook.call(@magazine)
    end unless @after_all_hooks.empty?
  end
end
