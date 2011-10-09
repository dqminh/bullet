require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "yaml"

shared_examples "a bullet" do
  let(:capacity) { 2 }

  subject do
    described_class.new(:machines => machines, :guns => capacity)
  end

  describe :fire do
    it "spawns correct number of threads" do
      bullets = ["first", "second"]
      subject.specs = bullets
      Parallel.expects(:map).with(bullets, :in_threads => capacity)
      subject.fire
    end

    it "executes loaded specs" do
      bullets = ["first", "second"]
      subject.specs = bullets
      Bullet::BulletClient.any_instance.stubs(:execute).returns("hello")
      subject.fire.should == ["hello"] * bullets.length
    end

    it "unloads after fire" do
      bullets = ["first", "second"]
      subject.specs = bullets
      Bullet::BulletClient.any_instance.stubs(:execute).returns(true)
      subject.fire
      subject.specs.should have(0).bullets
    end
  end
end

describe Bullet::BulletClient do
  subject { Bullet::BulletClient.new() }

  describe :unload do
    it "drops all collected specs and plan_list" do
      subject.plan_list = {"hello" => 1}
      subject.specs = ["test"]
      subject.unload
      subject.specs.should have(0).spec
    end
  end

  describe :load do
    it "collect plans" do
      subject.load("dummy_bullet.yml")
      subject.plan_list.should eq({"github" => {
        "user" => {"register" => 10},
        "admin" => {"create_user" => 20}
      }})
    end
  end
  
  describe :aim do
    it "choose target as the plan" do
      subject.aim("plan")
      subject.plan.should == "plan"
    end
  end

  describe :prepare do
    it "calculates path to specs" do
      subject.plan_list = {"normal" => {"user" => {"signin" => 1, "register" => 2}}}
      subject.plan = "normal"
      expected = ["user_signin", "user_register", "user_register"]
      subject.prepare
      (subject.specs.flatten - expected).should be_empty
    end

    it "distribute specs to machines" do
      subject.plan_list = {"normal" => {"user" => {"signin" => 1, "register" => 2}}}
      subject.plan = "normal"
      subject.machines = 2
      subject.prepare
      subject.specs.should have(2).sets
    end
  end

  describe :ready? do
    it "verifies that specs exists" do
      subject.specs = [["hello"]]
      subject.ready?.should be_true
    end
  end

  describe :use do
    it "accept the path as look up path" do
      subject.use("hello")
      subject.spec_path.should == "hello"
    end
  end

  context "with threads" do
    it_behaves_like "a bullet" do
      let(:machines) { 2 }
    end
  end

  context "with processes" do
    it_behaves_like "a bullet" do
      let(:machines) { 2 }
    end
  end
end
