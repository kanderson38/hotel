
require_relative "csv_record"
require_relative "room"

module HotelGroup
  class Reservation < CsvRecord
    attr_accessor :id, :room, :start_time, :end_time, :block_reservation

    def initialize(id, start_time, end_time, room)
      if (start_time <=> end_time) == 1
        raise ArgumentError, "End time must be later than start time"
      end

      @start_time = start_time
      @end_time = end_time
      @room = room
      @id = id
      @block_reservation = false
    end

    def total_price
      number_of_days = end_time - start_time
      if block_reservation
        price = room.block_price
      else
        price = room.price
      end
      return "Total price for reservation #{id}: $#{format("%.2f", price * number_of_days)}"
    end

    def includes_date?(date)
      return start_time <= date && end_time >= date
    end

    def overlap?(start_date, end_date)
      return (start_time...end_time).include?(start_date) || (start_time + 1..end_time).include?(end_date) ||
               (start_date...end_date).include?(start_time) ||
               (start_date + 1..end_date).include?(end_time)
    end

    def print_nicely
      if self.id
        return "Reservation #{id}: Room #{room.number} from #{start_time} to #{end_time}. #{total_price}"
      else
        return "Reservation not found"
      end
    end

    def connect(room_obj)
      @room = room_obj
      return self
    end

    private

    def self.from_csv(record)
      return self.new(
               record[:id],
               Date.parse(record[:start_date]),
               Date.parse(record[:end_date]),
               record[:room],
             )
    end

    def self.save(full_path, all_reservations)
      CSV.open(full_path, "w") do |file|
        header_row = ["id", "start_date", "end_date", "room"]
        file << header_row
        all_reservations.each do |r|
          start_date = "#{r.start_time.year}-#{r.start_time.month}-#{r.start_time.day}"

          end_date = "#{r.end_time.year}-#{r.end_time.month}-#{r.end_time.day}"

          room_string = "#{r.room.number}"

          new_line = ["#{r.id}", "#{start_date}", "#{end_date}", "#{room_string}"]
          file << new_line
        end
      end
    end
  end
end
