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
      grab unless grabbed?
      self
    end

    private def grab
      update_attribute :raw_data, libraries_io_data.symbolize_keys
    end

    def raw_data=(data)
      super
      assign_attributes(process_raw_data(**data))
    end

    private def process_raw_data(**)
      # Override if need to use raw_data
      {}
    end

    private def api
      CivicDuty.libraries_io_api
    end
  end
end
