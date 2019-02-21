require 'rails_helper'

RSpec.describe "tsts/show", type: :view do
  before(:each) do
    @test = assign(:test, create(:tst))
  end

  it "renders" do
    render
  end
end
