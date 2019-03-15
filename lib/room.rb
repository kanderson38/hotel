require_relative "reservation"
require_relative "csv_record"

module HotelGroup
  class Room < CsvRecord
    attr_accessor :number, :price, :reservations, :unavailable_dates, :blocks

    def initialize(number, price)
      @number = number
      @price = price
      @unavailable_dates = []
      @reservations = []
      @blocks = []
    end

    def self.make_rooms_list(number, price)
      rooms = []
      number.times do |n|
        room = Room.new(n + 1, price)

        rooms << room
      end
      return rooms
    end

    def add_reservation(res)
      if has_reservation?(res.start_time, res.end_time)
        raise ArgumentError, "Room #{number} is already reserved for this date range"
      end
      reservations << res
      unavailable_dates << [res.start_time, res.end_time]
    end

    def is_available?(start_time, end_time)
      if unavailable_dates == []
        return true
      end
      unavailable_dates.each do |date_array|
        # if !(date_array[0] >= end_time || date_array[1] <= start_time)
        res_start = date_array[0]
        res_end = date_array[1]

        if (res_start...res_end).include?(start_time) || (res_start + 1..res_end).include?(end_time) ||
           (start_time...end_time).include?(res_start) ||
           (start_time + 1..end_time).include?(res_end)
          return false
        end
      end
      return true
    end

    def set_unavailable(start_time, end_time)
      unavailable_dates << [start_time, end_time]
    end

    def add_block_id(id)
      blocks << id
    end

    def apply_discount(discount)
      self.price -= self.price * discount
      return self
    end

    def has_reservation?(start_time, end_time)
      if reservations.count == 0
        return false
      end

      reservations.each do |res|
        if !(res.start_time >= end_time || res.end_time <= start_time)
          return true
        end
      end
      return false
    end

    def is_in_block?(block)
      blocks.each do |id|
        if id == block.id
          return true
        end
      end
      return false
    end

    def print_nicely
      return "Room #{number}: $#{format("%.2f", price)} per night"
    end
  end
end
