﻿module BinPacking2D
  class ExportBinding < Packing2D

    attr_reader :bins, :options, :unplaced_boxes, :group

    def initialize(bins, unplaced_boxes, group, options)
      @bins = bins
      @unplaced_boxes = unplaced_boxes
      @options = options
      @group = group
    end

    def zoom(value)
      cmm(value * 1.0)
    end
    
    def dim(value)
      str = cu(value)
      str.sub(/\"/, '&#34;') # when displaying units in inches!
      str.sub(/\'/, '&#39;') # when displaying units in feet!
    end

    def get_binding
      binding
    end
  end
end
