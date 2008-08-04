# Simple invoice example.
# Copyright August 2008, Gregory Brown (gregory.t.brown@gmail.com).
# All rights reserved. 
# -----------------------
#
# Things Prawn could do to make this job easier:     
#
#    * allow setting cell height via Cell#new and Document#cell()
#    * position y cursor directly at the bottom of the cell after rendering
#    * calculate text width with respect to line breaks. 
#    * Table could right-align numbers and left-align strings by default

require "rubygems"

gem "prawn", "=0.1.0"    
require "prawn"  

class Invoice < Prawn::Document 
  def initialize(options={})
     @sender     = options[:sender]
     @recipient  = options[:recipient]
     @period     = options[:period]
     @due        = options[:due]   
     @email      = options[:email] || "gregory.t.brown@gmail.com"
     @entries    = []    
     super()
  end               
  
  def entry(description,options={})
    @entries << [description, options[:hours], options[:rate]]
  end  
  
  def total        
    sum = @entries.inject(0) { |s,r| s + r[1] * r[2] }  
    "$ %0.2f" % sum  
  end      
  
  def draw_invoice         
    font "Times-Roman"     
    draw_sender     
    draw_recipient          
    
    bounding_box([bounds.right - 210, bounds.top]) do   
      draw_work_done
      move_down(5)
      draw_billing_info
    end
    
    move_down 100
           
    pad(10) do 
      text "Work Period Details", :align => :center, :size => 16
    end
    
    table @entries,
      :position   => :center,
      :headers    => ["Description","Hours","Rate"],
      :row_colors => :pdf_writer,
      :vertical_padding => 2,
      :widths => { 0 => 200, 1 => 100, 2 => 100 }  
    
    pad(5) do      
      table [["Total Due: #{total}"]],
        :position   => :center,
        :align      => :right,
        :vertical_padding => 2,
        :row_colors => ["ffff40"]   
     end    
     
     self.y = bounds.bottom + 20
     stroke_horizontal_line bounds.left, bounds.right
     text "Please feel free to email #{@email} with any problems.", :at => [0,0]
  end   

  def draw_sender
    cell bounds.top_left, 
      :text    => @sender,  
      :horizontal_padding => 10,
      :vertical_padding   => 5,
      :width   => 150
  end    
         
  def draw_recipient
    cell [bounds.left, bounds.top - 60],
      :text    => @recipient,
      :horizontal_padding => 10,
      :vertical_padding   => 5,
      :width   => 150
  end
  
  def draw_work_done
    cell bounds.top_left,
      :text               => "Work done for #{@period}",
      :horizontal_padding => 5,
      :vertical_padding   => 2,
      :background_color   => "dddddd",
      :width              => 204
  end 
  
  def draw_billing_info
    table [["BILLING INFORMATION"], 
           ["Please submit payment on or before:\n#{@due}\n\nThanks!"]], 
     :border_style => :grid, :widths => {0 => 204}
  end                
    
  def save_as(file)        
    draw_invoice
    render_file(file)
  end   
    
end 