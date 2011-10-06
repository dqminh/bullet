require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples "a bullet" do
  let(:process) { "in_#{bullet_type}".to_sym }
  subject do
    described_class.new(:use => capacity, :with => bullet_type)
  end

  describe :fire do
    it "spawns correct number of threads" do
      bullets = ["first", "second"]
      subject.magazine = bullets
      Parallel.expects(:map).with(bullets, process => capacity)
      subject.fire
    end

    #it "triggers :before_all" do
      #bullets = ["first", "second"]
      #mock.expects(["first", "second"])
      #subject.before_all_hooks = [mock]
      #subject.fire
    #end

    #it "triggers :after_all" do
      #bullets = ["first", "second"]
      #mock = double("after_all")
      #mock.should_receive(["first", "second"])
      #subject.after_all_hooks = [mock]
      #subject.fire
    #end

    it "executes loaded bullets" do
    end
  end
end

describe Bullet do
  subject { Bullet.new() }

  describe :unload do
    it "drops all collected bullets" do
      subject.magazine = ["test"]
      subject.unload
      subject.magazine.should have(0).bullet
    end
  end

  describe :load do
    it "collect bullets" do
      subject.load("dummy/*.rb")
      num_bullets = Dir.entries("dummy").length - 2
      subject.magazine.should have(num_bullets).bullet
    end

    it "respects dir pattern" do
      subject.load("dummy/simple*.rb")
      subject.magazine.should have(1).bullet
    end

    it "accepts list of patterns" do
      subject.load(["dummy/simple.rb", "dummy/complex.rb"])
      subject.magazine.should have(2).bullet
    end
  end

  context "with threads" do
    it_behaves_like "a bullet" do
      let(:bullet_type) { :threads }
      let(:capacity) { 2 }
    end
  end

  context "with processes" do
    it_behaves_like "a bullet" do
      let(:bullet_type) { :processes }
      let(:capacity) { 2 }
    end
  end
end
