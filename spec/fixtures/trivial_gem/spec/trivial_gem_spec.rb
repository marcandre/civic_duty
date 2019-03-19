require "spec_helper"

describe TrivialGem do
  it "has a version number" do
    expect(TrivialGem::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(TrivialGem.hello).to eq(:world)
  end

  it "runs a bunch of branches" do
    expect(TrivialGem.branches(1)).to eq(1)
  end

  it "loads a bunch of constants" do
    expect(TrivialGem::BAR).to eq(42)
    expect(TrivialGem::BAR).to eq(666)
    expect(TrivialGem::JSON).to be_instance_of(Class)
  end
end
