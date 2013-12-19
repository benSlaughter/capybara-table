require 'helper'

root = File.expand_path('..', __FILE__)

describe Table do
  it "is a class" do
    Table.class.should eq Class
  end

  describe ".new" do
    before(:all) do
      Capybara.run_server = false
      Capybara.default_driver = :selenium
      Capybara.current_session.driver.visit "file://" + root + "/fixtures/table.html"
    end

    it "creates a new table instance" do
      t = Table.new
      t.class.should eq Table
    end
  end
end