require_relative "spec_helper"

describe "HotelBlock class" do
  before do
    @room1 = Room.new(1, 200)
    @room2 = Room.new(2, 200)
    @room3 = Room.new(3, 200)

    @start_time = Date.new(2019, 3, 4)
    @end_time = Date.new(2019, 3, 7)

    @hotel_block = HotelBlock.new(2, @start_time, @end_time, [@room1, @room2, @room3])
  end
  describe "initialize" do
    it "returns a HotelBlock object" do
      expect(@hotel_block).must_be_instance_of HotelBlock
    end

    it "makes a hash with rooms as keys and :AVAILABLE as default values" do
      expect(@hotel_block.rooms[@room1]).must_equal :AVAILABLE
    end

    it "sets the discount to 20%" do
      expect(@hotel_block.rooms.keys[0].price).must_equal 160
    end

    it "returns an error if the number of rooms > 5" do
      expect { HotelBlock.new(1, @start_time, @end_time, [@room1, @room2, @room3, @room1, @room2, @room3]) }.must_raise ArgumentError
    end
  end

  describe "prints itself nicely" do
    it "prints itself nicely" do
      expect(@hotel_block.print_nicely).must_equal "Block 2: Room 1: AVAILABLE Room 2: AVAILABLE Room 3: AVAILABLE "
    end
  end
end