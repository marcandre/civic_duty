module CivicDuty
  module Grabbable
    # Assumes:
    #  * a column named `raw_data`
    #  * implemention for: libraries_io_data

    def self.included(base)
      base.serialize :raw_data
    end

    def grabbed?
      !!raw_data
    end

    def grabbed
      begin
        grab unless grabbed?
      rescue TLAW::API::Error => e
        CivicDuty.log e
      end
      self
    end

    private def grab
      CivicDuty.log "Grabbing #{self}"
      update_attribute :raw_data, libraries_io_data.symbolize_keys
    end

    def raw_data=(data)
      super
      assign_attributes(process_raw_data(**data)) if data
    end

    private def process_raw_data(**values)
      values.slice(*self.class.column_names.map(&:to_sym))
    end

    private def api
      CivicDuty.libraries_io_api
    end
  end
end
